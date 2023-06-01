import 'package:flutter/material.dart';
import 'package:funny_time/config.dart';
import 'package:funny_time/time.dart';

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
  }

  _initData() {
    SettingManager.flushWeatherInfo(false);
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
                builder: (context) => _TextSettingPage(appbarTitle: "City, 如 Shanghai", text: globalSetting.weatherCity,),
              ));
              print(text);
              if (text != null && text != globalSetting.weatherCity) {
                globalSetting.weatherCity = text;
                SettingManager.setConfig<String>(SettingName.weatherCity, text.trim());
                _initData();
              }
            },
          ),
          ListTile(
            title: Text("接口Key (OpenWeather Apikey)"),
            subtitle: globalSetting.weatherApiKey == null ? null : Text(globalSetting.weatherApiKey!),
            trailing: Icon(Icons.chevron_right),
            onTap: () async {
              String? text = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => _TextSettingPage(appbarTitle: "Apikey", text: globalSetting.weatherApiKey,),
              ));
              print(text);
              if (text != null && text != globalSetting.weatherApiKey) {
                globalSetting.weatherApiKey = text;
                SettingManager.setConfig<String>(SettingName.openWeatherApikey, text.trim());
                _initData();
              }
            },
          ),
          ListTile(
            title: Text("强制更新天气"),
            subtitle: Text("自打开App已请求接口 ${globalSetting.weatherActiveFlushApiCount} 次"),
            onTap: () async {
              _initData();
            },
          )
        ],
      ),
    );
  }
  
}

class _TextSettingPage extends StatefulWidget {
  _TextSettingPage({super.key, this.appbarTitle = "", this.text});

  final String appbarTitle;
  String? text;

  @override
  State<StatefulWidget> createState() => _TextSettingPageState();

}

class _TextSettingPageState extends State<_TextSettingPage> {

  String? text;

  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController.fromValue(TextEditingValue(text: widget.text ?? ""));
    setState(() {});
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
            controller: _controller,
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