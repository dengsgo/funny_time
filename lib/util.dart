import 'dart:async';
import 'dart:io';
import 'package:funny_time/config.dart';
import 'package:http/http.dart' as http;

class PanicMessage {
  PanicMessage(this.eCode, this.eMsg);
  final String eCode;
  final String eMsg;
}

class PanicReporter {
  PanicReporter();
  static push(PanicMessage message) {
    pubstaticHmJpgReport(message.eCode, message.eMsg);
  }
}

// 匿名上报日志，仅用来统计和上报错误日志。不包含任何用户私人数据！！
void pubstaticHmJpgReport(String e, [String msg = ""]) async {
  var url = Uri.https(
      "pubstatic.yoytang.com",
      "/funny-time/hm.jpg",
      {
        "e": e,
        "uuid": globalSetting.uuid,
        "v": appVersionCode,
        "pf": getOperateSystemName(),
        "msg": msg,
      }
  );
  try {
    var response = await http.get(
      url, headers: {"User-Agent": userAgent},
    ).timeout(Duration(seconds: 15));
    print("pubstaticHmJpgReport response $response");
  } catch(e) {
    print("pubstaticHmJpgReport $e");
  }
}