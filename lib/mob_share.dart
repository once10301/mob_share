import 'dart:async';
import 'package:flutter/services.dart';

class MobShare {
  static const MethodChannel channel = const MethodChannel('mob_share');

  static Future<dynamic> register(Register register) async {
    return await channel.invokeMethod('register', register.map);
  }
  
  static Future<Result> auth(int platform) async {
    final Map<dynamic, dynamic> auth = await channel.invokeMethod('auth', platform);
    Result result = new Result();
    result.status = auth['status'];
    result.msg = auth['msg'];
    result.data = auth['data'];
    return result;
  }

  static Future<void> share(String title, String text, {String imagePath, String url, String titleUrl}) async {
    await channel.invokeMethod('share', {'title': title, 'text': text, 'imagePath': imagePath, 'url': url, 'titleUrl': titleUrl});
  }
}

class Result {
  int status;
  String msg;
  Map data;
}

class Platforms {
  static final int wechat = 997;
  static final int qq = 998;
  static final int sina = 1;
}

class Register {

  final Map map = {};

  void setupWechat(String appId, String appSecret) {
    Map info = {'app_id': appId, 'app_secret': appSecret};
    map[Platforms.wechat] = info;
  }

  void setupQQ(String appId, String appKey) {
    Map info = {'app_id': appId, 'app_key': appKey};
    map[Platforms.qq] = info;
  }

  void setupSina(String appKey, String appSecret, String redirectUrl) {
    Map info = {
      'app_key': appKey,
      'app_secret': appSecret,
      'redirect_uri': redirectUrl
    };
    map[Platforms.sina] = info;
  }
}
