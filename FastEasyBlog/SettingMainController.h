//
//  SettingMainController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-10.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "IconDownloader.h"
#import "WBEngine.h"        //sina
#import "OpenSdkOauth.h"
#import "TencentWeiboLoginController.h"



@protocol WBEngineDelegate;
@protocol TencentWeiboLoginControllerDelegate;

@class ShareAndBindTableViewCell;
@class RenRenUserInfo;
@class SinaWeiboUser;
@class TencentWeiboUserInfo;

@interface SettingMainController : UIViewController
<
IconDownloaderDelegate,
UITableViewDataSource,
UITableViewDelegate,
RenrenDelegate,
WBEngineDelegate,
TencentWeiboLoginControllerDelegate,
TencentWeiboDelegate
>{
    IBOutlet UITableView *settingTableView;
    NSArray *platformArray;
    NSDictionary *platformWithlogoDictionary;
    NSArray *dataSource;
    
    ShareAndBindTableViewCell *sinaWeiboCell;
    ShareAndBindTableViewCell *tencentWeiboCell;
    ShareAndBindTableViewCell *renrenCell;
	
	RenRenUserInfo *renrenUserInfo;
	SinaWeiboUser *sinaweiboUserInfo;
	TencentWeiboUserInfo *tencentweiboUserInfo;
	
	IconDownloader *downLoaderForRenRen;
	IconDownloader *downLoaderForSinaWeibo;
	IconDownloader *downLoaderForTencentWeibo;
}

@property (nonatomic,retain) IBOutlet UITableView *settingTableView;
@property (nonatomic,retain) NSArray *platformArray;
@property (nonatomic,retain) NSDictionary *platformWithlogoDictionary;
@property (nonatomic,retain) NSArray *dataSource;
@property (nonatomic,retain) WBEngine *weiBoEngine;      //sina

@property (nonatomic,retain) ShareAndBindTableViewCell *sinaWeiboCell;
@property (nonatomic,retain) ShareAndBindTableViewCell *tencentWeiboCell;
@property (nonatomic,retain) ShareAndBindTableViewCell *renrenCell;

@property (nonatomic,retain) RenRenUserInfo *renrenUserInfo;
@property (nonatomic,retain) SinaWeiboUser *sinaweiboUserInfo;
@property (nonatomic,retain) TencentWeiboUserInfo *tencentweiboUserInfo;

@property (nonatomic,retain) IconDownloader *downLoaderForRenRen;
@property (nonatomic,retain) IconDownloader *downLoaderForSinaWeibo;
@property (nonatomic,retain) IconDownloader *downLoaderForTencentWeibo;

@end
