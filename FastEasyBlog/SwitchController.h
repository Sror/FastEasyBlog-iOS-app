//
//  TianyaMainController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/12/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickableLabel.h"

#define NAVIGATIONTITLELBL_TAG 999
#define POPVIEWGUIDE_TAG 1000

#define CHECKBINDNOTIFICATION @"checkBindNotificationForPlatform"

@protocol SwitchControllerDelegate;

@interface SwitchController : UIViewController{
	id<SwitchControllerDelegate> delegate;
}

@property (nonatomic,assign) id<SwitchControllerDelegate> delegate;
@property (nonatomic,retain) UIViewController *currentCtrller;
@property (nonatomic,assign) AllPlatform currentPlatform;
@property (nonatomic,retain) UIView *contentView;
@property (nonatomic,retain) UIImageView *tabBarView;
@property (nonatomic,retain) NSMutableArray *childControllerNavTitlesArr;
@property (nonatomic,retain) ClickableLabel *navigationTitleLbl;
@property (nonatomic,retain) UIButton *popViewGuideImgBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             platform:(AllPlatform)pt
        tabBarImgName:(NSString*)imgName;

@end

@protocol SwitchControllerDelegate <NSObject>

@required 
- (NSArray*)initAndAddChildViewControllers;

- (NSMutableArray*)initChildViewControllerNavTitles;

@end
