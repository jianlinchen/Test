//
//  Tools.m
//  RedArtifact
//
//  Created by xiaoma on 16/8/8.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "Tools.h"
#import "Server.h"
#import<CommonCrypto/CommonDigest.h>
#import "RAUserInfo.h"

@implementation Tools

/*
 * 价格计算
 */
+ (NSString *)decimalNumberCalucate:(NSString *)originValue1 originValue2:(NSString *)originValue2 calucateWay:(calucateWay)calucateWay {
    NSDecimalNumber *decimalNumber1 = [NSDecimalNumber decimalNumberWithString:originValue1];
    NSDecimalNumber *decimalNumber2 = [NSDecimalNumber decimalNumberWithString:originValue2];
    NSDecimalNumber *product;
    switch (calucateWay) {
        case Adding:
            product = [decimalNumber1 decimalNumberByAdding:decimalNumber2];
            break;
            
        case Subtracting:
            product = [decimalNumber1 decimalNumberBySubtracting:decimalNumber2];
            break;
            
        case Multiplying:
            product = [decimalNumber1 decimalNumberByMultiplyingBy:decimalNumber2];
            break;
            
        case Dividing:
            product = [decimalNumber1 decimalNumberByDividingBy:decimalNumber2];
            break;
            
        default:
            break;
    }
    return [product stringValue];
}

/*
 * 设置Navigation标题
 */
+ (NSDictionary *)getNavigationBarTitleTextAttributes {
    NSShadow *shadow   = [[NSShadow alloc] init];
    shadow.shadowColor = RGBHex(0X333333);
    NSDictionary *dic  = [NSDictionary
                          dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], [UIFont systemFontOfSize:20.0f], shadow, nil]
                          forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, NSShadowAttributeName, nil]];
    
    return dic;
}

/*
 * 打开其他app
 */
+ (void)openOtherAPPWithURL:(NSString *)appUrl withiTunesURL:(NSString *)iTunesUrl withSuccess:(OpenSuccess)success {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
        success(YES);
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:iTunesUrl]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesUrl]];
        success(YES);
    } else {
        success(NO);
    }
}

/*
 * 倒计时时间计算
 */
+ (NSDictionary *)timeAfterWithInterval:(NSString *)interval {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSTimeInterval timeInterval = [interval floatValue];
    int day = (int)(timeInterval/86400);
    int hour = (int)((timeInterval - day*86400)/3600);
    int minute = (int)(timeInterval - day*86400 - hour*3600)/60;
    int second = (int)(timeInterval - day*86400 - hour*3600 - minute*60);
    
    [dic setValue:[NSString stringWithFormat:@"%d",day] forKey:@"day"];
    [dic setValue:[NSString stringWithFormat:@"%d",hour] forKey:@"hour"];
    [dic setValue:[NSString stringWithFormat:@"%d",minute] forKey:@"minute"];
    [dic setValue:[NSString stringWithFormat:@"%d",second] forKey:@"second"];
    
    return dic;
}

/*
 * 设置text默认字体
 */
+ (void)setTextFieldPlaceHolder:(UITextField *)textfield withTitle:(NSString *)title withColor:(NSInteger)color {
    textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:color]}];
    
}

/*
 * 获取验证码倒计时功能处理
 */
+ (void)setTimerWithTimecount:(int)timercount timerRuning:(timerRuning)timerRuning tiemrInvalid:(timerInvalid)timerInvalid {
    __block int timeout = timercount - 1;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                timerInvalid(YES);
            });
        }else{
            int seconds = timeout % timercount;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                timerRuning(strTime);
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
}

/*
 * 有accesstoken
 ＊ 获取系统配置
 */
+ (void)getServerKeyConfig {
    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    [header setValue:[User sharedInstance].accesstoken forKey:@"ACCESS-TOKEN"];
    
    [[HttpRequest shareInstance] Method:GET withTransmitHeader:header withApiProgram:nil withBodyProgram:nil withPathApi:GetServerConfig completed:^(id data, NSString *stringData) {
        if (data) {
            
            Server *server = [Server shareInstance];
            server.password_secret_key
            = data[@"data"][@"password_secret_key"] ? data[@"data"][@"password_secret_key"] : @"";
            server.push_alias_id = data[@"data"][@"push_alias_id"]?data[@"data"][@"push_alias_id"]:@"";
            server.server_tel = data[@"data"][@"contact"][@"phone"] ? data[@"data"][@"contact"][@"phone"] : @"010-65585859";
            //举报内容
            server.accusation_options = data[@"data"][@"accusation_options"]?data[@"data"][@"accusation_options"]:@"";
            //分享内容
            server.description_unaccepted_redpacket_share = data[@"data"][@"share_info"][@"description"]?data[@"data"][@"share_info"][@"description"] : @"";
            server.description_on_accepted_redpacket_share = data[@"data"][@"share_info"][@"description_on_accepted"]?data[@"data"][@"share_info"][@"description_on_accepted"] : @"";
            server.description_on_pay_success = data[@"data"][@"share_info"][@"description_on_pay_success"]?data[@"data"][@"share_info"][@"description_on_pay_success"] : @"";
            server.super_bonus_description = data[@"data"][@"share_info"][@"super_bonus_description"]?data[@"data"][@"share_info"][@"super_bonus_description"] : @"";
            server.redpacket_share_title = data[@"data"][@"share_info"][@"title"]?data[@"data"][@"share_info"][@"title"] : @"";
            server.share_link = data[@"data"][@"share_info"][@"link"]?data[@"data"][@"share_info"][@"link"] : @"";
            
            if (data[@"data"][@"promotion_share_info"]) {
                
                server.promotion_share_info=data[@"data"][@"promotion_share_info"];
            }
            // 提现声明
            server.suggest_words=data[@"data"][@"suggest_words"];
            
            // 提现次数


            server.transfer_min_amount=data[@"data"][@"global_params"][@"transfer_min_amount"]?data[@"data"][@"global_params"][@"transfer_min_amount"] : @"";

            
            [server save];
        }
    } failed:^(RAError *error) {
        if (error) {
            DLog(@"失败%@",error.errorDescription);
        }
    }];
}

/*
 * 没有accesstoken
 ＊ 获取系统配置
 */
+ (void)getServerKeyCommon {
    NSMutableDictionary *apiProgram = [[NSMutableDictionary alloc] init];
    [apiProgram setValue:APPID forKey:@"app_id"];
    //随机6位数
    int num = (arc4random() % 1000000);
    
    
    NSString *nonce = [NSString stringWithFormat:@"%.6d", num];
    
    
    [apiProgram setValue:nonce forKey:@"nonce"];
    //当前时间戳c
    NSString *time = [NSDate getCurrentDateInterval];
    
    [apiProgram setValue:time forKey:@"time"];
    //sign
    
    NSString *sign = [NSString stringWithFormat:@"%@%@%@%@",APPID,APPSECRETKEY,nonce,time];
    
    //sha1加密
    const char *cstr = [sign cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:sign.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    NSString *shaStr = output;
    [apiProgram setValue:shaStr forKey:@"sign"];
    
    
    [[HttpRequest shareInstance] Method:GET withTransmitHeader:nil withApiProgram:apiProgram withBodyProgram:nil withPathApi:GetServerCommon completed:^(id data, NSString *stringData) {
        if (data) {
            Server *server = [Server shareInstance];
            server.password_secret_key_common
            = data[@"data"][@"password_secret_key"] ? data[@"data"][@"password_secret_key"] : @"";
            [server save];
        }
    } failed:^(RAError *error) {
        if (error) {
            DLog(@"失败%@",error.errorDescription);
        }
    }];
}

/*
 * 获取服务器时间
 */
+ (void)getServerTimeSuccess:(getServerTimeSuccess)servertime {
    __block NSInteger temptime = 0;
    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    [header setValue:[User sharedInstance].accesstoken forKey:@"ACCESS-TOKEN"];
    
    [[HttpRequest shareInstance] Method:GET withTransmitHeader:header withApiProgram:nil withBodyProgram:nil withPathApi:GetServerTime completed:^(id data, NSString *stringData) {
        if (data[@"data"][@"timestamp"]) {
            temptime = [data[@"data"][@"timestamp"] integerValue];
            servertime(temptime);
        } else {
            temptime = [[NSDate date] timeIntervalSince1970];
            servertime(temptime);
        }
    } failed:^(RAError *error) {
        temptime = [[NSDate date] timeIntervalSince1970];
        servertime(temptime);
    }];

}

/*
 * 拨打电话
 */
+ (void)callPhoneWithTel:(NSString *)tel {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

/*
 * 打开网页
 */
+ (void)openLinkWithUrl:(NSString *)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

/*
 * 电话号码隐私处理
 */
+ (NSString *)phoneNumberSecret:(NSString *)url {
    if (url.length == 11) {
        NSString *str1 = [url substringToIndex:3];
        NSRange rang = NSMakeRange(url.length - 4, 4);
        NSString *str2 = [url substringWithRange:rang];
        
        NSString *returnStr = [NSString stringWithFormat:@"%@****%@",str1,str2];
        return returnStr;
    } else {
        return url;
    }
}

+ (void)getPersonInfo{
    NSMutableDictionary *program = [[NSMutableDictionary alloc] init];
    [program setValue:[User sharedInstance].accesstoken forKey:@"ACCESS-TOKEN"];
    
    [[HttpRequest shareInstance] Method:GET withTransmitHeader:program withApiProgram:nil withBodyProgram:nil withPathApi:GetUserInfo completed:^(id data, NSString *stringData) {
        if (data) {
            
            RAUserInfo* userinfo = [RAUserInfo mj_objectWithKeyValues:data[@"data"]];
            User *user = [User sharedInstance];
            user.nickName = userinfo.nickname;
            user.userAvatar=userinfo.headimg;
            [user save];

        }
    } failed:^(RAError *error) {
        DLog(@"%@",error.errorDescription);
        
    }];

}

@end
