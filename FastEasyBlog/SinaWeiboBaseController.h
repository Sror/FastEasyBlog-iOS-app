//
//  SinaWeiboBaseController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 11/4/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "SinaWeiboInfo.h"
#import "SinaWeiboRePublishOrCommentController.h"
#import "SinaWeiboUser.h"
#import "WBEngine.h"
#import "SinaWeiboManager.h"
#import "WeiboCell.h"
#import "SinaWeiboSwitchController.h"
#import "SinaWeiboRePublishOrCommentController.h"
#import "WeiboDetailController.h"
#import "MWPhotoBrowser.h"
#import "ELTableViewController.h"

@interface SinaWeiboBaseController : ELTableViewController
<
WeiboImageDelegate,
MWPhotoBrowserDelegate
>

@property (nonatomic,retain) NSArray *photoArray;
@property (nonatomic,retain) WBEngine *engine;

@property (nonatomic,assign) loadType loadtype;

//请求数据相关
@property (nonatomic,assign) int count;
@property (nonatomic,assign) int page;
@property (nonatomic,retain) NSString *since_id;
@property (nonatomic,retain) NSString *max_id;

//注册手势
- (void)registerGestureOperation;

//手势处理逻辑
- (void)handleGesture:(UISwipeGestureRecognizer*)gestureRecognizer;

//下载头像
- (void)startIconDownload:(NSString*)headurl
             forIndexPath:(NSIndexPath *)indexPath;


//加载圍脖列表
-(void)loadDataSource;

@end
