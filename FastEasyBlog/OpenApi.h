//
//  OpenApi.h
//  OpenSdkTest
//
//  Created by aine sun on 3/15/12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "OpenSdkRequest.h"
#import "OpenSdkOauth.h"
#import "OpenSdkResponse.h"
#import "TencentWeiboDelegate.h"

@class TencentWeiboList;



@interface OpenApi : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {

    OpenSdkOauth *_OpenSdkOauth;
    OpenSdkRequest *_OpenSdkRequest;
    OpenSdkResponse *_OpenSdkResponse;
    
    NSMutableDictionary *_publishParams;
    NSString *_filePathName;
    uint16_t _retCode;
    
    id<TencentWeiboDelegate> delegate;
}

@property (nonatomic,retain) NSString *filePathName;
@property (nonatomic) uint16_t retCode;
@property (nonatomic,assign) id<TencentWeiboDelegate> delegate;
/*
 * 初始化
 */
- (id)initForApi:(NSString*)appKey
       appSecret:(NSString*)appSecret
     accessToken:(NSString*)accessToken
    accessSecret:(NSString*)accessSecret
          openid:(NSString *)openid
       oauthType:(uint16_t)oauthType;

/*
 * 发表微博
 */
- (void)publishWeibo:(NSString *)weiboContent
                jing:(NSString *)jing
                 wei:(NSString *)wei
              format:(NSString *)format
            clientip:(NSString *)clientip
            syncflag:(NSString *)syncflag;


/*
 * 发表带图片微博
 */
- (void) publishWeiboWithImageAndContent:(NSString *)weiboContent
                                    jing:(NSString *)jing
                                     wei:(NSString *)wei
                                  format:(NSString *)format
                                clientip:(NSString *)clientip
                                syncflag:(NSString *)syncflag;


/*
 * 获取用户信息
 */
//- (void) getUserInfo:(NSString *)format;

/*
 * 拉取我收听的人列表(followeds)
 */
- (void) getMyIdollist:(NSString *)format
                reqnum:(NSString *)reqnum
            startIndex:(NSString *)startIndex
               install:(NSString *)install;

/*
 * 拉取收听我的人列表(followers)
 */
- (void) getMyFanslist:(NSString *)format
                reqnum:(NSString *)reqnum
            startIndex:(NSString *)startIndex
                  mode:(NSString *)mode
               install:(NSString *)install;

/*
 *拉取我的主頁的時間線
 */
- (void) getMyHomeTimeLineWithPageFlag:(NSString*)pageFlag
                              pageTime:(NSString*)pagetime
                                reqNum:(NSString*)reqnum
                                  type:(NSString*)_type
                           contentType:(NSString*)contenttype;

/*
 *拉取我的发表的時間線
 */
- (void)getMyPublishedTimeLineWithPageFlag:(NSString*)pageFlag
                                  pageTime:(NSString*)pagetime
                                    reqNum:(NSString*)reqnum
                                      type:(NSString*)_type
                               contentType:(NSString*)contenttype
                                    lastId:(NSString*)lastid;

/*
 *获取一条微博的转发或评论列表（—原创微博—）
 */
- (void) getWeiboCommentOrRepublishList:(NSString*)rootid
                                   flag:(NSString*)flag
                               pageFlag:(NSString*)pageFlag
                               pageTime:(NSString*)pagetime
                                 reqNum:(NSString*)reqnum
                              twitterid:(NSString*)twitterid;

/*
 *获取一条微博的转发或评论列表（—转发微博—）
 */
- (void) getRepublishWeiboCommentOrRepublishList:(NSString*)rootid
                                            flag:(NSString*)flag
                                        pageFlag:(NSString*)pageFlag
                                        pageTime:(NSString*)pagetime
                                          reqNum:(NSString*)reqnum
                                       twitterid:(NSString*)twitterid;

/*
 *获取指定微博的转发或评论数
 */
- (void) getRepublishAndCommentCountWithWeiboId:(NSString*)weiboId;

/*
 *评论或转发一条微博
 */
- (void) rePublishOrCommentWeiboWithContent:(NSString*)content
                                       reId:(NSString*)reid
                                isRePublish:(BOOL)isRePublish
                                       jing:(NSString*)jing
                                        wei:(NSString*)wei
                                   syncflag:(NSString*)syncflag;

//回复一条微博
- (void) replyWeiboWithContent:(NSString*)content
                          reId:(NSString*)reid
                          jing:(NSString*)jing
                           wei:(NSString*)wei
                      syncflag:(NSString*)syncflag;

- (TencentWeiboList*) parseMyHomeLinelist:(NSString *)resultStr;

/*
 *获取当前授权用户信息
 */
- (void)loadCurrentAuthorizedUserInfo;

/*
 *获取@我的微博(用户提及时间线)
 */
- (void) getAtMeWeiboList:(NSString*)pageFlag
                 pageTime:(NSString*)pagetime
                   reqNum:(NSString*)reqnum
                     type:(NSString*)_type
              contentType:(NSString*)contenttype;

/*
 *拉取转发热榜
 */
- (void)getHotRepublishWeiboList:(NSString*)type
                             pos:(NSString*)pos
                          reqNum:(NSString*)reqnum;

/*
 *拉取我的收藏
 */
- (void)getMyFavoritesWeiboList:(NSString*)pageFlag
                       pageTime:(NSString*)pagetime
                         reqNum:(NSString*)reqnum
                         lastid:(NSString*)lastid;

@end
