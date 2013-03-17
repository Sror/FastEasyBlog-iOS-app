//
//  TencentWeiboBaseController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 11/4/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "IconDownloader.h"
#import "GlobalProtocols.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
#import "TencentWeiboDelegate.h"
#import "TencentWeiboManager.h"
#import "TencentWeiboInfo.h"
#import "TencentWeiboList.h"
#import "TencentWeiboRePublishOrCommentController.h"
#import "WeiboCell.h"
#import "MWPhotoBrowser.h"
#import "ELTableViewController.h"

@interface TencentWeiboBaseController : ELTableViewController
<
WeiboImageDelegate,
MWPhotoBrowserDelegate
>

@property (nonatomic,retain) NSArray *photoArray;
@property (nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;

@property (nonatomic,assign) CGPoint point;                                     
@property (nonatomic,assign) BOOL reloading;
@property (nonatomic,assign) BOOL reloading1;
@property (nonatomic,assign) long pageFlag;                                      
@property (nonatomic,assign) long pageTime;
@property (nonatomic,retain) NSString *contentType;                        
@property (nonatomic,retain) NSString *weiboType;

@property (nonatomic,assign) long firstItemTimeStamp;
@property (nonatomic,assign) long lastItemTimeStamp;

//注册手势
- (void)registerGestureOperation;

//手势处理逻辑
- (void)handleGesture:(UISwipeGestureRecognizer*)gestureRecognizer;

//下载头像
- (void)startIconDownload:(NSString*)headurl
             forIndexPath:(NSIndexPath *)indexPath;

//加载新鲜事列表
-(void)loadWeiboList;

////给子类覆盖
- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
