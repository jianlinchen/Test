//
//  FMDBObjectID.h
//  RedArtifact
//
//  Created by xiaoma on 16/8/17.
//  Copyright © 2016年 jianlin. All rights reserved.
//


#ifndef FMDBObjectID_h
#define FMDBObjectID_h

#pragma mark - 缓存表名
/***************** 首页 *******************/
static NSString * const kHomeTableName = @"Home";


/***************** 超级大红包 *******************/
static NSString * const kSuperbonusTableName = @"Superbonus";


/***************** 红包 *******************/
//红包
static NSString *const kRedpacketTableName = @"Redpacket";
//红包排行榜
static NSString *const kRedpacketRankTableName = @"RedpacketRank";


/***************** 广告 *******************/
//广告
static NSString *const kAdvertTableName = @"Advert";
//发布者-获取广告信息
static NSString *const kSenderAdvertisementDetailTableName = @"SenderAdvertisementDetail";
//发布者-获取广告发布信息
static NSString *const kSenderAdvertisementPublishDetailTableName = @"SenderAdvertisementPublishDetail";
//发布者-获取红包配置
static NSString *const kSenderAdvertisementBonusTableName = @"SenderAdvertisementBonus";
//结算进度
static NSString * const kRefundLogTableName = @"RefundLog";
//到达统计
static NSString * const kBonusStatisticsTableName = @"BonusStatistics";


/***************** 个人中心 *******************/
static NSString * const personCacheTableName = @"PersonCache";

/***************** 个人中心ID *******************/
static NSString * const PaymentBanlance      = @"PaymentBanlance";


#pragma mark - 缓存ObjectID
/***************** 首页 *******************/
//轮播广告缓存
static NSString * const kRAHomeViewControllerAdverts = @"RAHomeViewControllerAdverts";

//插件缓存
static NSString * const kRAHomeViewControllerPlugin = @"RAHomeViewControllerPlugins";

//时事快讯缓存
static NSString * const kRAHomeViewControllerCyclemessage = @"RAHomeViewControllerCyclemessage";

//红包缓存
static NSString * const kRAHomeViewControllerRedpacket = @"RAHomeViewControllerRedpacket";

//超级大红包缓存
static NSString * const kRAHomeViewControllerSuperbonus = @"RAHomeViewControllerSuperbonus";

/***************** 超级大红包 *******************/
//往期记录
static NSString *const kSuperbonusViewControllerSuperbonusReport = @"SuperbonusReport";

/***************** 红包 *******************/
//已参与红包列表
static NSString *const kRedpacketJoinedList = @"edpacketJoinedList";
//未参与红包列表
static NSString *const kRedpacketNOJoinedList = @"edpacketNOJoinedList";

/***************** 广告 *******************/
//编辑中广告列表缓存
static NSString * const kAdvertMineViewControlleEditingList = @"PREPARE";
//准备中广告列表缓存
static NSString * const kAdvertMineViewControllePrepareingList = @"WAITING";
//发送中广告列表缓存
static NSString * const kAdvertMineViewControlleSendingList = @"PERFORMING";
//已完成广告列表缓存
static NSString * const kAdvertMineViewControlleFinishedList = @"FINISHED";


#endif /* FMDBObjectID_h */
