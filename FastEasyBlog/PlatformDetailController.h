//
//  PlatformDetailController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/7/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalProtocols.h"
#import "MBProgressHUD.h"

@protocol PlatformDetailControllerDelegate;

@interface PlatformDetailController : UIViewController

@property (nonatomic,retain) MBProgressHUD *hud;
@property (nonatomic,assign) id<PlatformDetailControllerDelegate> delegate;
@property (nonatomic,retain) UIToolbar *toolbar;

@end

@protocol PlatformDetailControllerDelegate <NSObject>

@optional

//实现评论／转发／分享／转发 逻辑
- (void)operate:(operateType)_operateType;

- (void)moreToolBar_TouchUpInside:(id)sender;

@end
