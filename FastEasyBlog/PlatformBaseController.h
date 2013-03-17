//
//  PlatformBaseController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/5/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "GlobalProtocols.h"
#import "ClickableLabel.h"

#define NAVIGATIONTITLELBL_TAG 999
#define POPVIEWGUIDE_TAG 1000

@protocol PlatformBaseControllerDelegate;

@interface PlatformBaseController : UIViewController

@property (nonatomic,retain) MBProgressHUD *hud;
@property (nonatomic,assign) id<PlatformBaseControllerDelegate> delegate;
@property (nonatomic,assign) id<BindCheckNotificationDelegate> bindCheckHandleDelegate;

//设置导航栏右侧刷新按钮
-(void)setRightBarButtonForNavigationBar;

@end

/*
 *弹出或关闭视图的实现协议
 */
@protocol PlatformBaseControllerDelegate <NSObject>

@optional
- (void)handleNetworkCheckNotification:(BOOL)hasNetwork;

@end


