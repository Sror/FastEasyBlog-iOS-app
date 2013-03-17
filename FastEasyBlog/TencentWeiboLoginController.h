//
//  TencentWeiboLoginController.h
//  FastEasyBlog
//
//  Created by yanghua on 28.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenSdkOauth.h"

@protocol TencentWeiboLoginControllerDelegate;

@interface TencentWeiboLoginController : UIViewController
<
UIWebViewDelegate,
TencentWeiboDelegate
> {
	IBOutlet UIWebView *loginWebView;
	OpenSdkOauth *_openSdkOauth;
	id<TencentWeiboLoginControllerDelegate> delegate;
}

@property (nonatomic,retain) IBOutlet UIWebView *loginWebView;
@property (nonatomic,assign) id<TencentWeiboLoginControllerDelegate> delegate;
@end

@protocol TencentWeiboLoginControllerDelegate <NSObject>

@optional
-(void)tencentWeiboLoginControllerDismissed;

@end

