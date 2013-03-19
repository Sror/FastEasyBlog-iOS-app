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
#import "GlobalProtocols.h"
#import "MWPhotoBrowser.h"
#import "ELTableViewController.h"

@class RenRenNews;

@interface RenRenMainController : ELTableViewController 
<
RenrenDelegate,
UINavigationControllerDelegate,
BindCheckNotificationDelegate,
WeiboImageDelegate,
MWPhotoBrowserDelegate
>{
	BOOL _reloading;
	BOOL _reloading1;
       
    loadType loadtype;
}

@property (nonatomic,retain) NSArray *photoArray;
@property (nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,readonly) int currentPage;
@property (nonatomic,retain) NSString *currentCategories;

//加载新鲜事列表
-(void)loadNewsInfoList;

//下载图片
- (void)startIconDownload:(NSString*)headurl
             forIndexPath:(NSIndexPath *)indexPath;

@end
