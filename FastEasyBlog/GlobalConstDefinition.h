//
//  GlobalConstDefinition.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/26/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

/****************App keys and secrets for all open platform****************/
//sina
/*
 *TODO:
 *go to sina weibo's open platform:http://open.weibo.com/ to apply a ios app
 *then write the appkey and app secret
 */
#define kWBSDKDemoAppKey @""
#define kWBSDKDemoAppSecret @""

//tencent
/*
 *TODO:
 *go to tencent weibo's open platform:http://dev.t.qq.com/ to apply a ios app
 *then write the appkey and app secret
 */
#define oauthAppKey @""
#define oauthAppSecret @""

//renren
/*
 *TODO:
 *go to renren's open platform:http://app.renren.com/developers to apply a ios app
 *then write the app_ID and API_Key
 */

#define kAPP_ID     @""
#define kAPI_Key    @""

/*****************************regular expressions**************************/
#define ALABEL_EXPRESSION @"(<[aA].*?>.+?</[aA]>)"
#define HREF_PROPERTY_IN_ALABEL_EXPRESSION @"(href\\s*=\\s*(?:\"([^\"]*)\"|\'([^\']*)\'|([^\"\'>\\s]+)))"
#define URL_EXPRESSION @"([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])"
#define AT_IN_WEIBO_EXPRESSION @"(@([\u4e00-\u9fa5a-zA-Z0-9_-]*))"
#define TOPIC_IN_WEIBO_EXPRESSION @"(#[^#]+#)"

///////////////////////////////font//////////////////////////////////
//renren
#define RENRENPHOTODESCFONT [UIFont fontWithName:AppConfig(@"renrenPhoto_desc_fontName") size:15.0f]

#define RENRENALBUMNAMEFONT [UIFont systemFontOfSize:14.0f]
#define RENRENPHOTOCOMEFROMFONT [UIFont systemFontOfSize:14.0f]

#define RENRENSTATUSFONT [UIFont fontWithName:AppConfig(@"renrenStatus_text_fontName") size:15.0f]

#define RENRENBLOGINTRODUCTIONFONT [UIFont fontWithName:AppConfig(@"renrenBlog_introduction_fontName") size:15.0f]

//weibo
#define WEIBOTEXTFONT [UIFont fontWithName:AppConfig(@"weibo_text_fontName") size:15.0f]
#define SOURCEWEIBOTEXTFONT [UIFont fontWithName:AppConfig(@"sourceWeibo_text_fontName") size:14.0f]

//sina weibo



//tencent weibo


//SettingMainController
#define SINAWEIBO_USER_HEADIMAGE @"sinaweiboUserHeadImage.png"
#define TENCENTWEIBO_USER_HEADIMAGE @"tencentWeiboUserHeadImage.png"
#define RENREN_USER_HEADIMAGE @"renrenUserHeadImage.png"

#define BASEPATH [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define IMAGEDIRECTORYPATH [BASEPATH stringByAppendingPathComponent:@"platform_userImages"]

#define SINAWEIBOUSERHEADIMGPATH [IMAGEDIRECTORYPATH stringByAppendingPathComponent:SINAWEIBO_USER_HEADIMAGE]
#define TENCENTWEIBOUSERHEADIMGPATH [IMAGEDIRECTORYPATH stringByAppendingPathComponent:TENCENTWEIBO_USER_HEADIMAGE]
#define RENRENUSERHEADIMGPATH [IMAGEDIRECTORYPATH stringByAppendingPathComponent:RENREN_USER_HEADIMAGE]

//others
#define AppConfigPathInSandBox [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:@"AppConfig.plist"]

//#define PUBLISH_IMAGENAME @"publishingImage.jpg"
//#define PUBLISH_IMAGEPATH [NSTemporaryDirectory() stringByAppendingPathComponent:PUBLISH_IMAGENAME]

#define PUBLISH_IMAGENAME_SINAWEIBO @"publishingImageForSinaWeibo.jpg"
#define PUBLISH_IMAGEPATH_SINAWEIBO [NSTemporaryDirectory() stringByAppendingPathComponent:PUBLISH_IMAGENAME_SINAWEIBO]

#define PUBLISH_IMAGENAME_TENCENTWEIBO @"publishingImageForTencentWeibo.jpg"
#define PUBLISH_IMAGEPATH_TENCENTWEIBO [NSTemporaryDirectory() stringByAppendingPathComponent:PUBLISH_IMAGENAME_TENCENTWEIBO]

#define PUBLISH_IMAGENAME_RENREN @"publishingImageForRenren.jpg"
#define PUBLISH_IMAGEPATH_RENREN [NSTemporaryDirectory() stringByAppendingPathComponent:PUBLISH_IMAGENAME_RENREN]