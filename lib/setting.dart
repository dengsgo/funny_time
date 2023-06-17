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
  }

  _initData() {
    SettingManager.flushWeatherInfo(false);
    _render();
  }

  _render() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final styleLarge = Theme.of(context).textTheme.titleLarge;
    return Scaffold(
      appBar: AppBar(title: Text("Setting"),),
      body: ListView(
        children: [
          _copyright(),
          ListTile(title: Text("天气", style: styleLarge,),),
          ListTile(
            title: Text("城市/地区"),
            subtitle: globalSetting.weatherSet.city == null ? null : Text(globalSetting.weatherSet.city!),
            trailing: Icon(Icons.chevron_right),
            onTap: () async {
              String? text = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => _TextSettingPage(appbarTitle: "City, 如 Shanghai", text: globalSetting.weatherSet.city,),
              ));
              print(text);
              if (text != null && text != globalSetting.weatherSet.city) {
                globalSetting.weatherSet.city = text.trim();
                globalSetting.weatherSet.storeLocal();
                _initData();
              }
            },
          ),
          ListTile(
            title: Text("接口Key (OpenWeather Apikey)"),
            subtitle: globalSetting.weatherSet.apikey == null ? null : Text(globalSetting.weatherSet.apikey!),
            trailing: Icon(Icons.chevron_right),
            onTap: () async {
              String? text = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => _TextSettingPage(appbarTitle: "Apikey", text: globalSetting.weatherSet.apikey,),
              ));
              print(text);
              if (text != null && text != globalSetting.weatherSet.apikey) {
                globalSetting.weatherSet.apikey = text.trim();
                globalSetting.weatherSet.storeLocal();
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
          ),
          Divider(),
          ListTile(title: Text("自动化", style: styleLarge,),),
          ListTile(
            title: Text("低亮度 (${globalSetting.autoSet.lowBrightnessValue})"),
            subtitle: Slider(
              value: globalSetting.autoSet.lowBrightnessValue.toDouble(),
              min: 5,
              max: 100,
              divisions: 100,
              label: "${globalSetting.autoSet.lowBrightnessValue}",
              onChanged: (v) {
                if (v.toInt() == globalSetting.autoSet.lowBrightnessValue) {
                  return;
                }
                globalSetting.autoSet.lowBrightnessValue = v.toInt();
                _render();
                globalSetting.autoSet.storeLocal();
              },
            ),
          ),
          ListTile(
            title: Text("低亮度时间段"),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              children:_timeSlots(),
            ),
          ),
          ListTile(
            title: Text(
                (){
                  double v = globalSetting.appScreenBrightnessValue < 0 ? 0 : globalSetting.appScreenBrightnessValue * 100;
                  return "常规亮度 (${v.toInt()})";
                }()
            ),
            subtitle: Slider(
              value: globalSetting.appScreenBrightnessValue < 0 ? 0 : globalSetting.appScreenBrightnessValue,
              min: 0,
              max: 1,
              label: "${globalSetting.appScreenBrightnessValue}",
              onChanged: (v) {
                if (v.toInt() == globalSetting.appScreenBrightnessValue) {
                  return;
                }
                globalSetting.appScreenBrightnessValue = v;
                _render();
              },
            ),
          ),

          Divider(),
          ListTile(title: Text("开源代码", style: styleLarge,),),
          ListTile(
            title: Text("Project"),
            subtitle: Text("https://github.com/dengsgo/funny_time"),
          ),
          ListTile(
            title: Text("MIT License"),
            subtitle: Text("https://github.com/dengsgo/funny_time/blob/master/LICENSE"),
          ),
          ListTile(
            title: Text("贡献代码"),
            subtitle: Text("https://github.com/dengsgo/funny_time/fock"),
          ),
          ListTile(
            title: Text("捐赠开发者"),
            subtitle: Text("感谢你的支持，以维持开源软件的更新！"),
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                  child: Image.asset("doc/qrcode/alipay.png",),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
                  child: Image.asset("doc/qrcode/wxpay.png",),
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(48), child: Text("到底部啦", style: styleLarge?.copyWith(color: Colors.white24), textAlign: TextAlign.center,),)
        ],
      ),
    );
  }

  _copyright() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 24,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 82,),
            SizedBox(
              width: 12,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Funny Time", style: Theme.of(context).textTheme.headlineSmall,),
                Text("版本: 1.0.1"),
                Text("A Cool Time Open-Source Display App !"),
              ],
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text("Funny Time 需要一个有趣的图标，欢迎提交你的想法！\nHttps://github.com/dengsgo/funny_time/issues",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.redAccent, fontWeight: FontWeight.bold),),
        ),
        SizedBox(height: 24,),
      ],
    );
  }

  _timeSlots() {
    final iconColor = IconTheme.of(context).color?.withOpacity(0.2);
    List<SegmentedButton> buttons = [];
    for (var i in [0,1,2,3]) {
      buttons.add(SegmentedButton<int>(
        multiSelectionEnabled: true,
        emptySelectionAllowed: true,
        segments: List.generate(6, (index) {
          final v = i*6 + index;
          return ButtonSegment(
            value: v,
            icon: Icon(Icons.remove, color: iconColor,),
            label: Text(v > 9 ? "$v" : "0$v"),
            enabled: true,
          );
        }),
        selected: globalSetting.autoSet.lowBrightnessTimeSlot?.toSet() ?? {},
        onSelectionChanged: (Set<int>? s) {
          var old = globalSetting.autoSet.lowBrightnessTimeSlot?.toSet() ?? {};
          print(old);
          globalSetting.autoSet.lowBrightnessTimeSlot = s?.toList();
          print(globalSetting.autoSet.lowBrightnessTimeSlot);
          _render();
          globalSetting.autoSet.storeLocal();
        },
      ));
    }
    return buttons;
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
              icon: Icon(Icons.done)
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