/*!
 *  @header RAErrorCode.h
 *  @abstract SDK定义的错误类型
 *  @version 2.0
 */

typedef enum {
    /** server error */
    RAErrorServerNotReachable                      = 1,          //连接服务器失败(Ex. 手机客户端无网的时候, 会返回的error)
    RAAccessTokenInvalid                           = 10000006,   //ACCESS TOKEN 失效
    RAACCESSTOKEN_EXPIRED                          = 10000005,   //ACCESS TOKEN 已过期
    TELPHONE_IDENTIFYING_CODE_NOT_MATCH            = 11000003,   //手机验证码不正确
    USER_PASSWORD_INVALID                          = 60000034,   //用户密码不正确
    USER_NOT_FOUND_BY_UK                           = 60000002,   //	用户信息未找到
    
    /** FMDBError */
    RAErrorDBTAbleCreateFail,                   //表创建失败
    RAErrorDBTAbleClearFail,                    //表清除失败
    AErrorDBJsonDataError,                      //object格式错误
    AErrorDBPutObjectFail,                      //put object失败
    AErrorDBDeleteFail,                         //delete 失败
    
    
    /** 超级大红包 */
    EVENT_SUPER_BONUS_ALREADY_JOINED               = 21000002,
    
} RAErrorCode;
