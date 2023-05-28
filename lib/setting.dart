import 'package:flutter/material.dart';
import 'package:funny_time/config.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  static final String routeName = "/setting";

  @override
  State<StatefulWidget> createState() => _SettingPageState();
  
}

class _SettingPageState extends State<SettingPage> {

  String? openWeatherApikey;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() {
    openWeatherApikey = SettingManager.getConfig<String>(SettingName.openWeatherApikey);
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
          ListTile(
            title: Text("OpenWeather Apikey"),
            subtitle: Text(
                SettingManager.getConfig<String>(SettingName.openWeatherApikey) ?? "请输入",
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () async {
              String? text = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => _TextSettingPage(appbarTitle: "Apikey",),
              ));
              print(text);
              if (text != null && text != openWeatherApikey) {
                SettingManager.setConfig(SettingName.openWeatherApikey, text.trim());
              }
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