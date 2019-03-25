#import "MobSharePlugin.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ShareSDK+Base.h>

@implementation MobSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"mob_share"
                                     binaryMessenger:[registrar messenger]];
    MobSharePlugin* instance = [[MobSharePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"register" isEqualToString:call.method]) {
        [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
            [call.arguments enumerateKeysAndObjectsUsingBlock:^(id key, NSDictionary *obj, BOOL * _Nonnull stop) {
                [platformsRegister.platformsInfo setObject:obj.mutableCopy forKey:[NSString stringWithFormat:@"%@",key]];
            }];
        }];
    } else if ([@"auth" isEqualToString:call.method]) {
        NSInteger type = [call.arguments integerValue];
        [ShareSDK authorize:type settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            if (state == SSDKResponseStateSuccess) {
                NSLog(@"%@",user.rawData);
                NSDictionary *data = @{@"uid":user.uid, @"nickname":user.nickname, @"icon":user.icon};
                NSDictionary *dic = @{@"status":@0, @"msg":@"success", @"data":data};
                result(dic);
            } else if (state == SSDKResponseStateFail) {
                NSDictionary *dic = @{@"status":@1, @"msg":error.userInfo[@"description"]};
                result(dic);
            } else if (state == SSDKResponseStateCancel) {
                NSDictionary *dic = @{@"status":@2, @"msg":@"cancel"};
                result(dic);
            }
        }];
    } else if ([@"share" isEqualToString:call.method]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params SSDKSetupShareParamsByText:@"test" images:[UIImage imageNamed:@"shareImg.png"] url:[NSURL URLWithString:@"http://www.mob.com/"] title:@"title" type:SSDKContentTypeAuto];
        [ShareSDK share:SSDKPlatformTypeWechat parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            switch (state) {
                case SSDKResponseStateUpload:
                    // 分享视频的时候上传回调，进度信息在 userData
                    break;
                case SSDKResponseStateSuccess:
                    //成功
                    break;
                case SSDKResponseStateFail:
                {
                    NSLog(@"--%@",error.description);
                    //失败
                    break;
                }
                case SSDKResponseStateCancel:
                    //取消
                    break;
                    
                default:
                    break;
            }
        }];
    } else {
        result(FlutterMethodNotImplemented);
    }
}
@end
