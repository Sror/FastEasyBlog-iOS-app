//
//  OpenApi.m
//  OpenSdkTest
//
//  Created by aine sun on 3/15/12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "OpenApi.h"
#import "TencentWeiboManager.h"
#import "TencentWeiboList.h"
#import "TencentWeiboUserInfo.h"

@implementation OpenApi

@synthesize delegate;

#pragma -
#pragma mark base define
/*
 * oauth1和oauth2 Api请求的base url
 */
#define ApiBaseUrl @"http://open.t.qq.com/api/"
#define ApiBaseUrl_For_oauth2 @"https://open.t.qq.com/api/"

/*
 * api接口访问路径及名称
 */
#define TAddSuffix @"t/add"
#define TAddPicSuffix @"t/add_pic"
#define UserInfoSuffix @"user/info"
#define FriendsIdollsSuffic @"friends/idollist"
#define FriendsFansSuffic @"friends/fanslist"

/*
 * 自加(2012-07-31)
 */
#define StatusesHome @"statuses/home_timeline"                  //我的圍脖主頁時間線
#define StatusesBroadCast @"statuses/broadcast_timeline"        //我發表的圍脖時間線
#define RepublishWeiboCommentOrRepublishList @"statuses/sub_re_list"                //微博的转发或评论列表
#define WeiboCommentOrRepublishList @"t/re_list"                //微博的转发或评论列表
#define WeiboCommentAndRepublishCount @"t/re_count"             //微博的转发与评论数
#define StatusesMentions @"statuses/mentions_timeline"			//用户提及时间线
#define T_RE_ADD @"t/re_add"									//转播一条微博
#define T_COMMENT @"t/comment"									//点评一条微博
#define T_REPLY @"t/reply"                                      //回复一条微博
#define TRENDS_T @"trends/t"                                    //转播热榜
#define FAV_LIST_T @"fav/list_t"                                //收藏的微博列表

/*
 * http请求方式
 */
#define GetMethod @"GET"
#define PostMethod @"POST"

/*
 * 用于统计应用来源，其中1.2为版本号
 */
#define AppFrom @"ios-sdk1.2"

@synthesize filePathName = _filePathName;
@synthesize retCode = _retCode;

#pragma -
#pragma mark private method

/*
 * 根据ApiBaseUrl和接口名称获取接口访问路径
 */
- (NSString *) getApiBaseUrl:(NSString *)suffix {
    
    NSString *retStringUrl = nil;
    if (_OpenSdkOauth.oauthType == InAuth1) {
        retStringUrl = ApiBaseUrl;
    }
    else
    {
        retStringUrl = ApiBaseUrl_For_oauth2;
    }
    
    return [retStringUrl stringByAppendingString:suffix];
}

/*
 * 接口请求的公共参数，必须携带
 */
- (void) getPublicParams {
    [_publishParams setObject:AppFrom forKey:@"appfrom"];
    NSString *SeqId = [NSString stringWithFormat:@"%u", arc4random() % 9999999 + 123456];
    [_publishParams setObject:SeqId forKey:@"seqid"];
    [_publishParams setObject:[OpenSdkBase getClientIp] forKey:@"clientip"];
}

#pragma -
#pragma mark public function for api module

/*
 * 将发表类接口的通用参数存储到字典表成员_publishParams中
 */
- (void) setPublishParams:(NSString *)weiboContent
                     jing:(NSString *)jing
                      wei:(NSString *)wei
                   format:(NSString *)format
                 clientip:(NSString *)clientip
                 syncflag:(NSString *)syncflag  {
    
	[_publishParams setObject:weiboContent forKey:@"content"];  //要发表的微博内容
    [_publishParams setObject:format forKey:@"format"];  //返回数据格式，json或xml
	[_publishParams setObject:clientip forKey:@"clientip"];  //用户侧真实ip
    [_publishParams setObject:jing forKey:@"jing"];  //精度
    [_publishParams setObject:wei forKey:@"wei"];  //纬度
    [_publishParams setObject:syncflag forKey:@"syncflag"];  //微博同步到空间分享标记（可选，0-同步，1-不同步，默认为0）
}

/*
 * 将关系连类接口的通用参数存储到字典表成员_publishParams中
 */
- (void) setFriendListParams:(NSString *)format
                      reqnum:(NSString *)reqnum
                  startIndex:(NSString *)startIndex
                        mode:(NSString *)mode
                     install:(NSString *)install {
    
    [_publishParams setObject:format forKey:@"format"];  //返回数据格式，json或xml
    [_publishParams setObject:reqnum forKey:@"reqnum"];  //请求个数，1-30个
    [_publishParams setObject:startIndex forKey:@"startindex"];  //起始位置，第一页为0，继续向下翻页填 reqnum*(page-1)
    if ( mode != nil ) {
        [_publishParams setObject:mode forKey:@"mode"];  //获取模式，0-旧模式，1-新模式
    }    
    if ( install != nil ) {
        [_publishParams setObject:install forKey:@"install"];  //过滤安装应用好友（可选），1-获取已安装应用好友，2-获取未安装应用好友
    }
}

- (void) setHomeTimeLineParams:(NSString*)pageFlag
                      pageTime:(NSString*)pagetime
                        reqNum:(NSString*)reqnum
                          type:(NSString*)_type
                   contentType:(NSString*)contenttype{
    [_publishParams setObject:@"json" forKey:@"format"];
    [_publishParams setObject:pageFlag forKey:@"pageflag"];
    [_publishParams setObject:pagetime forKey:@"pagetime"];
    [_publishParams setObject:reqnum forKey:@"reqnum"];
    [_publishParams setObject:_type forKey:@"type"];
    [_publishParams setObject:contenttype forKey:@"contenttype"];
    
}

- (void)setMyPublishedTimeLineParams:(NSString*)pageFlag
                            pageTime:(NSString*)pagetime
                              reqNum:(NSString*)reqnum
                                type:(NSString*)_type
                         contentType:(NSString*)contenttype
                              lastId:(NSString*)lastid{
    [_publishParams setObject:@"json" forKey:@"format"];
    [_publishParams setObject:pageFlag forKey:@"pageflag"];
    [_publishParams setObject:pagetime forKey:@"pagetime"];
    [_publishParams setObject:reqnum forKey:@"reqnum"];
    [_publishParams setObject:_type forKey:@"type"];
    [_publishParams setObject:contenttype forKey:@"contenttype"];
    [_publishParams setObject:lastid forKey:@"lastid"];
}

/*
 *拉取转发微博的转发列表与评论列表的参数设置
 */
- (void) setCommentOrRepublishListParams:(NSString*)rootid
                                    flag:(NSString*)flag
                                pageFlag:(NSString*)pageFlag
                                pageTime:(NSString*)pagetime
                                  reqNum:(NSString*)reqnum
                               twitterid:(NSString*)twitterid{
    [_publishParams setObject:@"json" forKey:@"format"];
    [_publishParams setObject:flag forKey:@"flag"];
    [_publishParams setObject:rootid forKey:@"rootid"];
    [_publishParams setObject:pageFlag forKey:@"pageflag"];
    [_publishParams setObject:pagetime forKey:@"pagetime"];
    [_publishParams setObject:reqnum forKey:@"reqnum"];
    [_publishParams setObject:twitterid forKey:@"twitterid"];
}

/*
 *拉取转发微博的转发列表与评论列表的参数设置
 */
- (void) setCommentOrRepublishListParamsForSourceWeibo:(NSString*)rootid
                                                  flag:(NSString*)flag
                                              pageFlag:(NSString*)pageFlag
                                              pageTime:(NSString*)pagetime
                                                reqNum:(NSString*)reqnum
                                             twitterid:(NSString*)twitterid{
    [_publishParams setObject:@"json" forKey:@"format"];
    [_publishParams setObject:flag forKey:@"type"];
    [_publishParams setObject:rootid forKey:@"rootid"];
    [_publishParams setObject:pageFlag forKey:@"pageflag"];
    [_publishParams setObject:pagetime forKey:@"pagetime"];
    [_publishParams setObject:reqnum forKey:@"reqnum"];
    [_publishParams setObject:twitterid forKey:@"lastid"];
}

/*
 *拉取原创微博的转发列表与评论列表的参数设置
 */
- (void) setRePublishOrCommentParams:(NSString*)reid
                             content:(NSString*)cnt
                           longitude:(NSString*)lng
                            latitude:(NSString*)lat
                            syncflag:(NSString*)sFlag{
	[_publishParams setObject:@"json" forKey:@"format"];
	[_publishParams setObject:cnt forKey:@"content"];
	[_publishParams setObject:@"127.0.0.1" forKey:@"clientip"];
	[_publishParams setObject:lng forKey:@"longitude"];
	[_publishParams setObject:lat forKey:@"latitude"];
	[_publishParams setObject:reid forKey:@"reid"];
	[_publishParams setObject:sFlag forKey:@"syncflag"];
}

/*
 *获取@我的微博(用户提及时间线)的参数设置
 */
- (void) setAtMeWeiboListParams:(NSString*)pageFlag
                       pageTime:(NSString*)pagetime
                         reqNum:(NSString*)reqnum
                           type:(NSString*)_type
                    contentType:(NSString*)contenttype{
	[_publishParams setObject:@"json" forKey:@"format"];
    [_publishParams setObject:pageFlag forKey:@"pageflag"];
    [_publishParams setObject:pagetime forKey:@"pagetime"];
    [_publishParams setObject:reqnum forKey:@"reqnum"];
    [_publishParams setObject:_type forKey:@"type"];
    [_publishParams setObject:contenttype forKey:@"contenttype"];
}

/*
 *拉取转发热榜参数设置
 */
- (void)setHotRepublishedWeiboListParams:(NSString*)type
                                     pos:(NSString*)pos
                                  reqNum:(NSString*)reqnum{
    [_publishParams setObject:@"json" forKey:@"format"];
    [_publishParams setObject:reqnum forKey:@"reqnum"];
    [_publishParams setObject:pos forKey:@"pos"];
    [_publishParams setObject:type forKey:@"type"];
}

/*
 *拉取我的收藏参数设置
 */
- (void)setMyFavoritesWeiboListParams:(NSString*)pageFlag
                             pageTime:(NSString*)pagetime
                               reqNum:(NSString*)reqnum
                               lastid:(NSString*)lastid{
    [_publishParams setObject:@"json" forKey:@"format"];
    [_publishParams setObject:reqnum forKey:@"reqnum"];
    [_publishParams setObject:pageFlag forKey:@"pageflag"];
    [_publishParams setObject:pagetime forKey:@"pagetime"];
    [_publishParams setObject:lastid forKey:@"lastid"];
}

#pragma -
#pragma mark init

- (id)initForApi:(NSString*)appKey
       appSecret:(NSString*)appSecret
     accessToken:(NSString*)accessToken
    accessSecret:(NSString*)accessSecret
          openid:(NSString *)openid
       oauthType:(uint16_t)oauthType{
	if (self=[super init]) 
	{
        _OpenSdkRequest = [[OpenSdkRequest alloc] init];
        _OpenSdkOauth = [[OpenSdkOauth alloc] init];
        
        _OpenSdkOauth.appKey = [[appKey copy]autorelease];
		_OpenSdkOauth.appSecret = [[appSecret copy]autorelease];
        _OpenSdkOauth.accessToken = [[accessToken copy]autorelease];
        _OpenSdkOauth.accessSecret = [[accessSecret copy]autorelease];
        _OpenSdkOauth.openid = [[openid copy]autorelease];
        _OpenSdkOauth.oauthType = oauthType;
	}
	return self;
}

#pragma mark - 发表微博 -
- (void) publishWeibo:(NSString *)weiboContent
                 jing:(NSString *)jing
                  wei:(NSString *)wei
               format:(NSString *)format
             clientip:(NSString *)clientip
             syncflag:(NSString *)syncflag {
    NSString *requestUrl = [self getApiBaseUrl:TAddSuffix];
    
    _publishParams = [NSMutableDictionary dictionary];
    
    [self getPublicParams];
    [self setPublishParams:weiboContent jing:jing wei:wei format:format clientip:clientip syncflag:syncflag];
    
    NSString *resultStr = [_OpenSdkRequest sendApiRequest:requestUrl httpMethod:PostMethod oauth:_OpenSdkOauth params:_publishParams files:nil oauthType:_OpenSdkOauth.oauthType retCode:&_retCode];
    
    if (resultStr == nil) {
        NSLog(@"没有授权或授权失败");
        [OpenSdkBase showMessageBox:@"没有授权或授权失败"];
        return;
    }
    
    if (self.retCode == resSuccessed) {
        if([self.delegate respondsToSelector:@selector(tencentWeiboPublishedSuccessfully)]){
            [self.delegate tencentWeiboPublishedSuccessfully];
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestFailWithError)]) {
            [self.delegate tencentWeiboRequestFailWithError];
        }
    }
}

- (void) publishWeiboWithImageAndContent:(NSString *)weiboContent
                                    jing:(NSString *)jing
                                     wei:(NSString *)wei
                                  format:(NSString *)format
                                clientip:(NSString *)clientip
                                syncflag:(NSString *)syncflag {
    
    NSString *requestUrl = [self getApiBaseUrl:TAddPicSuffix];
    
    NSMutableDictionary *files = [NSMutableDictionary dictionary];
    [files setObject:PUBLISH_IMAGEPATH_TENCENTWEIBO forKey:@"pic"];
    
    _publishParams = [NSMutableDictionary dictionary];
    [self getPublicParams];
    [self setPublishParams:weiboContent jing:jing wei:wei format:format clientip:clientip syncflag:syncflag];
    
    NSString *resultStr = [_OpenSdkRequest sendApiRequest:requestUrl httpMethod:PostMethod oauth:_OpenSdkOauth params:_publishParams files:files oauthType:_OpenSdkOauth.oauthType retCode:&_retCode];
    
    if (resultStr == nil) {
        NSLog(@"没有授权或授权失败");
        [OpenSdkBase showMessageBox:@"没有授权或授权失败"];
        return;
    }
    
    if (self.retCode == resSuccessed) {
        //清除緩存圖片
        if ([self.delegate respondsToSelector:@selector(tencentWeiboPublishedSuccessfully)]) {
            [self.delegate tencentWeiboPublishedSuccessfully];
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestFailWithError)]) {
            [self.delegate tencentWeiboRequestFailWithError];
        }
    }
}

#pragma mark - 用戶信息 -
- (void) loadCurrentAuthorizedUserInfo{
    NSString *requestUrl = [self getApiBaseUrl:UserInfoSuffix];
    
    _publishParams = [NSMutableDictionary dictionary];
    [_publishParams setObject:@"json" forKey:@"format"];
    [self getPublicParams];
    
    NSString *resultStr = [_OpenSdkRequest sendApiRequest:requestUrl httpMethod:GetMethod oauth:_OpenSdkOauth params:_publishParams files:nil oauthType:_OpenSdkOauth.oauthType retCode:&_retCode];
    
    if (resultStr == nil) {
        NSLog(@"没有授权或授权失败");
        [OpenSdkBase showMessageBox:@"没有授权或授权失败"];
        return;
    }
    
    if (self.retCode == resSuccessed) {
        //获取数据之后的回调由调用者实现
        if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestDidReturnResponseForOthers:)]) {
            [self.delegate tencentWeiboRequestDidReturnResponseForOthers:[self parseUserInfo:resultStr]];
        } 
    }
    else {
        if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestFailWithError)]) {
            [self.delegate tencentWeiboRequestFailWithError];
        }
    }
}

- (TencentWeiboUserInfo*) parseUserInfo:(NSString *)resultStr {
    _OpenSdkResponse = [[OpenSdkResponse alloc] init];
    NSInteger ret = [_OpenSdkResponse parseData:resultStr];  //解析json数据
    
    if (ret == 0) {
        return [TencentWeiboManager resolveTencentWeiboUserInfo:_OpenSdkResponse.responseDict];;
    }
    NSLog(@"ret 不等于 0,call error or no data");
    return nil;//请求失败或没有数据
}

#pragma mark - 好友模塊 -
/*
 * 私有函数，解析idollist接口的返回数据，获得并输出具体字段的值 
 */
- (NSMutableArray*) parseMyIdollist:(NSString *)resultStr {
    
    _OpenSdkResponse = [[OpenSdkResponse alloc] init];
    NSInteger ret = [_OpenSdkResponse parseData:resultStr];  //解析json数据
    
    if (ret == 0) {
        
        NSInteger hasnext = [[_OpenSdkResponse.responseDict objectForKey:@"hasnext"] intValue];
        NSInteger curNum = [[_OpenSdkResponse.responseDict objectForKey:@"curnum"] intValue];  //当前页获取到的数目
        NSLog(@"hasnext is %d, curNum is %d", hasnext, curNum);
        
        NSArray *info = [_OpenSdkResponse.responseDict objectForKey:@"info"];
        
        NSMutableArray *result=[TencentWeiboManager resolveTencentWeiboFollowedUserInfo:info];
        
        return result;
    }
    return nil;
}

- (void) getMyIdollist:(NSString *)format
                reqnum:(NSString *)reqnum
            startIndex:(NSString *)startIndex
               install:(NSString *)install{
    NSString *requestUrl = [self getApiBaseUrl:FriendsIdollsSuffic];
    
    _publishParams = [NSMutableDictionary dictionary];
    [self getPublicParams];
    [self setFriendListParams:format reqnum:reqnum startIndex:startIndex mode:nil install:install]; 
    
    NSString *resultTmp = [_OpenSdkRequest sendApiRequest:requestUrl httpMethod:GetMethod oauth:_OpenSdkOauth params:_publishParams files:nil oauthType:_OpenSdkOauth.oauthType retCode:&_retCode];
    
    if (resultTmp == nil) {
        NSLog(@"没有授权或授权失败");
        [OpenSdkBase showMessageBox:@"没有授权或授权失败"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestDidReturnResponseForOthers:)]) {
        [self.delegate tencentWeiboRequestDidReturnResponseForOthers:[self parseMyIdollist:resultTmp]];
    }
}

- (void) getMyFanslist:(NSString *)format
                reqnum:(NSString *)reqnum
            startIndex:(NSString *)startIndex
                  mode:(NSString *)mode
               install:(NSString *)install {
    NSString *requestUrl = [self getApiBaseUrl:FriendsFansSuffic];
    
    _publishParams = [NSMutableDictionary dictionary];
    [self getPublicParams];
    [self setFriendListParams:format reqnum:reqnum startIndex:startIndex mode:mode install:install]; 
    
    NSString *resultStr = [_OpenSdkRequest sendApiRequest:requestUrl httpMethod:GetMethod oauth:_OpenSdkOauth params:_publishParams files:nil oauthType:_OpenSdkOauth.oauthType retCode:&_retCode];
    
    if (resultStr == nil) {
        NSLog(@"没有授权或授权失败");
        [OpenSdkBase showMessageBox:@"没有授权或授权失败"];
        return;
    }
    
    if (self.retCode == resSuccessed) {
        [OpenSdkBase showMessageBox:resultStr]; 
    }
    else {
        [OpenSdkBase showMessageBox:@"调用friends/fanslist接口失败"];
    }
}

#pragma mark - 拉取我的主頁的時間線 -
/*
 *拉取我的主頁的時間線
 */
- (void) getMyHomeTimeLineWithPageFlag:(NSString*)pageFlag
                              pageTime:(NSString*)pagetime
                                reqNum:(NSString*)reqnum
                                  type:(NSString*)_type
                           contentType:(NSString*)contenttype{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *requestUrl = [self getApiBaseUrl:StatusesHome];
        _publishParams = [NSMutableDictionary dictionary];
        [self getPublicParams];
        
        [self setHomeTimeLineParams:pageFlag pageTime:pagetime reqNum:reqnum type:_type contentType:contenttype];
        
        NSString *resultStr = [_OpenSdkRequest sendApiRequest:requestUrl httpMethod:GetMethod oauth:_OpenSdkOauth params:_publishParams files:nil oauthType:_OpenSdkOauth.oauthType retCode:&_retCode];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultStr == nil) {
                NSLog(@"没有授权或授权失败");
                return;
            }
            
            if (self.retCode == resSuccessed) {
                //获取数据之后的回调由调用者实现
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestDidReturnResponse:)]) {
                    [self.delegate tencentWeiboRequestDidReturnResponse:[self parseMyHomeLinelist:resultStr]];
                }
            }
            else {
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestFailWithError)]) {
                    [self.delegate tencentWeiboRequestFailWithError];
                }
            }
        });
    });
}

- (TencentWeiboList*) parseMyHomeLinelist:(NSString *)resultStr {
    _OpenSdkResponse = [[OpenSdkResponse alloc] init];
    NSInteger ret = [_OpenSdkResponse parseData:resultStr];  //解析json数据
    
    if (ret == 0) {
        int hasnext = [[_OpenSdkResponse.responseDict objectForKey:@"hasnext"] intValue];  //获取hasnext值，0－还有数据，1－没有数据
        NSInteger curNum = [[_OpenSdkResponse.responseDict objectForKey:@"curnum"] intValue];  //当前页获取到的数目
        NSString *pos=[[_OpenSdkResponse.responseDict objectForKey:@"pos"] stringValue];
        NSLog(@"hasnext is %d, curNum is %d", hasnext, curNum);
        
        NSArray *info = [_OpenSdkResponse.responseDict objectForKey:@"info"];
        
        NSMutableArray *weiboList=[TencentWeiboManager resolveWeiboDataToArray:info];
        
        TencentWeiboList *result=[[[TencentWeiboList alloc]init]autorelease];
        result.list=weiboList;
        result.hasNext=(hasnext==0?YES:NO);
        result.pos=pos;
        
        return result;
    }
    NSLog(@"ret 不等于 0,call error or no data");
    return nil;//请求失败或没有数据
}

#pragma mark - 拉取我的发表的時間線 -
/*
 *拉取我的发表的時間線
 */
- (void) getMyPublishedTimeLineWithPageFlag:(NSString*)pageFlag
                                   pageTime:(NSString*)pagetime
                                     reqNum:(NSString*)reqnum
                                       type:(NSString*)_type
                                contentType:(NSString*)contenttype
                                     lastId:(NSString*)lastid{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *requestUrl = [self getApiBaseUrl:StatusesBroadCast];
        _publishParams = [NSMutableDictionary dictionary];
        [self getPublicParams];
        
        [self setMyPublishedTimeLineParams:pageFlag pageTime:pagetime reqNum:reqnum type:_type contentType:contenttype lastId:lastid];
        
        NSString *resultStr = [_OpenSdkRequest sendApiRequest:requestUrl httpMethod:GetMethod oauth:_OpenSdkOauth params:_publishParams files:nil oauthType:_OpenSdkOauth.oauthType retCode:&_retCode];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultStr == nil) {
                NSLog(@"没有授权或授权失败");
                [OpenSdkBase showMessageBox:@"没有授权或授权失败"];
                return;
            }
            
            if (self.retCode == resSuccessed) {
                //获取数据之后的回调由调用者实现
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestDidReturnResponse:)]) {
                    [self.delegate tencentWeiboRequestDidReturnResponse:[self parseMyHomeLinelist:resultStr]];
                }
            }
            else {
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestFailWithError)]) {
                    [self.delegate tencentWeiboRequestFailWithError];
                }
            }
        });
    });
}


#pragma mark - 拉取转播或评论列表 -
/*
 *获取一条原创微博的转发或评论列表（原创）
 */
- (void) getWeiboCommentOrRepublishList:(NSString*)rootid
                                   flag:(NSString*)flag
                               pageFlag:(NSString*)pageFlag
                               pageTime:(NSString*)pagetime
                                 reqNum:(NSString*)reqnum
                              twitterid:(NSString*)twitterid{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *requestUrl = [self getApiBaseUrl:WeiboCommentOrRepublishList];
        _publishParams = [NSMutableDictionary dictionary];
        [self getPublicParams];
        
        [self setCommentOrRepublishListParams:rootid flag:flag pageFlag:pageFlag pageTime:pagetime reqNum:reqnum twitterid:twitterid];
        
		
        NSString *resultStr = [_OpenSdkRequest sendApiRequest:requestUrl httpMethod:GetMethod oauth:_OpenSdkOauth params:_publishParams files:nil oauthType:_OpenSdkOauth.oauthType retCode:&_retCode];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultStr == nil) {
                NSLog(@"没有授权或授权失败");
                [OpenSdkBase showMessageBox:@"没有授权或授权失败"];
                return;
            }
            
            if (self.retCode == resSuccessed) {
                //获取数据之后的回调由调用者实现
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestDidReturnResponse:)]) {
                    [self.delegate tencentWeiboRequestDidReturnResponse:[self parseRepublishAndCommentListForJSON:resultStr]];
                }
            }
            else {
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestFailWithError)]) {
                    [self.delegate tencentWeiboRequestFailWithError];
                }
            }
        });
    });
}

/*
 *获取一条微博的转发或评论列表（—转发微博—）
 */
- (void) getRepublishWeiboCommentOrRepublishList:(NSString*)rootid
                                            flag:(NSString*)flag
                                        pageFlag:(NSString*)pageFlag
                                        pageTime:(NSString*)pagetime
                                          reqNum:(NSString*)reqnum
                                       twitterid:(NSString*)twitterid{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *requestUrl = [self getApiBaseUrl:RepublishWeiboCommentOrRepublishList];
        _publishParams = [NSMutableDictionary dictionary];
        [self getPublicParams];
        
        [self setCommentOrRepublishListParamsForSourceWeibo:rootid flag:flag pageFlag:pageFlag pageTime:pagetime reqNum:reqnum twitterid:twitterid];
        
		
        NSString *resultStr = [_OpenSdkRequest sendApiRequest:requestUrl httpMethod:GetMethod oauth:_OpenSdkOauth params:_publishParams files:nil oauthType:_OpenSdkOauth.oauthType retCode:&_retCode];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultStr == nil) {
                NSLog(@"没有授权或授权失败");
                [OpenSdkBase showMessageBox:@"没有授权或授权失败"];
                return;
            }
            
            if (self.retCode == resSuccessed) {
                //获取数据之后的回调由调用者实现
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestDidReturnResponse:)]) {
                    [self.delegate tencentWeiboRequestDidReturnResponse:[self parseRepublishAndCommentListForJSON:resultStr]];
                }
            }
            else {
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestFailWithError)]) {
                    [self.delegate tencentWeiboRequestFailWithError];
                }
            }
        });
    });
}

/*
 *获取指定微博的转发或评论数
 */
- (void) getRepublishAndCommentCountWithWeiboId:(NSString*)weiboId{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *requestUrl = [self getApiBaseUrl:WeiboCommentAndRepublishCount];
        _publishParams = [NSMutableDictionary dictionary];
        [self getPublicParams];
        
        [_publishParams setObject:@"json" forKey:@"format"];
        [_publishParams setObject:@"2" forKey:@"flag"];     //同时获取转播数与评论数
        [_publishParams setObject:weiboId forKey:@"ids"];
        
		
        NSString *resultStr = [_OpenSdkRequest sendApiRequest:requestUrl httpMethod:GetMethod oauth:_OpenSdkOauth params:_publishParams files:nil oauthType:_OpenSdkOauth.oauthType retCode:&_retCode];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultStr == nil) {
                NSLog(@"没有授权或授权失败");
                [OpenSdkBase showMessageBox:@"没有授权或授权失败"];
                return;
            }
            
            if (self.retCode == resSuccessed) {
                //获取数据之后的回调由调用者实现
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestDidReturnResponseForOthers:)]) {
                    [self.delegate tencentWeiboRequestDidReturnResponseForOthers:[self parseRepublishAndCommentData:resultStr forWeiboId:weiboId]];
                }
            }
            else {
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestFailWithError)]) {
                    [self.delegate tencentWeiboRequestFailWithError];
                }
            }
        });
        
    });
}

/*
 *转换"转发/评论"列表[JSON]
 */
- (TencentWeiboList*) parseRepublishAndCommentListForJSON:(NSString *)resultStr {
    _OpenSdkResponse = [[OpenSdkResponse alloc] init];
    NSInteger ret = [_OpenSdkResponse parseData:resultStr];  //解析json数据
    
    if (ret == 0) {
        int hasnext = [[_OpenSdkResponse.responseDict objectForKey:@"hasnext"] intValue];  //获取hasnext值，0－还有数据，1－没有数据
        NSInteger curNum = [[_OpenSdkResponse.responseDict objectForKey:@"curnum"] intValue];  //当前页获取到的数目
        NSLog(@"hasnext is %d, curNum is %d", hasnext, curNum);
        
        NSArray *info = [_OpenSdkResponse.responseDict objectForKey:@"info"];
        
        NSMutableArray *weiboList=[TencentWeiboManager resolveWeiboDataForJSON:info];
        
        TencentWeiboList *result=[[[TencentWeiboList alloc]init]autorelease];
        result.list=weiboList;
        result.hasNext=(hasnext==0?YES:NO);
        
        return result;
    }
    NSLog(@"ret 不等于 0,call error or no data");
    return nil;//请求失败或没有数据
}

#pragma mark - 转播或评论一条微博 -
- (void) rePublishOrCommentWeiboWithContent:(NSString*)content
                                       reId:(NSString*)reid
                                isRePublish:(BOOL)isRePublish
                                       jing:(NSString *)jing
                                        wei:(NSString *)wei
                                   syncflag:(NSString *)syncflag{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *requestUrl=nil;
        if(isRePublish){								//转发
            requestUrl = [self getApiBaseUrl:T_RE_ADD];
        }else{											//评论
            requestUrl = [self getApiBaseUrl:T_COMMENT];
        }
        _publishParams = [NSMutableDictionary dictionary];
        [self getPublicParams];
        [self setRePublishOrCommentParams:reid content:content longitude:jing latitude:wei syncflag:syncflag];
        
        
        NSString *resultStr = [_OpenSdkRequest sendApiRequest:requestUrl httpMethod:PostMethod oauth:_OpenSdkOauth params:_publishParams files:nil oauthType:_OpenSdkOauth.oauthType retCode:&_retCode];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultStr == nil) {
                [OpenSdkBase showMessageBox:@"没有授权或授权失败"];
                return;
            }
            
            if (self.retCode == resSuccessed) {
                //获取数据之后的回调由调用者实现
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestDidReturnResponse:)]) {
                    [self.delegate tencentWeiboRequestDidReturnResponse:nil];
                }
            }
            else {
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestFailWithError)]) {
                    [self.delegate tencentWeiboRequestFailWithError];
                }
            }
        });
    });
}

/*
 *回复一条微博
 */
- (void) replyWeiboWithContent:(NSString*)content
                          reId:(NSString*)reid
                          jing:(NSString*)jing
                           wei:(NSString*)wei
                      syncflag:(NSString*)syncflag{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *requestUrl=[self getApiBaseUrl:T_REPLY];
        _publishParams = [NSMutableDictionary dictionary];
        [self getPublicParams];
        [self setRePublishOrCommentParams:reid content:content longitude:jing latitude:wei syncflag:syncflag];
        
        
        NSString *resultStr = [_OpenSdkRequest sendApiRequest:requestUrl httpMethod:PostMethod oauth:_OpenSdkOauth params:_publishParams files:nil oauthType:_OpenSdkOauth.oauthType retCode:&_retCode];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultStr == nil) {
                [OpenSdkBase showMessageBox:@"没有授权或授权失败"];
                return;
            }
            
            if (self.retCode == resSuccessed) {
                //获取数据之后的回调由调用者实现
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestDidReturnResponse:)]) {
                    [self.delegate tencentWeiboRequestDidReturnResponse:nil];
                }
            }
            else {
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestFailWithError)]) {
                    [self.delegate tencentWeiboRequestFailWithError];
                }
            }
        });
    });
}

- (NSDictionary*) parseRepublishAndCommentData:(NSString *)resultStr
                                    forWeiboId:(NSString*)weiboId{
    _OpenSdkResponse = [[OpenSdkResponse alloc] init];
    NSInteger ret = [_OpenSdkResponse parseData:resultStr];  //解析json数据
    
    if (ret == 0) {
        NSDictionary *info = [_OpenSdkResponse.responseDict objectForKey:weiboId];
        
        return info;
    }
    NSLog(@"ret 不等于 0,call error or no data");
    return nil;//请求失败或没有数据
}


#pragma mark - 获取@我的微博(用户提及时间线) -
- (void) getAtMeWeiboList:(NSString*)pageFlag
                 pageTime:(NSString*)pagetime
                   reqNum:(NSString*)reqnum
                     type:(NSString*)_type
              contentType:(NSString*)contenttype{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *requestUrl = [self getApiBaseUrl:StatusesMentions];
        _publishParams = [NSMutableDictionary dictionary];
        [self getPublicParams];
        [self setAtMeWeiboListParams:pageFlag pageTime:pagetime reqNum:reqnum type:_type contentType:contenttype];
		
        NSString *resultStr = [_OpenSdkRequest sendApiRequest:requestUrl httpMethod:GetMethod oauth:_OpenSdkOauth params:_publishParams files:nil oauthType:_OpenSdkOauth.oauthType retCode:&_retCode];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultStr == nil) {
                NSLog(@"没有授权或授权失败");
                [OpenSdkBase showMessageBox:@"没有授权或授权失败"];
                return;
            }
            
            if (self.retCode == resSuccessed) {
                //获取数据之后的回调由调用者实现
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestDidReturnResponse:)]) {
                    [self.delegate tencentWeiboRequestDidReturnResponse:[self parseMyHomeLinelist:resultStr]];
                }
            }
            else {
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestFailWithError)]) {
                    [self.delegate tencentWeiboRequestFailWithError];
                }
            }
        });
        
    });
}




#pragma mark - 拉取转发热榜 -
/*
 *拉取转发热榜
 */
- (void)getHotRepublishWeiboList:(NSString*)type
                             pos:(NSString*)pos
                          reqNum:(NSString*)reqnum{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *requestUrl = [self getApiBaseUrl:TRENDS_T];
        _publishParams = [NSMutableDictionary dictionary];
        [self getPublicParams];
        [self setHotRepublishedWeiboListParams:type pos:pos reqNum:reqnum];
		
        NSString *resultStr = [_OpenSdkRequest sendApiRequest:requestUrl httpMethod:GetMethod oauth:_OpenSdkOauth params:_publishParams files:nil oauthType:_OpenSdkOauth.oauthType retCode:&_retCode];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultStr == nil) {
                NSLog(@"没有授权或授权失败");
                return;
            }
            
            if (self.retCode == resSuccessed) {
                //获取数据之后的回调由调用者实现
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestDidReturnResponse:)]) {
                    [self.delegate tencentWeiboRequestDidReturnResponse:[self parseMyHomeLinelist:resultStr]];
                }
            }
            else {
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestFailWithError)]) {
                    [self.delegate tencentWeiboRequestFailWithError];
                }
            }
        });
        
    });
}

#pragma mark - 拉取我的收藏 -
/*
 *拉取我的收藏
 */
- (void)getMyFavoritesWeiboList:(NSString*)pageFlag
                       pageTime:(NSString*)pagetime
                         reqNum:(NSString*)reqnum
                         lastid:(NSString*)lastid{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *requestUrl = [self getApiBaseUrl:FAV_LIST_T];
        _publishParams = [NSMutableDictionary dictionary];
        [self getPublicParams];
        [self setMyFavoritesWeiboListParams:pageFlag pageTime:pagetime reqNum:reqnum lastid:lastid];
		
        NSString *resultStr = [_OpenSdkRequest sendApiRequest:requestUrl httpMethod:GetMethod oauth:_OpenSdkOauth params:_publishParams files:nil oauthType:_OpenSdkOauth.oauthType retCode:&_retCode];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultStr == nil) {
                NSLog(@"没有授权或授权失败");
                return;
            }
            
            if (self.retCode == resSuccessed) {
                //获取数据之后的回调由调用者实现
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestDidReturnResponse:)]) {
                    [self.delegate tencentWeiboRequestDidReturnResponse:[self parseMyHomeLinelist:resultStr]];
                }
            }
            else {
                if ([self.delegate respondsToSelector:@selector(tencentWeiboRequestFailWithError)]) {
                    [self.delegate tencentWeiboRequestFailWithError];
                }
            }
        });
        
    });
}

#pragma mark -
#pragma mark viewController function
- (void)loadView {
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//__conn = new CIMCommonConnection() ;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	
	//delete __conn ;
}


- (void)dealloc {
    
    [_OpenSdkOauth release];
    [_OpenSdkRequest release];
    //[_publishParams release];
    _publishParams=nil;
    [_filePathName release];
    [super dealloc];
}

@end
