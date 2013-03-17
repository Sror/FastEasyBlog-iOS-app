//  列表界面（下拉刷新和上提加載更多）
//  ListTableView.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-20.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"


@protocol ListTableViewControllerDelegate;

@interface ListTableViewController : UIViewController
<
UINavigationControllerDelegate,
EGORefreshTableHeaderDelegate,
LoadMoreTableFooterDelegate
>{
    IBOutlet UITableView *tbView;
	NSMutableArray *dataList;
    
    EGORefreshTableHeaderView *_refreshHeaderView;      //下拉刷新
	LoadMoreTableFooterView *_loadMoreFooterView;       //上提加载更多
    
    BOOL _reloading;
	BOOL _reloading1;
    
	CGPoint point;                                      //判断是上提还是下拉
    
    id<ListTableViewControllerDelegate> listTableViewControllerDelegate;
}

@property (nonatomic,retain) IBOutlet UITableView *tbView;
@property (nonatomic,retain) NSMutableArray *dataList;
@property (nonatomic,assign) id<ListTableViewControllerDelegate> listTableViewControllerDelegate;

//下拉刷新
-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;

//上提加载更多
-(void)reloadTableViewDataSource1;
-(void)doneLoadingTableViewData1;


@end

