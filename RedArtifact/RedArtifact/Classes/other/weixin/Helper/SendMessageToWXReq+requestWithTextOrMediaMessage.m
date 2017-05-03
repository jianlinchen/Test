//
//  SendMessageToWXReq+requestWithTextOrMediaMessage.m
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SendMessageToWXReq+requestWithTextOrMediaMessage.h"

@implementation SendMessageToWXReq (requestWithTextOrMediaMessage)

+ (SendMessageToWXReq *)requestWithText:(NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene {
    SendMessageToWXReq *req = [[[SendMessageToWXReq alloc] init] autorelease];
    req.bText = bText;
    req.scene = scene;
    if (bText)
        req.text = text;
    else
        req.message = message;
    return req;
}

@end