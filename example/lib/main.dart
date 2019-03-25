import 'package:flutter/material.dart';
import 'package:mob_share/mob_share.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Register register = Register();
    register.setupWechat("wx617c77c82218ea2c", "c7253e5289986cf4c4c74d1ccc185fb1");
    register.setupQQ("100371282", "aed9b0303e3ed1e27bae87c33761161d");
    register.setupSina("568898243", "38a4f8204cc784f81f9f0daaf31e02e3", "http://www.sharesdk.cn");
    MobShare.register(register);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => auth(Platforms.wechat),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text('微信授权'),
              ),
            ),
            GestureDetector(
              onTap: () => auth(Platforms.qq),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text('QQ授权'),
              ),
            ),
            GestureDetector(
              onTap: () => auth(Platforms.sina),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text('新浪授权'),
              ),
            ),
            GestureDetector(
              onTap: () => share(),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text('弹出分享菜单'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget item(String name, Function method) {
    return GestureDetector(
      onTap: method,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Text(name),
      ),
    );
  }

  void auth(int type) async {
    var result = await MobShare.auth(type);
    print(result.status);
    print(result.msg);
    print(result.data);
  }

  void share() {
    MobShare.share('我是标题', '我是分享文本', imagePath: 'https://flutter.dev/images/flutter-logo-sharing.png', url: 'https://flutter.dev/', titleUrl: 'https://flutter.dev/');
  }
}
