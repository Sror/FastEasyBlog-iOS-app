//
//  RenRenMainController.h
//  FastEasyBlog
//
//  Created by svp on 24.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
//分屏效果
#import "ZUUIRevealController.h"
#import "Global.h"
#import "PlatformBaseController.h"
#import "GlobalProtocols.h"
#import "MWPhotoBrowser.h"

@class RenRenNews;

@interface RenRenMainController : PlatformBaseController 
<
RenrenDelegate,
UINavigationControllerDelegate,
UITableViewDelegate,
UITableViewDataSource,
IconDownloaderDelegate,
EGORefreshTableHeaderDelegate,
LoadMoreTableFooterDelegate,
BindCheckNotificationDelegate,
PlatformBaseControllerDelegate,
WeiboImageDelegate,
MWPhotoBrowserDelegate
>{    
	EGORefreshTableHeaderView *_refreshHeaderView;      //下拉刷新
	LoadMoreTableFooterView *_loadMoreFooterView;       //上提加载更多
	CGPoint point;                                      //判断是上提还是下拉
    
	BOOL _reloading;
	BOOL _reloading1;
       
    loadType loadtype;
}

@property (nonatomic,retain) IBOutlet UITableView *newsTableView;
@property (nonatomic,retain) NSMutableArray *newsList;
@property (nonatomic,retain) NSArray *photoArray;
@property (nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,readonly) int currentPage;
@property (nonatomic,retain) NSString *currentCategories;

//加载新鲜事列表
-(void)loadNewsInfoList;

//下拉刷新
-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;

//上提加载更多
-(void)reloadTableViewDataSource1;
-(void)doneLoadingTableViewData1;

//下载图片
- (void)startIconDownload:(NSString*)headurl
             forIndexPath:(NSIndexPath *)indexPath;

@end
