//
//  TencentWeiboDelegate.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 8/4/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *腾讯微博的代理协议，由第三方实现
 *added bu:yh
 *date:2012-06-28
 */
@class OpenSdkOauth;
@class TencentWeiboList;

@protocol TencentWeiboDelegate<NSObject>

@optional

/*
 *登录成功时的回调方法
 */
-(void)oauthDidFinished:(OpenSdkOauth*)_openSdkOauth;

/*
 *登录失败时的回调方法
 */
-(void)oauthDidFailed:(OpenSdkOauth*)_openSdkOauth;

/*
 *登出
 */
-(void)tencentWeiboDidlogout;


/*
 * 接口请求成功，第三方开发者实现这个方法
 */
- (void)tencentWeiboRequestDidReturnResponse:(TencentWeiboList*)result;

/*
 * 接口请求成功，第三方开发者实现这个方法(对其他请求)
 */
- (void)tencentWeiboRequestDidReturnResponseForOthers:(id)result;

/*
 * 接口请求失败，第三方开发者实现这个方法
 */
- (void)tencentWeiboRequestFailWithError;

/*
 *騰訊圍脖發表成功之後的回調，主要用於刪除帶圖片的圍脖臨時緩存圖片
 */
- (void)tencentWeiboPublishedSuccessfully;



@end
