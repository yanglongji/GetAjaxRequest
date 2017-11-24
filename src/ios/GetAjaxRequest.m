#import "GetAjaxRequest.h"
#import "MyUrlCache.h"
#import <ShareSDK/ShareSDK.h>
#import <objc/runtime.h>

@implementation GetAjaxRequest

-(void)pluginInitialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"MyUrlCache" object:nil];
}

- (void)get:(CDVInvokedUrlCommand *)command{
    MyUrlCache *cache = [[MyUrlCache alloc] init];
    [NSURLCache setSharedURLCache:cache];
    
    self.targetUrl = [NSString stringWithFormat:@"%@",command.arguments[0]];
    self.tempCommand = command;
}

- (void)clear:(CDVInvokedUrlCommand *)command{
    MyUrlCache *cache = [[MyUrlCache alloc] init];
    [cache removeAllCachedResponses];
}
    /*
- (void)clearCookie:(CDVInvokedUrlCommand *)command{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieAry = [cookieJar cookiesForURL: [NSURL URLWithString: @"https://alimama.com/"]];
    for (cookie in cookieAry) {
        [cookieJar deleteCookie: cookie];
    }
}
    */
- (void)setCookie:(CDVInvokedUrlCommand *)command{
    NSString * c = [NSString stringWithFormat:@"%@",command.arguments[0]];
    NSArray * cookies = [c componentsSeparatedByString:@";"];
    // 设置header，通过遍历cookies来一个一个的设置header
    for (NSString *cookie in cookies){
        // cookiesWithResponseHeaderFields方法，需要为URL设置一个cookie为NSDictionary类型的header，注意NSDictionary里面的forKey需要是@"Set-Cookie"
        NSArray *headeringCookie = [NSHTTPCookie cookiesWithResponseHeaderFields:
                                    [NSDictionary dictionaryWithObject: cookie forKey:@"Set-Cookie"] forURL:[NSURL URLWithString:command.arguments[1]]];
        
        // 通过setCookies方法，完成设置，这样只要一访问URL为HOST的网页时，会自动附带上设置好的header
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:headeringCookie forURL:[NSURL URLWithString:command.arguments[1]] mainDocumentURL:nil];
    }
    
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void)login:(CDVInvokedUrlCommand *)command{
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:[user rawData]] callbackId:command.callbackId];
         }
         else
         {
             NSLog(@"%@",error);
         }
     }];
}

- (void)getNotification:(NSNotification *)notification
{
    NSArray* msg = [notification object];
    if([[msg objectAtIndex:0] rangeOfString:self.targetUrl].length > 0){
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[msg objectAtIndex:1]];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.tempCommand.callbackId];
    }
}
@end

