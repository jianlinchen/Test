//
//  OverAllManager.m
//  RedArtifact
//
//  Created by LiLu on 16/7/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#import "OverAllManager.h"

@implementation OverAllManager

static OverAllManager  *sharesingleton=nil;//必须声明为一个静态方法
+ (OverAllManager *)shareInstance {
    if (sharesingleton == nil){
        
        sharesingleton = [[self alloc]init];
    }
    return sharesingleton;
}
+ (void)OpenFMDataBase{
    
    [DataBaseManager openDataBase];
    [DataBaseManager createTables];
}
- (id)init
{
    self = [super init];
    if (self) {
//        self.userConfig = [UserConstant new];
        
    }
    return self;
}

#pragma mark - 字典转json
-(NSString*)dictionaryToJson:(NSMutableDictionary *)dic{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - 时间戳获取函数
- (NSString *)dateString{
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]*1000;//*1000 是精确到毫秒，不乘就是精确到秒
    a *= 1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f",a]; //转为字符型
    NSLog(@"%ld", time(NULL));
    
    return timeString;
}
#pragma mark - 将NSDate按yyyy-MM-dd HH:mm:ss格式时间输出
-(NSString *)NSdateToString{
    NSDate *fromdate=[NSDate date];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* string=[dateFormat stringFromDate:fromdate];
    return string;
}

#pragma mark 文字高度
- (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
        limitWidth:(float)width
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin//|NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    rect.size.width=width;
    rect.size.height=ceil(rect.size.height);
    return rect.size;
}

#pragma mark 文字宽度
- (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
       limitHeight:(float)height
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin//|NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    rect.size.height=height;
    rect.size.width=ceil(rect.size.width);
    return rect.size;
}
#pragma mark 裁剪图片尺寸倍数
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark 压缩图片到新的尺寸
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
#pragma mark 压缩大小（M）
-(NSData *)data :(UIImage *)image{
    
  NSData * newdata = UIImageJPEGRepresentation(image, 0.5);
  return newdata;

}

#pragma mark 获取版本号
-(NSString *)getverson{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion      = infoDictionary[@"CFBundleShortVersionString"];
    return currentVersion;
}

#pragma mark 弹出警示框
+(void)alertView:(NSString *)title{
    
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [view show];
    
}
@end
