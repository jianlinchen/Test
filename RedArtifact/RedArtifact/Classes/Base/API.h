//
//  API.h
//  RedArtifact
//
//  Created by LiLu on 16/7/25.
//  Copyright © 2016年 jianlin. All rights reserved.
//

#ifndef API_h
#define API_h
#endif /* API_h */


/*------------------------打包前注意更换对应环境--------------------------*/

//开发环境-Start
#define BASE_URL              @"http://api.blife-tech.com/v1/"
#define BASE_H5URl            @"http://dev.blife-tech.com"
//内部开发环境-End


//测试环境-Start
//#define BASE_URL            @"http://bizapi.dev.blife-tech.com:80/"
//#define BASE_H5URl          @"http://dev.blife-tech.com"
//测试环境-End


//上架或者上线环境-Start
//#define BASE_H5URl          @"http://www.blife-tech.com"
//#define BASE_URL            @"http://bizapi.blife-tech.com/"
//上架或者上线环境-End
/*-------------------------打包前注意更换对应环境---------*/

/**
 *  获取服务器Common配置
 */
#define GetServerCommon          @"server/common"

/**
 *  获取服务器配置
 */
#define GetServerConfig           @"server/config"


/**
 *  获取服务器时间
 */
#define GetServerTime             @"server/time"


/**
 *  重置密码
 */
#define RestUserPassword          @"user/password"


/**
 *  验证码
 */
#define GetDentifyingcode          @"user/identifyingcode"

/**
 *  获取广告信息
 */
#define GetAdvertisementdetail     @"advertisement/detail"

/**
 *  刷新token
 */
#define GetUserRefreshtoken        @"user/refreshtoken"

/**
 *  获取用户信息
 */
#define GetUserInfo                @"user/info"

/**
 *  获取用户token
 */
#define GetUserAuthentication      @"user/authentication"

/**
 *  上传图片
 */
#define PutFileImage               @"file/image"//上传图片

/**
 *  上报用户位置
 */
#define PostUserPosition           @"user/position"

/**
 *  删除广告信息
 */
#define DeleteAdPubldetail         @"advertisement/publishdetail"

/**
 *  创建广告信息
 */
#define PublishAdDetail               @"advertisement/detail"


/**
 *  广告图片轮播
 */
#define GetAdvposTurns                @"advpos/turns"


/**
 *  获取应用插件列表
 */
#define GetPluginList                 @"plugin/content"

/**
 *  获取应用插件列表
 */
#define GetPluginDetail                 @"plugin/detail"

/**
 *  获取滚动消息
 */
#define GetMessageCycle                @"message/cycle"

/**
 *  附近红包列表
 */
#define GetNearbyAdvertisementList     @"advertisement/list"

/**
 *  超级大红包数据
 */
#define GetSuperbonusList     @"superbonus/list"

/**
 *  超级大红包详情数据
 */
#define GetSuperbonusDetail    @"superbonus/detail"

/**
 *  超级大红包兑奖
 */
#define GetsuperbonusReward    @"superbonus/reward"

/**
 *  超级大红包详情数据
 */
#define GetSuperbonusHistory    @"superbonus/history"

/*
 * 获取已领取红包数据
 */
#define GetJoinedBonusList             @"bonus/list"

/**
 *  发布者-获取广告列表广告列表
 */
#define GetSenderAdvertisementList     @"advertisement/list"

/**
 *  发布者-获取广告信息
 */
#define GetSenderAdvertisementDetail   @"advertisement/detail"

/**
 *  发布者-获取广告发布信息
 */
#define GetSenderAdvertisementPublishDetail  @"advertisement/publishdetail"

/**
 *  发布者-获取红包配置
 */
#define GetSenderAdvertisementBonus   @"advertisement/bonus"

/**
 *  接收者-抢红包
 */
#define GetConsumerAdvertisementBonus  @"advertisement/bonus"

/**
 *  广告红包排行榜
 */
#define GetBonusRank                   @"bonus/rank"

/**
 *  发送者-申请退款
 */
#define PostAdvertisementRefund        @"advertisement/refund"

/**
 *   发布者-退款日志
 */
#define GetRefundLog                   @"refund/log"

/**
 *   发布者-红包到达统计
 */
#define GetBonusStatistics             @"bonus/statistics"


/**
 *  创建广告红包配置
 */
#define PostSenderAdvertisementBonus   @"advertisement/bonus"


/**
 *  创建广告红包配置 byjianlin
 */
#define CommitAdvertisementStatus      @"advertisement/status"



/**
 *  创建广告（地理范围） byjianlin
 */                      
#define PostRangMap                    @"advertisement/publishdetail"



/**
 *  创建广告（地理范围） byjianlin
 */
#define PostRangMap                    @"advertisement/publishdetail"


/**
 *  发布者-创建订单信息） byjianlin
 */
#define PostPaymentOrder               @"payment/order"



/**
 *  提交公民身份认证 byjianlin
 */
#define PostCitizenIdentification     @"citizen/identification"


/**
 *  更新公民身份认证 byjianlin
 */
#define PutCitizenInfo                 @"citizen/info"


/**
 *  提交企业身份认证 byjianlin
 */
#define PostCompanyIdentification      @"company/identification"


/**
 *  更新企业身份认证 byjianlin
 */
#define PutCompanyInfo                 @"company/info"


/**
 *  举报广告
 */
#define PostAdvertisementAccusation    @"advertisement/accusation"

/**
 * 申请提现 byjianlin
 */
#define PostFinanceTransfer             @"finance/transfer"



/**
 * 获取用户交易记录 byjianlin
 */
#define GetuserTransactionRecords       @"user/transactionrecords"


/**
 * 获取用户交易记录 byjianlin
 */
#define GetPromotionMerchant            @"promotion/merchant"


/**
 * 获取用户余额 byjianlin
 */
#define GetUserBalance                  @"user/balance"

/**
 *  更新用户信息 byjianlin
 */
#define PutUserInfo                    @"user/info"



/**
 * 获取企业身份信息 byjianlin
 */
#define GetCompanyInfo                  @"company/info"

/**
 * 获取用户信息 byjianlin
 */
#define GetcitizenInfo                    @"citizen/info"




/**
 *  获取版本更新信息 byjianlin
 */
#define GetPlatformUpgrade                    @"platform/upgrade"








