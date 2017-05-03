//
//  RAShare.h
//  RedArtifact
//
//  Created by xiaoma on 16/9/20.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"

@interface RAShare : NSObject

/**
 *  弹出一个分享列表的类似iOS6的UIActivityViewController控件，列表包含QQ、QQ空间、微信好友、朋友圈、新浪微博
 *
 *  @param controller 在该controller弹出分享列表的UIActionSheet
 *  @param shareTitle 标题，朋友圈时使用 shareText
 *  @param shareText  分享编辑页面的内嵌文字
 *  @param shareImage 可以传入`UIImage`，或者`NSData`，或者`NSString`图片url类型，分享内嵌图片,用户可以在编辑页面删除
 *  @param shareURL   分享点击跳转的URL链接
 *  @param delegate   实现分享完成后的回调对象，如果不关注分享完成的状态，可以设为nil
 */
+(void)presentSnsIconSheetView:(UIViewController *)controller
                    shareTitle:(NSString *)shareTitle
                     shareText:(NSString *)shareText
                    shareImage:(id)shareImage
                  shareLinkURL:(NSString *)shareURL
                      delegate:(id <UMSocialUIDelegate>)delegate;

@end
