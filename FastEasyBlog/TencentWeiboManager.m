//
//  TencentWeiboManager.m
//  FastEasyBlog
//
//  Created by svp on 27.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "TencentWeiboManager.h"
#import "Global.h"
#import "TencentWeiboInfo.h"
#import "NSDate+Helper.h"
#import "OpenApi.h"
#import "NSDate+Helper.h"
#import "TencentWeiboUserInfo.h"
#import "Followed.h"

#define DEFAULTHEADIMAGESIZE 40     //见方

@interface TencentWeiboManager()

//從字典中解析出TencentWeibBoInfo對象
+ (TencentWeiboInfo*)resolveObjFromDictionary:(NSMutableDictionary*)item;

//從字典中解析出TencentWeibBoInfo對象(为原微博)
+ (TencentWeiboInfo*)resolveObjFromDictionaryForSource:(NSMutableDictionary*)item;

//解析腾讯微博用户关注对象信息(inner)
+ (Followed*)resolveTencentWeiboFollowedObjFromDictionary:(NSDictionary*)item;

@end

@implementation TencentWeiboManager

static bool isBound;

/*
 *验证是否已绑定
 */
+ (BOOL)isBoundToApplication{
	NSString *accessToken=[GlobalInstance readConfigInfoFromConfigFileWithKey:@"accessToken" forPlatform:TencentWeibo];
	NSString *openId=[GlobalInstance readConfigInfoFromConfigFileWithKey:@"openId" forPlatform:TencentWeibo];
	NSString *openKey=[GlobalInstance readConfigInfoFromConfigFileWithKey:@"openKey" forPlatform:TencentWeibo];
	
	isBound=(accessToken != nil && openId != nil && openKey != nil);
	return isBound;
}

/*
 *登出
 */
+ (void)logOut{
	[GlobalInstance deleteConfigItemFromConfigFileWithKey:@"accessToken" forPlatform:TencentWeibo];
	[GlobalInstance deleteConfigItemFromConfigFileWithKey:@"openId" forPlatform:TencentWeibo];
	[GlobalInstance deleteConfigItemFromConfigFileWithKey:@"openKey" forPlatform:TencentWeibo];
	
	isBound=NO;
}

+ (OpenApi*)getOpenApi{
	OpenApi *myApi=nil;
	if ([self.class isBoundToApplication]) {
		myApi=[[OpenApi alloc]initForApi:[[Global GetGlobalInstance]readConfigInfoFromConfigFileWithKey:@"appKey" forPlatform:TencentWeibo] 
                               appSecret:[[Global GetGlobalInstance]readConfigInfoFromConfigFileWithKey:@"appSecret" forPlatform:TencentWeibo]
                             accessToken:[[Global GetGlobalInstance]readConfigInfoFromConfigFileWithKey:@"accessToken" forPlatform:TencentWeibo] 
                            accessSecret:nil  
                                  openid:[[Global GetGlobalInstance]readConfigInfoFromConfigFileWithKey:@"openId" forPlatform:TencentWeibo] 
                               oauthType:InWebView];
	}
    
	return [myApi autorelease];
}

+ (void)publishWeiboWithContent:(NSString*)content
                          atLat:(NSString*)lat
                          atLng:(NSString*)lng{
	OpenApi *myApi=[TencentWeiboManager getOpenApi];
	if (myApi) {
		[myApi publishWeibo:content 
                       jing:lng 
                        wei:lat 
                     format:@"json" 
                   clientip:@"127.0.0.1" 
                   syncflag:@"0"];
	}
}


/*
 *解析圍脖數據到對象集合
 */
+ (NSMutableArray*)resolveWeiboDataToArray:(NSArray*)weiboInfos{
    NSMutableArray *result=[[[NSMutableArray alloc]init]autorelease];
    for (NSMutableDictionary *item in weiboInfos) {
        [result addObject:[self resolveObjFromDictionary:item]];
    }
    
    return result;
}

//解析圍脖數據到對象集合(JSON)
+ (NSMutableArray*)resolveWeiboDataForJSON:(NSArray*)weiboInfos{
    NSMutableArray *result=[[[NSMutableArray alloc]init]autorelease];
    for (NSMutableDictionary *item in weiboInfos) {
        NSMutableDictionary *resolvedItem=[[[NSMutableDictionary alloc]init]autorelease];
        
        [resolvedItem setObject:[item objectForKey:@"id"] forKey:@"uniqueId"];
        [resolvedItem setObject:[item objectForKey:@"nick"] forKey:@"name"];
        [resolvedItem setObject:[NSString stringWithFormat:@"%@/%d",[item objectForKey:@"head"],DEFAULTHEADIMAGESIZE] forKey:@"headImgUrl"];
        
        NSString *handledText=@"";
        if ([item objectForKey:@"text"]==nil||[(NSString*)[item objectForKey:@"text"] isEqualToString:@""]) {
            handledText=@"转发微博";
        }else{
            handledText=[(NSString*)[item objectForKey:@"text"] handleForShowing];
        }
        
        [resolvedItem setObject:handledText forKey:@"text"];
        [resolvedItem setObject:[TencentWeiboManager resolveTencentWeiboDate:[[item objectForKey:@"timestamp"]longValue]] forKey:@"pubDate"];
        [resolvedItem setObject:[item objectForKey:@"timestamp"] forKey:@"extra"];
        
        [result addObject:resolvedItem];
    }
    
    return result;
}


#pragma mark -
#pragma mark private methods
/*
 *從字典中解析出TencentWeibBoInfo對象
 */
+ (TencentWeiboInfo*)resolveObjFromDictionary:(NSMutableDictionary*)item{
    TencentWeiboInfo *result=[[[TencentWeiboInfo alloc]init]autorelease];
    result.text=[item objectForKey:@"text"];
    result.origtext=[item objectForKey:@"origtext"];
    result.count=[[item objectForKey:@"count"]intValue];
    result.mcount=[[item objectForKey:@"mcount"]intValue];
    result.from=[item objectForKey:@"from"];
    result.fromurl=[item objectForKey:@"fromurl"];
    result.uniqueId=[item objectForKey:@"id"];
    result.image=[item objectForKey:@"image"];
    result.video=[item objectForKey:@"video"];
    result.music=[item objectForKey:@"music"];
    result.name=[item objectForKey:@"name"];
    result.openid=[item objectForKey:@"openid"];
    result.nick=[item objectForKey:@"nick"];
    result.isSelf=(BOOL*)[item objectForKey:@"self"];
    result.timestamp=[[item objectForKey:@"timestamp"]longValue];
    result.type=[[item objectForKey:@"type"]intValue];
    result.head=[NSString stringWithFormat:@"%@/%d",[item objectForKey:@"head"],DEFAULTHEADIMAGESIZE];
    result.location=[item objectForKey:@"location"];
    result.country_code=[item objectForKey:@"country_code"];
    result.province_code=[item objectForKey:@"province_code"];
    result.city_code=[item objectForKey:@"city_code"];
    result.isvip=(BOOL*)[item objectForKey:@"isvip"];
    result.geo=[item objectForKey:@"geo"];
    result.status=(NSInteger*)[item objectForKey:@"status"];
    result.emotionurl=[item objectForKey:@"emotionurl"];
    result.emotiontype=[item objectForKey:@"emotiontype"];
    if ([[item objectForKey:@"source"] isKindOfClass:[NSDictionary class]]) {
        result.source=[TencentWeiboManager resolveObjFromDictionaryForSource:[item objectForKey:@"source"]];    //解析原微博
    }else {
        result.source=nil;
    }
    
    return result;
}

/*
 *從字典中解析出TencentWeibBoInfo對象(为原微博)
 */
+ (TencentWeiboInfo*)resolveObjFromDictionaryForSource:(NSMutableDictionary*)item{
    TencentWeiboInfo *result=[[[TencentWeiboInfo alloc]init]autorelease];
    result.text=[item objectForKey:@"text"];
    result.origtext=[item objectForKey:@"origtext"];
    result.count=[[item objectForKey:@"count"]intValue];
    result.mcount=[[item objectForKey:@"mcount"]intValue];
    result.from=[item objectForKey:@"from"];
    result.fromurl=[item objectForKey:@"fromurl"];
    result.uniqueId=[item objectForKey:@"id"];
    result.image=[item objectForKey:@"image"];
    result.video=[item objectForKey:@"video"];
    result.music=[item objectForKey:@"music"];
    result.name=[item objectForKey:@"name"];
    result.openid=[item objectForKey:@"openid"];
    result.nick=[item objectForKey:@"nick"];
    result.isSelf=(BOOL*)[item objectForKey:@"self"];
    result.timestamp=[[item objectForKey:@"timestamp"]longValue];
    result.type=[[item objectForKey:@"type"]intValue];
    result.head=[NSString stringWithFormat:@"%@/%d",[item objectForKey:@"head"],DEFAULTHEADIMAGESIZE];
    result.location=[item objectForKey:@"location"];
    result.country_code=[item objectForKey:@"country_code"];
    result.province_code=[item objectForKey:@"province_code"];
    result.city_code=[item objectForKey:@"city_code"];
    result.isvip=(BOOL*)[item objectForKey:@"isvip"];
    result.geo=[item objectForKey:@"geo"];
    result.status=(NSInteger*)[item objectForKey:@"status"];
    result.emotionurl=[item objectForKey:@"emotionurl"];
    result.emotiontype=[item objectForKey:@"emotiontype"];
    
    return result;
}

/*
 *解析騰訊圍脖日期
 */
+ (NSString*)resolveTencentWeiboDate:(long)timestamp{	
    NSTimeInterval timeInterval=timestamp;
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timeInterval];
	
	return [date countDownString];
}

/*
 *解析腾讯微博用户对象
 */
+ (TencentWeiboUserInfo*)resolveTencentWeiboUserInfo:(NSMutableDictionary*)responeItem{
	TencentWeiboUserInfo *result=[[[TencentWeiboUserInfo alloc]init]autorelease];
	result.uniquedId=[responeItem objectForKey:@"id"];
	result.name=[responeItem objectForKey:@"name"];
	result.nick=[responeItem objectForKey:@"nick"];
	result.head=[NSString stringWithFormat:@"%@/%d",[responeItem objectForKey:@"head"],DEFAULTHEADIMAGESIZE];
	
	return result;
}

/*
 *解析腾讯微博用户关注对象(followed)
 */
+ (NSMutableArray*)resolveTencentWeiboFollowedUserInfo:(NSArray*)itemArr{
    NSMutableArray *result=[[[NSMutableArray alloc]init]autorelease];
    for (NSDictionary *item in itemArr) {
        [result addObject:[TencentWeiboManager resolveTencentWeiboFollowedObjFromDictionary:item]];
    }
    
    return result;
}

/*
 *解析腾讯微博用户关注对象信息(inner)
 */
+ (Followed*)resolveTencentWeiboFollowedObjFromDictionary:(NSDictionary*)item{
    Followed *followed=[[[Followed alloc]init]autorelease];
    followed.userId=[item objectForKey:@"name"];
    followed.nick=[item objectForKey:@"nick"];
    followed.desc=[item objectForKey:@"location"];
    followed.headImgUrl=[NSString stringWithFormat:@"%@/%d",[item objectForKey:@"head"],DEFAULTHEADIMAGESIZE];
    
    return followed;
}

@end
