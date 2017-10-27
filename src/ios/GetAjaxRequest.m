//
// Lyxpay.m
// PluginTest
//
// Created by 冬追夏赶 on 9 / 15 / 16.
//
//

#import "GetAjaxRequest.h"

@implementation GetAjaxRequest

-(void)pluginInitialize
{
    self.wxAppId = [[self.commandDelegate settings] objectForKey:@"wx_app_id"];
    self.alipayAppId = [[self.commandDelegate settings] objectForKey:@"alipay_app_id"];
}


@end

