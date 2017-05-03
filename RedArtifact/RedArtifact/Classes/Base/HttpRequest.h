//
//  HttpRequest.h
//  RedArtifact
//
//  Created by LiLu on 16/7/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//

typedef enum {
    GET,
    POST,
    PUT,
    DELETE
} SendWay;

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

#define GLOBLHttp [HttpRequest shareInstance]
typedef void (^BlifeCompletedBlock)(id data,NSString *stringData);
typedef void (^BlifeFailedBlock)(RAError *error);
typedef void (^BlifeProgressBlock)(float progress);
@interface HttpRequest : NSObject<ASIHTTPRequestDelegate>

/*
 * POST方法中
 * yes:bodyProgram是value － key形式，no：bodyProgram是json形式
 */
@property (nonatomic, assign) BOOL isVlaueKey;

+ (HttpRequest *)shareInstance;

/**
 *  统一方法调用
 */

-(void)Method:(SendWay)method withTransmitHeader:(NSMutableDictionary *)headerProgram withApiProgram:(NSMutableDictionary *)apiProgram withBodyProgram:(NSMutableDictionary *)bodyProgram withPathApi:(NSString *)pathApi completed:(BlifeCompletedBlock )completeBlock failed:(BlifeFailedBlock )failed;

/**
 *  获取验证码
 */
- (void)getidentifyingcode:(NSDictionary *)program dataApi:(NSString *)path completed:(BlifeCompletedBlock )completeBlock failed:(BlifeFailedBlock )failed;

/**
 *  PUT方法，上传图片
 */
- (void)PutImageData:(NSDictionary *)program addImage:(UIImage *)image dataApi:(NSString *)apiPath completed:(BlifeCompletedBlock )completeBlock failed:(BlifeFailedBlock )failed;

- (void)getWeixin:(NSDictionary *)program dataApi:(NSString *)path completed:(BlifeCompletedBlock )completeBlock failed:(BlifeFailedBlock )failed;
@end
