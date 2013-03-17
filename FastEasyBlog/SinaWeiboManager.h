//
//  SinaWeiboManager.h
//  FastEasyBlog
//
//  Created by svp on 27.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBEngine;
@class PublishController;
@class SinaWeiboInfo;
@class SinaWeiboUser;

@interface SinaWeiboManager : NSObject {
    
}

//验证是否已绑定
+ (BOOL)isBoundToApplication;

//实例化WBEngine
+ (WBEngine*)initWBEngine;

//發表圍脖
+ (void)publishWeiboWithContent:(NSString*)content
                          image:(UIImage*)img
              forViewController:(PublishController*)delegate
                    WeiboEngine:(WBEngine*)engine;

//解析圍脖數據到對象集合
+ (NSMutableArray*)resolveWeiboDataToArray:(NSArray*)weiboInfos;

//解析圍脖转发到對象集合(json)
+ (NSMutableArray*)resolveWeiboRAndCListToArrayForJSON:(NSArray*)weiboInfos;

//解析推荐圍脖數據到對象集合
+ (NSMutableArray*)resolveRecommendWeiboDataToArray:(NSArray*)weiboInfos;

//解析“评论给我的”圍脖數據到對象集合
+ (NSMutableArray*)resolveCommentToMeWeiboDataToArray:(NSArray*)weiboInfos;

//解析圍脖評論到對象集合
+ (NSMutableArray*)resolveWeiboCommentsToArray:(NSArray*)weiboComments;

//解析新浪微博中的日期
+ (NSString*)resolveSinaWeiboDate:(NSString*)date;

//解析新浪微博用户对象
+ (SinaWeiboUser*)resolveSinaWeiboUserInfo:(NSDictionary*)item;

//解析新浪微博用户关注对象(followed)
+ (NSMutableArray*)resolveSinaWeiboFollowedUserInfo:(NSDictionary*)item;

@end
