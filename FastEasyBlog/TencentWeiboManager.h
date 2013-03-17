//
//  TencentWeiboManager.h
//  FastEasyBlog
//
//  Created by svp on 27.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum{
//	home_timeline,				//主页时间线
//	broadcast_timeline,			//我发表的时间线
//	special_timeline			//特别收听的人的时间线
//}TencentWeiboLoadCategory;

@class OpenApi;
@class TencentWeiboUserInfo;

@interface TencentWeiboManager : NSObject


//验证是否已绑定
+ (BOOL)isBoundToApplication;

//登出
+ (void)logOut;

//构建并获得API
+ (OpenApi*)getOpenApi;

//发表微博
+ (void)publishWeiboWithContent:(NSString*)content
                          atLat:(NSString*)lat
                          atLng:(NSString*)lng;

//解析圍脖數據到對象集合
+ (NSMutableArray*)resolveWeiboDataToArray:(NSArray*)weiboInfos;

//解析圍脖數據到對象集合(JSON)
+ (NSMutableArray*)resolveWeiboDataForJSON:(NSArray*)weiboInfos;

//解析騰訊圍脖日期
+ (NSString*)resolveTencentWeiboDate:(long)timestamp;

//解析腾讯微博用户对象
+ (TencentWeiboUserInfo*)resolveTencentWeiboUserInfo:(NSMutableDictionary*)responeItem;

//解析腾讯微博用户关注对象(followed)
+ (NSMutableArray*)resolveTencentWeiboFollowedUserInfo:(NSArray*)itemArr;

@end
