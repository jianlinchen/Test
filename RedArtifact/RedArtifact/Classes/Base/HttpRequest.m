//
//  HttpRequest.m
//  RedArtifact
//
//  Created by LiLu on 16/7/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "HttpRequest.h"
#import "API.h"
#import "OverAllManager.h"
#import "Reachability.h"
#import "OverAllManager.h"
#import "JDHttpManager.h"

@interface HttpRequest()<ASIHTTPRequestDelegate>

@end

@implementation HttpRequest

static HttpRequest  *sharesingleton=nil;//必须声明为一个静态方法

+ (HttpRequest *)shareInstance {
    if (sharesingleton == nil){
        
        sharesingleton = [[self alloc]init];
    }
    return sharesingleton;
}

- (id)init
{
    self = [super init];
    if (self) {
        //        self.userConfig = [UserConstant new];
        
    }
    return self;
}
- (void)printRequestUrl:(NSString *)urlString params:(NSDictionary *)params {
    NSMutableString *totalUrl = [NSMutableString stringWithFormat:@"%@?", urlString];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [totalUrl appendString:[NSString stringWithFormat:@"&%@=%@", key, obj]];
        }
    }];
    DLog(@"%@请求 = %@", [params.allKeys containsObject:@"method"] && [[params[@"method"] uppercaseString] isEqualToString:@"POST"] ? @"POST" : @"GET", totalUrl);
}
#pragma 全局请求案例
-(void)Method:(SendWay)method withTransmitHeader:(NSMutableDictionary *)headerProgram withApiProgram:(NSMutableDictionary *)apiProgram withBodyProgram:(NSMutableDictionary *)bodyProgram withPathApi:(NSString *)pathApi completed:(BlifeCompletedBlock )completeBlock failed:(BlifeFailedBlock )failed{
   
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        NSString *errorDescription;
        NSString *errorDetail;
        RAErrorCode raCode;
        
        errorDescription = @"请检查网络设置";
        raCode = RAErrorServerNotReachable;
        errorDetail = @"请检查网络设置";
        
        [self errorCodeJudgmentWithCode:raCode withMessage:errorDescription withDetail:errorDetail withFailed:^(RAError *error) {
            failed(error);
        }];
         return;
    }
    
     if (method == GET) {
        //AFNetworking get 请求
        NSString *apiStr=[self split:apiProgram];
        NSString *urlStr=[NSString stringWithFormat:@"%@%@?%@",BASE_URL,pathApi,apiStr];
         
        NSString*  path= [urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         NSURL *url = [NSURL URLWithString:path];
         NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
         [request setTimeoutInterval:10];
         [request setHTTPMethod:@"GET"];
         if (headerProgram!=nil) {
             NSArray *keysArray = [headerProgram allKeys];
             NSArray *valuesArray = [headerProgram allValues];
             for (int i = 0; i < keysArray.count; i++) {
                 [request setValue:valuesArray[i] forHTTPHeaderField:keysArray[i]];
             }
         }
         
         NSURLSession *session = [NSURLSession sharedSession];
         
         NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if (data==nil) {
                     NSString *errorDescription;
                     NSString *errorDetail;
                     RAErrorCode raCode;
                     
                     errorDescription = @"请检查网络设置";
                     raCode = RAErrorServerNotReachable;
                     errorDetail = @"请检查网络设置";
                     
                     [self errorCodeJudgmentWithCode:raCode withMessage:errorDescription withDetail:errorDetail withFailed:^(RAError *error) {
                         failed(error);
                     }];
                     
                     return ;
                     
                 }
                 
                 id  jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
                 
                 DLog(@"jsonDatajsonData%@",jsonData);
                 NSDictionary *dic=jsonData;
                 if ([dic[@"message"] isEqualToString:@"OK"]) {
                     completeBlock(dic,[self logDic:dic]);
                 }else{
                     if (dic[@"code"]) {
                         [self errorCodeJudgmentWithCode:[dic[@"code"] integerValue] withMessage:dic[@"message"] withDetail:dic[@"detail"] withFailed:^(RAError *error) {
                             failed(error);
                         }];
                     }else{
                         
                         DLog(@"可能没有网络");
                     }
                 }
                 
                 
             });
         }];
         
     [task resume];     
                
    } else if(method == POST) {
        NSString *apiStr=[self split:apiProgram];
        NSString *urlStr=[NSString stringWithFormat:@"%@%@?%@",BASE_URL,pathApi,apiStr];
         NSString*  path= [urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [NSURL URLWithString:path];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:10];
        if (headerProgram!=nil) {
            NSArray *keysArray = [headerProgram allKeys];
            NSArray *valuesArray = [headerProgram allValues];
            for (int i = 0; i < keysArray.count; i++) {
                [request setValue:valuesArray[i] forHTTPHeaderField:keysArray[i]];
            }
        }
        [request setHTTPMethod:@"POST"];
        NSData *jsondata;
           if (self.isVlaueKey) {
               if (bodyProgram!=nil) {
              NSString *bodyStr=[self split:bodyProgram];
              jsondata =[bodyStr dataUsingEncoding:NSUTF8StringEncoding];

               }
            }else{
                if (bodyProgram!=nil) {
                    jsondata=[NSJSONSerialization dataWithJSONObject:bodyProgram options:0 error:nil];
                }
              
            }
         [request  setHTTPBody:jsondata];
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (data==nil) {
                    NSString *errorDescription;
                    NSString *errorDetail;
                    RAErrorCode raCode;
                    
                    errorDescription = @"请检查网络设置";
                    raCode = RAErrorServerNotReachable;
                    errorDetail = @"请检查网络设置";
                    
                    [self errorCodeJudgmentWithCode:raCode withMessage:errorDescription withDetail:errorDetail withFailed:^(RAError *error) {
                        failed(error);
                    }];

                    return ;

                }
                
                id  jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
                
                DLog(@"jsonDatajsonData%@",jsonData);
                NSDictionary *dic=jsonData;
                if ([dic[@"message"] isEqualToString:@"OK"]) {
                    completeBlock(dic,[self logDic:dic]);
                }else{
                    if (dic[@"code"]) {
                        [self errorCodeJudgmentWithCode:[dic[@"code"] integerValue] withMessage:dic[@"message"] withDetail:dic[@"detail"] withFailed:^(RAError *error) {
                            failed(error);
                        }];
                    }else{
                        
                        DLog(@"可能没有网络");
                    }
                }

                
             });
        }];
         [task resume];
        
    }else if(method == PUT){
        
        NSString *apiStr=[self split:apiProgram];
        NSString *urlStr=[NSString stringWithFormat:@"%@%@?%@",BASE_URL,pathApi,apiStr];
        NSString*  path= [urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [NSURL URLWithString:path];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:10];
        if (headerProgram!=nil) {
            NSArray *keysArray = [headerProgram allKeys];
            NSArray *valuesArray = [headerProgram allValues];
            for (int i = 0; i < keysArray.count; i++) {
                [request setValue:valuesArray[i] forHTTPHeaderField:keysArray[i]];
            }
        }
        [request setHTTPMethod:@"PUT"];
       
       NSData* jsondata=[NSJSONSerialization dataWithJSONObject:bodyProgram options:0 error:nil];
        
        [request  setHTTPBody:jsondata];
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data==nil) {
                    NSString *errorDescription;
                    NSString *errorDetail;
                    RAErrorCode raCode;
                    
                    errorDescription = @"请检查网络设置";
                    raCode = RAErrorServerNotReachable;
                    errorDetail = @"请检查网络设置";
                    
                    [self errorCodeJudgmentWithCode:raCode withMessage:errorDescription withDetail:errorDetail withFailed:^(RAError *error) {
                        failed(error);
                    }];
                    return ;

                    
                }
             id  jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
                
                DLog(@"jsonDatajsonData%@",jsonData);
                
                NSDictionary *dic=jsonData;
                if ([dic[@"message"] isEqualToString:@"OK"]) {
                    completeBlock(dic,[self logDic:dic]);
                }else{
                    if (dic[@"code"]) {
                        [self errorCodeJudgmentWithCode:[dic[@"code"] integerValue] withMessage:dic[@"message"] withDetail:dic[@"detail"] withFailed:^(RAError *error) {
                            failed(error);
                        }];
                    }else{
                        
                        DLog(@"可能没有网络");
                    }
                }
                
            });
        }];
        [task resume];
  
        
    }else if(method == DELETE){
        
        NSString *apiStr=[self split:apiProgram];
        NSString *urlStr=[NSString stringWithFormat:@"%@%@?%@",BASE_URL,pathApi,apiStr];
        NSString*  path= [urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [NSURL URLWithString:path];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setTimeoutInterval:10];
        if (headerProgram!=nil) {
            NSArray *keysArray = [headerProgram allKeys];
            NSArray *valuesArray = [headerProgram allValues];
            for (int i = 0; i < keysArray.count; i++) {
                [request setValue:valuesArray[i] forHTTPHeaderField:keysArray[i]];
            }
        }
        [request setHTTPMethod:@"DELETE"];
        
        NSData* jsondata=[NSJSONSerialization dataWithJSONObject:bodyProgram options:0 error:nil];
        
        [request  setHTTPBody:jsondata];
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (data==nil) {
                    NSString *errorDescription;
                    NSString *errorDetail;
                    RAErrorCode raCode;
                    
                    errorDescription = @"请检查网络设置";
                    raCode = RAErrorServerNotReachable;
                    errorDetail = @"请检查网络设置";
                    
                    [self errorCodeJudgmentWithCode:raCode withMessage:errorDescription withDetail:errorDetail withFailed:^(RAError *error) {
                        failed(error);
                    }];
                    return ;
                    
                }
                id  jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
                
                DLog(@"jsonDatajsonData%@",jsonData);
                
                NSDictionary *dic=jsonData;
                if ([dic[@"message"] isEqualToString:@"OK"]) {
                    completeBlock(dic,[self logDic:dic]);
                }else{
                    if (dic[@"code"]) {
                        [self errorCodeJudgmentWithCode:[dic[@"code"] integerValue] withMessage:dic[@"message"] withDetail:dic[@"detail"] withFailed:^(RAError *error) {
                            failed(error);
                        }];
                    }else{
                        
                        DLog(@"可能没有网络");
                    }
                }
                
            });
        }];
        [task resume];
        
    }
}

// 字典转成api字符串
-(NSString *)split:(NSMutableDictionary *)dic{
     NSMutableArray *stringArray = [NSMutableArray new];
    //遍历apiProgram
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj,   BOOL *stop) {
//        NSLog(@"key = %@ and obj = %@", key, obj);
        
        [stringArray addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
    }];
    
    NSMutableString *mutStr=[NSMutableString new];
    for (int i=0; i<stringArray.count; i++) {
        NSString *str2=stringArray[i];
        [mutStr appendString:[NSString stringWithFormat:@"%@&",str2]];
    }
    NSString  *str;
    if (mutStr.length>0) {
        str=[mutStr  substringToIndex:(mutStr.length -1)];
    } else {
        str=@"";
    }
    
    return str;
}

#pragma 上传图片
- (void)PutImageData:(NSDictionary *)program addImage:(UIImage *)image  dataApi:(NSString *)apiPath completed:(BlifeCompletedBlock )completeBlock failed:(BlifeFailedBlock )failed{
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        NSString *errorDescription;
        NSString *errorDetail;
        RAErrorCode raCode;
        
        errorDescription = @"请检查网络设置";
        raCode = RAErrorServerNotReachable;
        errorDetail = @"请检查网络设置";
        
        [self errorCodeJudgmentWithCode:raCode withMessage:errorDescription withDetail:errorDetail withFailed:^(RAError *error) {
            failed(error);
        }];
        
        return;
    }
    NSData *data;
    UIImage *imagei=image;
    data = UIImageJPEGRepresentation(imagei, 0.7);
      NSString *accessTokenStr = [User sharedInstance].accesstoken;;
    
    NSMutableArray *stringArray = [NSMutableArray new];
    
    //遍历Dic字段
    [program enumerateKeysAndObjectsUsingBlock:^(id key, id obj,   BOOL *stop) {
        DLog(@"key = %@ and obj = %@", key, obj);
        
        [stringArray addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
    }];
    
    NSMutableString *mutStr=[NSMutableString new];
    for (int i=0; i<stringArray.count; i++) {
        NSString *str2=stringArray[i];
        [mutStr appendString:[NSString stringWithFormat:@"%@&",str2]];
    }
    NSString  *Str;
    if (mutStr.length > 0) {
        Str=[mutStr  substringToIndex:(mutStr.length -1)];
    } else {
        Str=@"";
    }
    
    NSString *requestUrl=[NSString stringWithFormat:@"%@%@?%@",BASE_URL,apiPath,Str];
    NSString*  path= [requestUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"PUT"];
    [request setValue:accessTokenStr forHTTPHeaderField:@"ACCESS-TOKEN"];

    [request  setHTTPBody:data];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data==nil) {
                NSString *errorDescription;
                NSString *errorDetail;
                RAErrorCode raCode;
                
                errorDescription = @"请检查网络设置";
                raCode = RAErrorServerNotReachable;
                errorDetail = @"请检查网络设置";
                
                [self errorCodeJudgmentWithCode:raCode withMessage:errorDescription withDetail:errorDetail withFailed:^(RAError *error) {
                    failed(error);
                }];
                
                return ;
            }
        id  jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
            NSDictionary *dic=jsonData;
            if ([dic[@"message"] isEqualToString:@"OK"]) {
                 completeBlock(dic,[self logDic:dic]);
            }else{
                if (dic[@"code"]) {
              [self errorCodeJudgmentWithCode:[dic[@"code"] integerValue] withMessage:dic[@"message"] withDetail:dic[@"detail"] withFailed:^(RAError *error) {
                        failed(error);
                  }];
                }else{
                    
                    DLog(@"可能没有网络");
                }
            }
         
            
            
        });
    }];
    [task resume];
    
}

#pragma 获取验证码(分开请求验证码是因为，不需要tocken授权。从某方面来说简单，但需要优化)
-(void)getidentifyingcode:(NSDictionary *)program dataApi:(NSString *)path completed:(BlifeCompletedBlock )completeBlock failed:(BlifeFailedBlock )failed{
        
    NSMutableArray *stringArray = [NSMutableArray new];
    
    //遍历Dic字段
    [program enumerateKeysAndObjectsUsingBlock:^(id key, id obj,   BOOL *stop) {
        DLog(@"key = %@ and obj = %@", key, obj);
        
        [stringArray addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
    }];
    NSMutableString *mutStr=[NSMutableString new];
    
    for (int i=0; i<stringArray.count; i++) {
        NSString *str2=stringArray[i];
        [mutStr appendString:[NSString stringWithFormat:@"%@&",str2]];
    }
    
    NSString  *programStr=[mutStr  substringToIndex:(mutStr.length -1)];
    
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@?%@",BASE_URL,path,programStr];
    
    NSString*  pathStr= [urlStr  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:pathStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data==nil) {
                NSString *errorDescription;
                NSString *errorDetail;
                RAErrorCode raCode;
                
                errorDescription = @"请检查网络设置";
                raCode = RAErrorServerNotReachable;
                errorDetail = @"请检查网络设置";
                
                [self errorCodeJudgmentWithCode:raCode withMessage:errorDescription withDetail:errorDetail withFailed:^(RAError *error) {
                    failed(error);
                }];
                
                return ;
            }
            
            id  jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
            NSDictionary *dic=jsonData;
            if ([dic[@"message"] isEqualToString:@"OK"]) {
                completeBlock(dic,[self logDic:dic]);
            }else{
                if (dic[@"code"]) {
                    [self errorCodeJudgmentWithCode:[dic[@"code"] integerValue] withMessage:dic[@"message"] withDetail:dic[@"detail"] withFailed:^(RAError *error) {
                        failed(error);
                    }];
                }else{
                    
                    DLog(@"可能没有网络");
                }
            }
            
            
            
        });
    }];
    [task resume];
}

- (void)errorCodeJudgmentWithCode:(NSInteger)code withMessage:(NSString *)message withDetail:(NSString *)detail withFailed:(BlifeFailedBlock)failed {
    NSString *errorDescription;
    NSString *errorDetail;
    RAErrorCode raCode;
    switch (code) {
        case RAErrorServerNotReachable:
        {
            errorDescription = @"请检查网络设置";
            raCode = RAErrorServerNotReachable;
            errorDetail = @"请检查网络设置";
            break;
        }
        case RAAccessTokenInvalid:
        {
            errorDescription = @"ACCESS TOKEN 失效";
            raCode = RAAccessTokenInvalid;
            errorDetail = detail;

            NSString * orStr = [[NSUserDefaults standardUserDefaults] objectForKey:OrAlertView];
            
            if (![orStr isEqualToString:@"1"]) {
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:OrAlertView];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"quitToLoginVC" object:nil];
            }

    
            break;
        }
        case RAACCESSTOKEN_EXPIRED:
        {
            
            NSString * orStr = [[NSUserDefaults standardUserDefaults] objectForKey:OrAlertView];
            
            if (![orStr isEqualToString:@"1"]) {
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:OrAlertView];
      
                [[NSNotificationCenter defaultCenter] postNotificationName:@"quitToLoginVC" object:nil];
            }

         raCode = RAACCESSTOKEN_EXPIRED;
            errorDetail = detail;
            break;
        }
        case USER_PASSWORD_INVALID:
        {
            errorDescription = @"用户名或密码错误";
            raCode = USER_PASSWORD_INVALID;
            errorDetail = detail;
            break;
        }
        case TELPHONE_IDENTIFYING_CODE_NOT_MATCH:
        {
            errorDescription = @"手机验证码不正确";
            raCode = TELPHONE_IDENTIFYING_CODE_NOT_MATCH;
            errorDetail = detail;
            break;
        }
        case USER_NOT_FOUND_BY_UK:
        {
            errorDescription = @"用户信息未找到";
            raCode = USER_NOT_FOUND_BY_UK;
            errorDetail = detail;
            break;
        }
        case EVENT_SUPER_BONUS_ALREADY_JOINED:
        {
            errorDescription = @"已参与超级红包活动";
            raCode = EVENT_SUPER_BONUS_ALREADY_JOINED;
            errorDetail = detail;
            break;
        }

        default:
        {
            errorDescription = message;
            errorDetail = detail;
            raCode = code;
            DLog(@"code=%ld, description=%@",(long)code,message);
            break;
        }
    }
    
    RAError *error = [[RAError alloc] initWithDescription:errorDescription code:raCode errorDetail:errorDetail];
    failed(error);
}


#pragma 去掉反斜杠，更好显示请求到的数据
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)getWeixin:(NSDictionary *)program dataApi:(NSString *)path completed:(BlifeCompletedBlock )completeBlock failed:(BlifeFailedBlock )failed{
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if (![reach isReachable]) {
        NSString *errorDescription;
        NSString *errorDetail;
        RAErrorCode raCode;
        
        errorDescription = @"请检查网络设置";
        raCode = RAErrorServerNotReachable;
        errorDetail = @"请检查网络设置";
        
        [self errorCodeJudgmentWithCode:raCode withMessage:errorDescription withDetail:errorDetail withFailed:^(RAError *error) {
            failed(error);
        }];
        
        return;
    }
    NSString*  pathStr= [path  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:pathStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
     [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data==nil) {
                NSString *errorDescription;
                NSString *errorDetail;
                RAErrorCode raCode;
                
                errorDescription = @"请检查网络设置";
                raCode = RAErrorServerNotReachable;
                errorDetail = @"请检查网络设置";
                
                [self errorCodeJudgmentWithCode:raCode withMessage:errorDescription withDetail:errorDetail withFailed:^(RAError *error) {
                    failed(error);
                }];
                
                return ;
            }
            id  jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
            NSDictionary *dic=jsonData;
             completeBlock(dic,dic.description);
            
//            if ([dic[@"message"] isEqualToString:@"OK"]) {
//                completeBlock(dic,[self logDic:dic]);
//            }else{
//                if (dic[@"code"]) {
//                    [self errorCodeJudgmentWithCode:[dic[@"code"] integerValue] withMessage:dic[@"message"] withDetail:dic[@"detail"] withFailed:^(RAError *error) {
//                        failed(error);
//                    }];
//                }else{
//                    
//                    NSLog(@"可能没有网络");
//                }
//            }
            
            
            
        });
    }];
    [task resume];
}

- (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}


#pragma mark - AFNetworking
- (void)AFNetworkingGetData {
    
}

@end
