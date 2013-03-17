//	
//  Global.h
//
//  Created by yanghua on 12.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "MTStatusBarOverlay.h"
#import <AudioToolbox/AudioToolbox.h>

#define ColorWithRGBA(r,g,b,a) \
[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define CONFIGFILE @"PlatformConfig.plist"

//默认颜色
//默认TabBar背景色为黑色
#define defalutTabBarBGColor ColorWithRGBA(0,0,0,1)		

//默认导航条背景色为天蓝色
//#define defaultNavigationBGColor ColorWithRGBA(30,144,255,1)

#define defaultNavigationBGColor ColorWithRGBA(75,204,41,1)


#define GlobalInstance [Global GetGlobalInstance]

//各平台配置所使用的Key
#define RENRENCONFIG @"RenRenConfig"
#define TENCENTWEIBOCONFIG @"TencentWeiboConfig"
#define SINAWEIBOCONFIG @"SinaWeiboConfig"
#define DOUBANCONFIG @"DoubanConfig"


//常用控件的默認高度
#define TABBARHEIGHT 49
#define STATUSBARHEIGHT 20
#define NAVIGATIONBARHEIGHT 44
#define WINDOWWIDTH 320
#define WINDOWHEIGHT 480
#define VIEWCONTENTHEIGHT WINDOWHEIGHT-STATUSBARHEIGHT-NAVIGATIONBARHEIGHT-44
#define VIEWCONTENTWIDTH 320

////所有平台名称
typedef enum{
	RenRen=0,
	SinaWeibo=1,
	TencentWeibo=2,
	Tianya=3,
}AllPlatform;

//加載類型
typedef enum{
    firstLoad=0,
    refresh=1,
    loadMore=2
}loadType;

//數據類型
typedef enum{
    dataType_comment,
    dataType_rePublish
}dataType;

//操作类型
typedef enum{
    republish,          //分享／转发
    comment,
    reply
}operateType;

@interface Global : NSObject {
	
}

//获得Global的单例对象
+(Global*)GetGlobalInstance;

//根据key从配置文件中读取value
-(id)readConfigInfoFromConfigFileWithKey:(NSString *)key
                             forPlatform:(AllPlatform)platform;

//写入配置信息
-(void)writeConfigInfoToConfigFileWithValue:(id)value
                                     forKey:(NSString *)key
                                forPlatform:(AllPlatform)platform;

//删除给定的配置项
-(void)deleteConfigItemFromConfigFileWithKey:(NSString*)key
                                 forPlatform:(AllPlatform)platform;

#pragma mark - get many kinds of height -
//获取特定大小的文本高度
-(CGFloat)getHeightWithText:(NSString*)text
                   fontSize:(CGFloat)fontSize
                 constraint:(CGSize)cSize
                  minHeight:(CGFloat)mHeight;

/*
 *获取特定大小的文本高度
 */
-(CGFloat)getHeightWithFontText:(NSString*)text
                           font:(UIFont*)_font
                     constraint:(CGSize)cSize
                      minHeight:(CGFloat)mHeight;

//获取特定大小的文本高度带换行形式
-(CGFloat)getHeightWithText:(NSString*)text
                   fontSize:(CGFloat)fontSize
              lineBreakMode:(UILineBreakMode)lbm
                 constraint:(CGSize)cSize
                  minHeight:(CGFloat)mHeight;

//获取特定大小的文本寬度
-(CGFloat)getWidthWithText:(NSString*)text
                      font:(UIFont*)font;

#pragma mark - Date -
//日期格式的字符串转换为时间格式
-(NSDate*)NSStringDateToNSDate:(NSString*)dateString;

//日期格式的字符串转换为时间格式
-(NSDate*)NSStringDateToNSDate:(NSString*)dateString
                 withFormatter:(NSDateFormatter*)formatter;

//日期转化为日期格式的字符串
-(NSString*)NSDateToNSString:(NSDate*)date;

//日期转化为日期格式的字符串
-(NSString*)NSDateToNSString:(NSDate*)date
               withFormatter:(NSDateFormatter*)formatter;

//日期字符串的格式化
-(NSString*)FormatWithDateString:(NSString*)dateString
             withSourceFormatter:(NSDateFormatter*)sourceFormatter
              forResultFormatter:(NSDateFormatter*)resultFormatter;

#pragma mark -
#pragma mark UIWebView
//改變網頁樣式    --直接讓UIWebView加載
-(NSString*)ChangeStyleWithHtml:(NSString*)htmlTxt
                     fontFamily:(NSString*)family
                       fontSize:(CGFloat)size
                      fontColor:(NSString*)color;

//改變字體顏色      通過UIWebView執行js
-(NSString*)ChangeFontColorWithHtml:(NSString*)color;

//改變字體大小      通過UIWebView執行js
-(NSString*)ChangeFontSizeWithHtml:(CGFloat)size;

//清除UIWebView的背景色
-(void)clearWebViewBackground:(UIWebView*)webView;

#pragma mark -
#pragma mark Network status check
//是否开启WWAN网络
-(BOOL)isEnable3G;

//是否开启wifi上网方式
-(BOOL)isEnableWiFi;

//网络是否开启
-(BOOL)isEnableNetwork;

//發送郵件
-(void)sendEmailTo:(NSString*)to
       withSubject:(NSString*)subject
          withBody:(NSString*)body;

//获取公网IP
- (NSString*)getOuterNetworkIPAddress;

#pragma mark - Image handle -
//生成原比例的缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image
                                       size:(CGSize)asize;

#pragma mark - UI handle -
//弹出提示消息
-(void)showMessageBoxWithMessage:(NSString*)msg;

//显示弹出提示信息(HUD)
-(void)showHUD:(NSString*)text
       andView:(UIView*)view
        andHUD:(MBProgressHUD *)hud;

//隐藏弹出提示框(HUD)
-(void)hideHUD:(MBProgressHUD *)hud;

//状态栏显示完成提示信息
-(void)showOverlayMsg:(NSString*)msg
          andDuration:(NSTimeInterval)duration
           andOverlay:(MTStatusBarOverlay*)overlay;

//状态栏显示错误提示信息
-(void)showOverlayErrorMsg:(NSString*)msg
               andDuration:(NSTimeInterval)duration
                andOverlay:(MTStatusBarOverlay*)overlay;

//动画效果：从底部出现
-(CATransition*)AnimationFromBottomToTop;

//移除子视图
-(void)removeChilds:(UIView*)view;

#pragma mark - AV player -
//播放提示音
-(void)playTipAudio:(NSURL*)audioFileUrl;

@end
