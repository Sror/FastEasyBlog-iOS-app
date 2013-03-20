//
//  PublishBaseController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/28/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableLabel.h"
#import "UIPlaceHolderTextView.h"
#import "FollowedListController.h"
#import "PhotoPickerController.h"
#import "MWPhotoBrowser.h"

#define STRLENGTH 140                           //可输入的字符长度
#define DEFAULTFONTSIZE 18
#define THUMBNAILSSIZE CGSizeMake(30,30)

@protocol PublishBaseControllerDelegate;

@interface PublishBaseController : UIViewController
<
UITextViewDelegate,
ClickEventDelegate,
UIActionSheetDelegate,
PhotoPickerControllerDelegate,
MWPhotoBrowserDelegate
>
{
	id<PublishBaseControllerDelegate> delegate;
    
    NSString *publishingContent;
}

@property (nonatomic,retain) NSArray *photoArray;
@property (nonatomic,retain) MBProgressHUD *hud;
@property (nonatomic,assign) id<PublishBaseControllerDelegate> delegate;
@property (nonatomic,assign) AllPlatform currentPlatform;
@property (nonatomic,retain) NSMutableArray *followedList;

@property (nonatomic,retain) UIPlaceHolderTextView *publishTxtView;
@property (nonatomic,retain) UIButton *photoBtn;
@property (nonatomic,retain) UIButton *cameraBtn;
@property (nonatomic,retain) UIButton *lbsPositionBtn;
@property (nonatomic,retain) UIButton *atBtn;
@property (nonatomic,retain) UIButton *topicBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             platform:(AllPlatform)pt;

//為照片生成縮略圖
-(void)generateSmallImgForPhoto:(UIImage*)img;

@end



/*
 *子类实现的代理
 */
@protocol PublishBaseControllerDelegate <NSObject>

@optional
- (void)photoBtn_handle:(id)sender;

- (void)cameraBtn_handle:(id)sender;

- (void)lbsPositionBtn_handle:(id)sender;

- (void)atBtn_handle:(id)sender;

- (void)topicBtn_handle:(id)sender;

//发布按钮
- (void)publishBtn_handle:(id)sender;


@end
