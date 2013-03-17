//
//  TencentWeiboRePublishOrCommentController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-28.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableLabel.h"
#import "TencentWeiboDelegate.h"
#import "GlobalProtocols.h"
#import "FollowedListController.h"

#define CONTENTMAXLENGTH 210
#define DEFAULTFONTSIZE 18

@class ClickableLabel;
@class UIPlaceHolderTextView;
@class MTStatusBarOverlay;

@interface TencentWeiboRePublishOrCommentController : UIViewController
<
UIActionSheetDelegate,
ClickEventDelegate,
TencentWeiboDelegate,
UITextViewDelegate,
FollowedListControllerDelegate
>{
    UIPlaceHolderTextView *publishTxtView;
    UIView *tipbarView;
	UIView *toolbarView;
    ClickableLabel *strLengthLabel;             //可點擊Label
    UIButton *delBtn;
    MTStatusBarOverlay *overlay;
	
	operateType _operateType;
	
	//外来参数
	NSString *showTitle;			//用于在导航上显示的用户名称-评论XXX的XXX【不能为空】
	NSString *theSubjectId;			//评论的主体对象的Id,日志 or 状态【不能为空】
	NSString *sourceContent;		//原文-如果为转发，则需要携带原文
    
    id<rAndCDelegate> delegate;     //评论的代理
}

@property (nonatomic,assign) id<rAndCDelegate> delegate;
@property (nonatomic,retain) UIPlaceHolderTextView *publishTxtView;
@property (nonatomic,retain) UIView * tipbarView;
@property (nonatomic,retain) UIView *toolbarView;
@property (nonatomic,retain) ClickableLabel *strLengthLabel;

@property (nonatomic,retain) NSString *showTitle;
@property (nonatomic,retain) NSString *theSubjectId;
@property (nonatomic,retain) NSString *sourceContent;

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
          operateType:(operateType)__operateType 
          comeInParam:(NSMutableDictionary*)params;

@end

