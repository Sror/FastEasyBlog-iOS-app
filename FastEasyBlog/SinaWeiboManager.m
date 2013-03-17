//
//  SinaWeiboManager.m
//  FastEasyBlog
//
//  Created by svp on 27.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "SinaWeiboManager.h"
#import "WBEngine.h"
#import "SinaWeiboInfo.h"
#import "SinaWeiboUser.h"
#import "SinaWeiboComment.h"
#import "Global.h"
#import "NSDate+Helper.h"
#import "Followed.h"                

@interface SinaWeiboManager()

//解析微博信息对象
+ (SinaWeiboInfo*)resolveObjFromDictionary:(NSMutableDictionary*)item;

//解析微博评论信息对象[评论给我的]
+ (SinaWeiboInfo*)resolveCommentWeiboObjFromDictionary:(NSMutableDictionary*)item;

//解析微博信息对象
+ (SinaWeiboInfo*)resolveObjFromDictionaryForSource:(NSMutableDictionary*)item;

//解析圍脖評論對象
+ (SinaWeiboComment*)resolveCommentObjFromDictionary:(NSMutableDictionary*)item;

@end

@implementation SinaWeiboManager

/*
 *验证是否已绑定
 */
+ (BOOL)isBoundToApplication{
    WBEngine *engine=[[[WBEngine alloc]initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret]autorelease];
    return [engine isLoggedIn]&&([engine isAuthorizeExpired]==NO);			//补充验证授权是否过期
}


/*
 *实例化WBEngine[只完成对象的实例化，不对属性进行赋值]
 */
+ (WBEngine*)initWBEngine{
    return [[[WBEngine alloc]initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret]autorelease];
}

/*
 *發表圍脖
 */
+ (void)publishWeiboWithContent:(NSString*)content
                          image:(UIImage*)img
              forViewController:(id<WBEngineDelegate>)delegate
                    WeiboEngine:(WBEngine*)engine{
    [engine setDelegate:delegate];
    [engine sendWeiBoWithText:content image:img];
    [engine release];
}

#pragma  mark - 解析圍脖數據 -
/*
 *解析圍脖數據到對象集合
 */
+ (NSMutableArray*)resolveWeiboDataToArray:(NSArray*)weiboInfos{
    NSMutableArray *result=[[[NSMutableArray alloc]init]autorelease];
    for (NSMutableDictionary *item in weiboInfos) {
        SinaWeiboInfo *resolvedObj=[SinaWeiboManager resolveObjFromDictionary:item];
        if (resolvedObj.user&&resolvedObj.user.screen_name&&[resolvedObj.user.screen_name isNotEqualToString:@""]) {
            [result addObject:resolvedObj];
        }
    }
    return result;
}

/*
 *解析推荐圍脖數據到對象集合
 */
+ (NSMutableArray*)resolveRecommendWeiboDataToArray:(NSArray*)weiboInfos{
    NSMutableArray *result=[[[NSMutableArray alloc]init]autorelease];
    for (NSMutableDictionary *item in weiboInfos) {
        SinaWeiboInfo *resolvedObj=[SinaWeiboManager resolveObjFromDictionary:[item objectForKey:@"status"]];
        if (resolvedObj.user&&resolvedObj.user.screen_name&&[resolvedObj.user.screen_name isNotEqualToString:@""]) {
            [result addObject:resolvedObj];
        }
    }
    return result;
}

//解析“评论给我的”圍脖數據到對象集合
+ (NSMutableArray*)resolveCommentToMeWeiboDataToArray:(NSArray*)weiboInfos{
    NSMutableArray *result=[[[NSMutableArray alloc]init]autorelease];
    for (NSMutableDictionary *item in weiboInfos) {
        SinaWeiboInfo *resolvedObj=[SinaWeiboManager resolveCommentWeiboObjFromDictionary:item];
        if (resolvedObj.user&&resolvedObj.user.screen_name&&[resolvedObj.user.screen_name isNotEqualToString:@""]) {
            [result addObject:resolvedObj];
        }
    }
    return result;
}

#pragma mark - inner methods -

/*
 *解析微博信息对象
 */
+ (SinaWeiboInfo*)resolveObjFromDictionary:(NSMutableDictionary*)item{
    SinaWeiboInfo *result=[[[SinaWeiboInfo alloc]init]autorelease];
    result.idstr=[item objectForKey:@"idstr"];

    result.created_at=[item objectForKey:@"created_at"];
    result.uniquiedId=[[item objectForKey:@"id"]longLongValue];
    result.text=[item objectForKey:@"text"];
    result.source=[item objectForKey:@"source"];
    //处理来源，去除<a></a>
    NSInteger firstStartIndex=[result.source rangeOfString:@">"].location+1;
    result.source=[result.source substringFromIndex:firstStartIndex];
    NSInteger secondEndIndex=[result.source rangeOfString:@"<"].location;
    result.source=[result.source substringToIndex:secondEndIndex];
    
    result.favorited=[[item objectForKey:@"favorited"]boolValue];
    result.truncated=[[item objectForKey:@"truncated"]boolValue];
    result.in_reply_to_status_id=[item objectForKey:@"in_reply_to_status_id"];
    result.in_reply_to_user_id=[item objectForKey:@"in_reply_to_user_id"];
    result.in_reply_to_screen_name=[item objectForKey:@"in_reply_to_screen_name"];
    result.geo=[item objectForKey:@"geo"];
    result.mid=[item objectForKey:@"mid"];
    result.bmiddle_pic=[item objectForKey:@"bmiddle_pic"];
    result.original_pic=[item objectForKey:@"original_pic"];
    result.thumbnail_pic=[item objectForKey:@"thumbnail_pic"];
    result.reposts_count=[[item objectForKey:@"reposts_count"]intValue];
    result.comments_count=[[item objectForKey:@"comments_count"]intValue];
    result.annotations=[item objectForKey:@"annotations"];
    //user info
    SinaWeiboUser *user=[[SinaWeiboUser alloc]init];
    user.uniquedId=[[[item objectForKey:@"user"]objectForKey:@"id"]longValue];
    user.screen_name=[[item objectForKey:@"user"]objectForKey:@"screen_name"];
    user.name=[[item objectForKey:@"user"]objectForKey:@"name"];
    user.profile_image_url=[[item objectForKey:@"user"]objectForKey:@"profile_image_url"];
    
    result.user=user;
    [user release];
    
    if ([item objectForKey:@"retweeted_status"]&&[[item objectForKey:@"retweeted_status"] isKindOfClass:[NSDictionary class]]) {
        result.retweeted_status=[SinaWeiboManager resolveObjFromDictionaryForSource:[item objectForKey:@"retweeted_status"]];
    }else{
        result.retweeted_status=nil;
    }
    
    return result;
}

//解析微博评论信息对象[评论给我的]
+ (SinaWeiboInfo*)resolveCommentWeiboObjFromDictionary:(NSMutableDictionary*)item{
    SinaWeiboInfo *result=[[[SinaWeiboInfo alloc]init]autorelease];
    result.idstr=[item objectForKey:@"idstr"];
    
    result.created_at=[item objectForKey:@"created_at"];
    result.uniquiedId=[[item objectForKey:@"id"]longLongValue];
    result.text=[item objectForKey:@"text"];
    result.source=[item objectForKey:@"source"];
    //处理来源，去除<a></a>
    NSInteger firstStartIndex=[result.source rangeOfString:@">"].location+1;
    result.source=[result.source substringFromIndex:firstStartIndex];
    NSInteger secondEndIndex=[result.source rangeOfString:@"<"].location;
    result.source=[result.source substringToIndex:secondEndIndex];
    
    result.favorited=[[item objectForKey:@"favorited"]boolValue];
    result.truncated=[[item objectForKey:@"truncated"]boolValue];
    result.in_reply_to_status_id=[item objectForKey:@"in_reply_to_status_id"];
    result.in_reply_to_user_id=[item objectForKey:@"in_reply_to_user_id"];
    result.in_reply_to_screen_name=[item objectForKey:@"in_reply_to_screen_name"];
    result.geo=[item objectForKey:@"geo"];
    result.mid=[item objectForKey:@"mid"];
    result.bmiddle_pic=[item objectForKey:@"bmiddle_pic"];
    result.original_pic=[item objectForKey:@"original_pic"];
    result.thumbnail_pic=[item objectForKey:@"thumbnail_pic"];
    result.reposts_count=[[item objectForKey:@"reposts_count"]intValue];
    result.comments_count=[[item objectForKey:@"comments_count"]intValue];
    result.annotations=[item objectForKey:@"annotations"];
    //user info
    SinaWeiboUser *user=[[SinaWeiboUser alloc]init];
    user.uniquedId=[[[item objectForKey:@"user"]objectForKey:@"id"]longValue];
    user.screen_name=[[item objectForKey:@"user"]objectForKey:@"screen_name"];
    user.name=[[item objectForKey:@"user"]objectForKey:@"name"];
    user.profile_image_url=[[item objectForKey:@"user"]objectForKey:@"profile_image_url"];
    
    result.user=user;
    [user release];
    
    if ([item objectForKey:@"status"]&&[[item objectForKey:@"status"] isKindOfClass:[NSDictionary class]]) {
        result.retweeted_status=[SinaWeiboManager resolveObjFromDictionaryForSource:[item objectForKey:@"status"]];
    }else{
        result.retweeted_status=nil;
    }
    
    return result;
}

/*
 *解析源微博信息对象
 */
+ (SinaWeiboInfo*)resolveObjFromDictionaryForSource:(NSMutableDictionary*)item{
    SinaWeiboInfo *result=[[[SinaWeiboInfo alloc]init]autorelease];
    result.idstr=[item objectForKey:@"idstr"];
    
    result.created_at=[item objectForKey:@"created_at"];
    result.uniquiedId=[[item objectForKey:@"id"]longLongValue];
    result.text=[item objectForKey:@"text"];
    result.source=[item objectForKey:@"source"];
    //处理来源，去除<a></a>
    NSInteger firstStartIndex=[result.source rangeOfString:@">"].location+1;
    result.source=[result.source substringFromIndex:firstStartIndex];
    NSInteger secondEndIndex=[result.source rangeOfString:@"<"].location;
    result.source=[result.source substringToIndex:secondEndIndex];
    
    result.favorited=[[item objectForKey:@"favorited"]boolValue];
    result.truncated=[[item objectForKey:@"truncated"]boolValue];
    result.in_reply_to_status_id=[item objectForKey:@"in_reply_to_status_id"];
    result.in_reply_to_user_id=[item objectForKey:@"in_reply_to_user_id"];
    result.in_reply_to_screen_name=[item objectForKey:@"in_reply_to_screen_name"];
    result.geo=[item objectForKey:@"geo"];
    result.mid=[item objectForKey:@"mid"];
    result.bmiddle_pic=[item objectForKey:@"bmiddle_pic"];
    result.original_pic=[item objectForKey:@"original_pic"];
    result.thumbnail_pic=[item objectForKey:@"thumbnail_pic"];
    result.reposts_count=[[item objectForKey:@"reposts_count"]intValue];
    result.comments_count=[[item objectForKey:@"comments_count"]intValue];
    result.annotations=[item objectForKey:@"annotations"];
    //user info
    SinaWeiboUser *user=[[SinaWeiboUser alloc]init];
    user.uniquedId=[[[item objectForKey:@"user"]objectForKey:@"id"]longValue];
    user.screen_name=[[item objectForKey:@"user"]objectForKey:@"screen_name"];
    user.name=[[item objectForKey:@"user"]objectForKey:@"name"];
    user.profile_image_url=[[item objectForKey:@"user"]objectForKey:@"profile_image_url"];
    
    result.user=user;
    [user release];
    
    return result;
}

#pragma mark - 解析微博转发/评论集合 -
//解析圍脖转发到對象集合(json)
+ (NSMutableArray*)resolveWeiboRAndCListToArrayForJSON:(NSArray*)weiboInfos{
    NSMutableArray *result=[[[NSMutableArray alloc]init]autorelease];
    for (NSMutableDictionary *item in weiboInfos) {        
        NSMutableDictionary *resolvedItem=[[[NSMutableDictionary alloc]init]autorelease];
            
        [resolvedItem setObject:[item objectForKey:@"idstr"] forKey:@"uniqueId"];
        [resolvedItem setObject:[[item objectForKey:@"user"] objectForKey:@"screen_name"] forKey:@"name"];
        [resolvedItem setObject:[[item objectForKey:@"user"] objectForKey:@"profile_image_url"] forKey:@"headImgUrl"];
        [resolvedItem setObject:[(NSString*)[item objectForKey:@"text"] handleForShowing] forKey:@"text"];
        [resolvedItem setObject:[SinaWeiboManager resolveSinaWeiboDate:[item objectForKey:@"created_at"]] forKey:@"pubDate"];
            
            
        [result addObject:resolvedItem];
    }
    return result;

}

#pragma mark - 解析圍脖評論 -
/*
 *解析圍脖評論到對象集合
 */
+ (NSMutableArray*)resolveWeiboCommentsToArray:(NSArray*)weiboComments{
    NSMutableArray *result=[[[NSMutableArray alloc]init]autorelease];
    for (NSMutableDictionary *item in weiboComments) {
        [result addObject:[SinaWeiboManager resolveObjFromDictionary:item]];
    }
    return result;
}

/*
 *解析圍脖評論對象
 */
+ (SinaWeiboComment*)resolveCommentObjFromDictionary:(NSMutableDictionary*)item{
    SinaWeiboComment *result=[[[SinaWeiboComment alloc]init]autorelease];
    
    result.created_at=[item objectForKey:@"created_at"];
    result.uniquiedId=[[item objectForKey:@"id"]longLongValue];
    result.text=[item objectForKey:@"text"];
    result.source=[item objectForKey:@"source"];
    result.mid=[[item objectForKey:@"mid"]longLongValue];
    
    //user info
    SinaWeiboUser *user=[[SinaWeiboUser alloc]init];
    user.uniquedId=[[[item objectForKey:@"user"]objectForKey:@"id"]longValue];
    user.screen_name=[[item objectForKey:@"user"]objectForKey:@"screen_name"];
    user.name=[[item objectForKey:@"user"]objectForKey:@"name"];
    user.profile_image_url=[[item objectForKey:@"user"]objectForKey:@"profile_image_url"];
    
    result.user=user;
    [user release];
    
    if ([item objectForKey:@"status"]) {
        result.status=[SinaWeiboManager resolveObjFromDictionary:[item objectForKey:@"status"]];
    }else{
        result.status=nil;
    }
    result.reply_comment=[item objectForKey:@"reply_comment"];
    
    return result;
}

/*
 *解析新浪微博中的日期
 */
+ (NSString*)resolveSinaWeiboDate:(NSString*)date{
	NSDateFormatter *iosDateFormater=[[[NSDateFormatter alloc]init]autorelease];
    iosDateFormater.dateFormat=@"EEE MMM d HH:mm:ss Z yyyy";
    //必须设置，否则无法解析
    iosDateFormater.locale=[[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]autorelease];
    NSDate *tmpDate=[iosDateFormater dateFromString:date];
    
    return [tmpDate countDownString];
}

/*
 *解析新浪微博用户对象
 */
+ (SinaWeiboUser*)resolveSinaWeiboUserInfo:(NSDictionary*)item{
	SinaWeiboUser* result=[[[SinaWeiboUser alloc]init]autorelease];
	result.uniquedId=[[item objectForKey:@"id"]longValue];
    result.screen_name=[item objectForKey:@"screen_name"];
    result.name=[item objectForKey:@"name"];
    result.profile_image_url=[item objectForKey:@"profile_image_url"];
	return result;
}

//解析新浪微博用户关注对象(followed)
+ (NSMutableArray*)resolveSinaWeiboFollowedUserInfo:(NSDictionary*)item{
    NSMutableArray *result=[[[NSMutableArray alloc]init]autorelease];
    NSArray *jsonDataArr=(NSArray*)[item objectForKey:@"users"];
    for (NSDictionary *subItem in jsonDataArr) {
        [result addObject:[SinaWeiboManager resolveSinaWeiboFollowedObjFromDictionary:subItem]];
    }
    
    return result;
}

/*
 *解析新浪微博用户关注对象信息(inner)
 */
+ (Followed*)resolveSinaWeiboFollowedObjFromDictionary:(NSDictionary*)item{
    Followed *followed=[[[Followed alloc]init]autorelease];
    followed.userId=[item objectForKey:@"idstr"];
    followed.nick=[item objectForKey:@"screen_name"];
    followed.headImgUrl=[item objectForKey:@"profile_image_url"];
    followed.desc=[item objectForKey:@"location"];
    
    return followed;
}


@end
