//
//  RAShare.m
//  RedArtifact
//
//  Created by xiaoma on 16/9/20.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "RAShare.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

@implementation RAShare

/*
 * 分享
 */
+ (void)presentSnsIconSheetView:(UIViewController *)controller shareTitle:(NSString *)shareTitle shareText:(NSString *)shareText shareImage:(id)shareImage shareLinkURL:(NSString *)shareURL delegate:(id<UMSocialUIDelegate>)delegate {
    
    UIImage *tempImage = [[UIImage alloc] init];
    
    if (([shareImage isKindOfClass:[NSString class]])) {
        tempImage = [UIImage imageWithData:[NSData
                               dataWithContentsOfURL:[NSURL URLWithString:shareImage]]];
        
    } else {
        tempImage = shareImage;

    }
    
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault];
    
    [UMSocialData defaultData].extConfig.title = shareTitle;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareURL;
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareURL;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
    
    
    [UMSocialData defaultData].extConfig.qqData.url = shareURL;
    [UMSocialData defaultData].extConfig.qzoneData.url = shareURL;
    
    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@%@",shareText,shareURL];
    
    NSMutableArray *shareName = [NSMutableArray array];
    
    if ([WXApi isWXAppInstalled]) {
        [shareName addObject:UMShareToWechatTimeline];
        [shareName addObject:UMShareToWechatSession];
    }
    
    if ([QQApiInterface isQQInstalled]) {
        [shareName addObject:UMShareToQQ];
        [shareName addObject:UMShareToQzone];
    }
    
    [shareName addObject:UMShareToSina];
    
    [UMSocialSnsService
     presentSnsIconSheetView:controller
     appKey:UMSocial_APPKEY
     shareText:shareText
     shareImage:tempImage
     shareToSnsNames:shareName delegate:delegate];
    
}

@end
