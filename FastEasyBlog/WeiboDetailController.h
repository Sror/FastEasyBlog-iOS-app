//
//  StaticViewController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 10/23/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlatformDetailController.h"
#import "MGTemplateEngine.h"
#import "SinaWeiboInfo.h"
#import "TencentWeiboInfo.h"
#import "OpenApi.h"
#import "WBEngine.h"
#import "TSMiniWebBrowser.h"

@interface WeiboDetailController : PlatformDetailController
<
UIWebViewDelegate,
UIActionSheetDelegate,
MGTemplateEngineDelegate,
WBEngineDelegate,
TencentWeiboDelegate,
PlatformDetailControllerDelegate,
rAndCDelegate,
TSMiniWebBrowserDelegate
>

@property (nonatomic,retain) UIWebView *webView;
@property (nonatomic,assign) AllPlatform currentPlatform;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
      sinaWeiboDetail:(SinaWeiboInfo*)weiboInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
   tencentWeiboDetail:(TencentWeiboInfo*)weiboInfo;

@end
