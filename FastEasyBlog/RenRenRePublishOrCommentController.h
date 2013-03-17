//
//  RenRenRePublishOrCommentController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-28.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableLabel.h"
#import "GlobalProtocols.h"
#import "FollowedListController.h"

#define CONTENTMAXLENGTH 210
#define DEFAULTFONTSIZE 18

@class ClickableLabel;
@class UIPlaceHolderTextView;
@class MTStatusBarOverlay;

@interface RenRenRePublishOrCommentController : UIViewController
<
UIActionSheetDelegate,
UITextViewDelegate,
ClickEventDelegate,
RenrenDelegate,
FollowedListControllerDelegate
>{
    UIPlaceHolderTextView *publishTxtView;
    UIView *tipbarView;
	UIView *toolbarView;
    ClickableLabel *strLengthLabel;             //可點擊Label
    UIButton *delBtn;
    MTStatusBarOverlay *overlay;
	
	operateType _operateType;
	
	//外来参数相关
	NSString *feedType;							//当前新鲜事类型
	NSString *showTitle;						//用于在导航上显示的用户名称-评论XXX的XXX【不能为空】
	NSString *theSubjectId;						//评论的主体对象的Id,日志 or 状态【不能为空】
	NSString *ownerId;							//所属人Id，user or page【不能为空】
	NSString *rid;								//二级回复Id，即回复某个“主体的回复”
	NSString *commentType;						//回复类型：1(悄悄话)，0(公开)
	NSString *sourceContent;					//原文-如果为转发，则需要携带原文
    
    id<rAndCDelegate> delegate;
}

@property (nonatomic,assign) id<rAndCDelegate> delegate;
@property (nonatomic,retain) UIPlaceHolderTextView *publishTxtView;
@property (nonatomic,retain) UIView * tipbarView;
@property (nonatomic,retain) UIView *toolbarView;
@property (nonatomic,retain) ClickableLabel *strLengthLabel;

@property (nonatomic,retain) NSString *feedType;
@property (nonatomic,retain) NSString *showTitle;
@property (nonatomic,retain) NSString *theSubjectId;
@property (nonatomic,retain) NSString *ownerId;
@property (nonatomic,retain) NSString *rid;
@property (nonatomic,retain) NSString *commentType;
@property (nonatomic,retain) NSString *sourceContent;

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
          operateType:(operateType)__operateType
          comeInParam:(NSMutableDictionary*)params;

@end
