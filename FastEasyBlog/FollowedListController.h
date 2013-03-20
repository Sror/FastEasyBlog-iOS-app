//  
//  FollowedListController.h
//  FastEasyBlog
//
//  Created by yanghua on 24.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"
#import "LoadMoreTableFooterView.h"
#import "WBEngine.h"
#import "Followed.h"
#import "TencentWeiboDelegate.h"

#define WEIBO_IMAGE_BIG 460

@protocol WeiboImageDelegate;
@protocol FollowedListControllerDelegate;

@interface FollowedListController : UIViewController
<
UITableViewDelegate,
UITableViewDataSource,
IconDownloaderDelegate,
WBEngineDelegate,
LoadMoreTableFooterDelegate,
TencentWeiboDelegate,
RenrenDelegate
> {
//	IBOutlet UITableView *followedTableView;
//	NSMutableArray *followedList;
    
//	NSMutableDictionary *imageDownloadsInProgress;
    
    id<FollowedListControllerDelegate> delegate;
}

@property (nonatomic,retain) IBOutlet UITableView *followedTableView;
@property (nonatomic,retain) NSMutableArray *followedList;
@property (nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,assign) AllPlatform currentPlatform;
@property (nonatomic,assign) loadType currentLoadType;
@property (nonatomic,assign) id<FollowedListControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             platform:(AllPlatform)pt;

@end

@protocol FollowedListControllerDelegate <NSObject>

@optional
//选择了一个关注的人
- (void)didSelectedFollowed:(Followed*)aFollowed;


@end

