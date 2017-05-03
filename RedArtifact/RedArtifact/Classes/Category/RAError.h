/*!
 *  @header RAError.h
 *  @abstract SDK定义的错误
 *  @version 2.0
 */

#import <Foundation/Foundation.h>

#import "RAErrorCode.h"



/*!
 *  SDK定义的错误
 */
@interface RAError : NSObject

/*!
 *  错误码
 */
@property (nonatomic) RAErrorCode code;

/*!
 *  错误描述
 */
@property (nonatomic, strong) NSString *errorDescription;

/*!
 *  错误提示
 */
@property (nonatomic, strong) NSString *errorDetail;


/*!
 *  初始化错误实例
 *
 *  @param aDescription  错误描述
 *  @param aCode         错误码
 *
 *  @result 错误实例
 */
- (instancetype)initWithDescription:(NSString *)aDescription
                               code:(RAErrorCode)aCode
                        errorDetail:(NSString *)aErrorDetail;
@end

