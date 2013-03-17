//
//  PublishController.h
//  FastEasyBlog
//
//  Created by svp on 24.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableLabel.h"
#import "Global.h"
#import "WBEngine.h"
#import "PhotoPickerController.h"
#import "TencentWeiboDelegate.h"
#import "MTStatusBarOverlay.h"
#import "MWPhotoBrowser.h"

#define STRLENGTH 140                           //可输入的字符长度
#define DEFAULTFONTSIZE 18
#define THUMBNAILSSIZE CGSizeMake(30,30)

@class UIPlaceHolderTextView;
@class PlatformSwitch;
@class PhotoPickerController;                   //获取相册图片
@protocol PhotoPickerControllerDelegate;        //获取到图片的回调方法

@interface PublishController : UIViewController
<
UITextViewDelegate,
ClickEventDelegate,
UIActionSheetDelegate,
PhotoPickerControllerDelegate,
MWPhotoBrowserDelegate
>


- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
              content:(NSString*)txt;

@end
