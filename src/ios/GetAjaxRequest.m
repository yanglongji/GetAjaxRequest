#import "GetAjaxRequest.h"
#import "MyUrlCache.h"

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
    
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
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

- (void)getNotification:(NSNotification *)notification
{
    NSArray* msg = [notification object];
    NSLog(@"%@",[msg objectAtIndex:0]);
    if([[msg objectAtIndex:0] rangeOfString:self.targetUrl].length > 0){
        NSLog(@"%@",[msg objectAtIndex:1]);

        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[msg objectAtIndex:1]] callbackId:self.tempCommand.callbackId];
    }
}
@end

