//  新浪微博主界面
//  SinaWeiboMainController.h
//  FastEasyBlog
//
//  Created by svp on 24.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeiboBaseController.h"
#import "PopListView.h"

#define WEIBO_IMAGE_BIG 460

@protocol WeiboImageDelegate;

@interface SinaWeiboMainController : SinaWeiboBaseController
<
UINavigationControllerDelegate,
WBEngineDelegate,
BindCheckNotificationDelegate,
PopListViewDelegate
> 

- (void)showListView;

@end
