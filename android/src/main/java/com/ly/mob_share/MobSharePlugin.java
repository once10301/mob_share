package com.ly.mob_share;

import java.util.HashMap;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.onekeyshare.OnekeyShare;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.wechat.friends.Wechat;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class MobSharePlugin implements MethodCallHandler {

  private Registrar registrar;

  private MobSharePlugin(Registrar registrar) {
    this.registrar = registrar;
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "mob_share");
    channel.setMethodCallHandler(new MobSharePlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    Listener listener = new Listener();
    switch (call.method) {
      case "register":
        break;
      case "auth":
        int type = (int) call.arguments;
        String name = "";
        switch (type){
          case 997:
            name = Wechat.NAME;
            break;
          case 998:
            name = QQ.NAME;
            break;
          case 1:
            name = SinaWeibo.NAME;
            break;
        }
        listener.setResult(result);
        Platform qqPlatform = ShareSDK.getPlatform(name);
        qqPlatform.setPlatformActionListener(listener);
        qqPlatform.authorize();
        break;
      case "share":
        String title = call.argument("title");
        String text = call.argument("text");
        String imagePath = call.argument("imagePath");
        String url = call.argument("url");
        String titleUrl = call.argument("titleUrl");
        showShare(title, text, imagePath, url, titleUrl);
        result.success(null);
        break;
    }
  }

  private class Listener implements PlatformActionListener {

    private Result result;

    void setResult(Result result) {
      this.result = result;
    }

    @Override
    public void onComplete(Platform platform, int i, HashMap<String, Object> hashMap) {
      HashMap<String, Object> data = new HashMap<>();
      data.put("uid", platform.getDb().getUserId());
      data.put("nickname", platform.getDb().getUserName());
      data.put("icon", platform.getDb().getUserIcon());
      HashMap<String, Object> map = new HashMap<>();
      map.put("status", 0);
      map.put("msg", "success");
      map.put("data", data);
      result.success(map);
    }

    @Override
    public void onError(Platform platform, int i, Throwable throwable) {
      HashMap<String, Object> map = new HashMap<>();
      map.put("status", 1);
      map.put("msg", throwable.getMessage());
      result.success(map);
    }

    @Override
    public void onCancel(Platform platform, int i) {
      HashMap<String, Object> map = new HashMap<>();
      map.put("status", 2);
      map.put("msg", "cancel");
      result.success(map);
    }
  }

  private void showShare(String title, String text, String imagePath, String url, String titleUrl) {
    OnekeyShare oks = new OnekeyShare();
    //关闭sso授权
    oks.disableSSOWhenAuthorize();
    // title标题，微信、QQ和QQ空间等平台使用
    oks.setTitle(title);
    // text是分享文本，所有平台都需要这个字段
    oks.setText(text);
    // imagePath是图片的本地路径，Linked-In以外的平台都支持此参数
    if(imagePath != null) {
      oks.setImagePath(imagePath);
    }
    // url在微信、微博，Facebook等平台中使用
    if(url != null) {
      oks.setUrl(url);
    }
    // titleUrl QQ和QQ空间跳转链接
    if(titleUrl != null) {
      oks.setTitleUrl(titleUrl);
    }
    // comment是我对这条分享的评论，仅在人人网使用
    // oks.setComment("我是测试评论文本");
    // 启动分享GUI
    oks.show(registrar.activity());
  }
}
