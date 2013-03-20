//
//  SinaWeiboRePublishOrCommentController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-28.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableLabel.h"
#import "WBEngine.h"
#import "GlobalProtocols.h"
#import "FollowedListController.h"

#define CONTENTMAXLENGTH_SINAWEIBO 140
#define DEFAULTFONTSIZE 18

@class ClickableLabel;
@class UIPlaceHolderTextView;
@class MTStatusBarOverlay;

@interface SinaWeiboRePublishOrCommentController : UIViewController
<
UIActionSheetDelegate,
UITextViewDelegate,
ClickEventDelegate,
WBEngineDelegate,
FollowedListControllerDelegate
>{
    UIButton *delBtn;
    MTStatusBarOverlay *overlay;
	
	operateType _operateType;					
	WBEngine *engine;
}

@property (nonatomic,assign) id<rAndCDelegate>          delegate;
@property (nonatomic,retain) UIPlaceHolderTextView      *publishTxtView;
@property (nonatomic,retain) UIView                     *tipbarView;
@property (nonatomic,retain) ClickableLabel             *strLengthLabel;

@property (nonatomic,retain) NSString                   *showTitle;
@property (nonatomic,retain) NSString                   *theSubjectId;
@property (nonatomic,retain) NSString                   *sourceContent;
@property (nonatomic,retain) NSString                   *sourceId;

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
          operateType:(operateType)__operateType
          comeInParam:(NSMutableDictionary*)params;

@end
