#import "CDVPlugin.h"

@interface GetAjaxRequest : CDVPlugin
{
    CDVInvokedUrlCommand *_tempCommand;
    NSString *_targetUrl;
}

@property(retain, nonatomic) NSString *targetUrl; // @synthesize targetUrl=_targetUrl;
@property(retain, nonatomic) CDVInvokedUrlCommand *tempCommand; // @synthesize tempCommand=_tempCommand;

- (void)pluginInitialize;
- (void)get:(CDVInvokedUrlCommand *)command;
- (void)clearCookie:(CDVInvokedUrlCommand *)command;
- (void)setCookie:(CDVInvokedUrlCommand *)command;
- (void)openURL:(CDVInvokedUrlCommand *)command;

@end
