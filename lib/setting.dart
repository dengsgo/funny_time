import 'package:flutter/material.dart';
import 'package:funny_time/config.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  static final String routeName = "/setting";

  @override
  State<StatefulWidget> createState() => _SettingPageState();
  
}

class _SettingPageState extends State<SettingPage> {

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() {
    globalSetting.weatherApiKey = SettingManager.getConfig<String>(SettingName.openWeatherApikey);
    globalSetting.weatherCity = SettingManager.getConfig<String>(SettingName.weatherCity);
    if (mounted) {
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Setting"),),
      body: ListView(
        children: [
          ListTile(title: Text("天气", style: Theme.of(context).textTheme.titleLarge,),),
          ListTile(
            title: Text("城市/地区"),
            subtitle: globalSetting.weatherCity == null ? null : Text(globalSetting.weatherCity!),
            trailing: Icon(Icons.chevron_right),
            onTap: () async {
              String? text = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => _TextSettingPage(appbarTitle: "City, 如 Shanghai",),
              ));
              print(text);
              if (text != null && text != globalSetting.weatherCity) {
                SettingManager.setConfig(SettingName.weatherCity, text.trim());
              }
              _initData();
            },
          ),
          ListTile(
            title: Text("接口Key (OpenWeather Apikey)"),
            subtitle: globalSetting.weatherApiKey == null ? null : Text(globalSetting.weatherApiKey!),
            trailing: Icon(Icons.chevron_right),
            onTap: () async {
              String? text = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => _TextSettingPage(appbarTitle: "Apikey",),
              ));
              print(text);
              if (text != null && text != globalSetting.weatherApiKey) {
                SettingManager.setConfig(SettingName.openWeatherApikey, text.trim());
              }
              _initData();
            },
          ),
          ListTile(
            title: Text("强制更新天气"),
            subtitle: Text("自打开App已请求接口 ${globalSetting.weatherActiveFlushApiCount} 次"),
            onTap: () async {
              await SettingManager.flushWeatherInfo(false);
              _initData();

            },
          )
        ],
      ),
    );
  }
  
}

class _TextSettingPage extends StatefulWidget {
  const _TextSettingPage({super.key, this.appbarTitle = ""});

  final String appbarTitle;

  @override
  State<StatefulWidget> createState() => _TextSettingPageState();

}

class _TextSettingPageState extends State<_TextSettingPage> {

  String? text;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appbarTitle),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context, text);
              },
              icon: Icon(Icons.save)
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        children: [
          TextField(
            onChanged: (value) {
              text = value;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: widget.appbarTitle,
            ),
          )
        ],
      ),
    );
  }
  
}