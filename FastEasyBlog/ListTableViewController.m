//
//  ListTableView.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-20.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import "ListTableViewController.h"
#import "ListTableViewControllerDelegate.h"
#import "Global.h"

@interface ListTableViewController()

//设置“刷新”和“加载更多”视图
- (void)initRefreshAndLoadMoreView;

@end

@implementation ListTableViewController

@synthesize dataList,tbView,listTableViewControllerDelegate;


#pragma mark - life cycle
-(void)dealloc{
    _refreshHeaderView=nil;
    [_loadMoreFooterView release],_loadMoreFooterView=nil;
    
    [dataList release],dataList=nil;
    [tbView release],tbView=nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //unbind view
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, -WINDOWWIDTH, VIEWCONTENTHEIGHT)];
        imgView.tag=8769;
        imgView.image=[UIImage imageNamed:@"unbind.png"];
        [self.view addSubview:imgView];
        [self.view bringSubviewToFront:imgView];
        [imgView release];
    }
    
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    self.navigationController.delegate=self;
	self.navigationItem.title=@"新鲜事";
	
    //设置“刷新”和“加载更多”视图
    [self initRefreshAndLoadMoreView];
    
	//设置最后一次的“更新时间”
	[_refreshHeaderView refreshLastUpdatedDate];
	
}

#pragma mark - about data source 
/*
 *下拉刷新
 */
-(void)reloadTableViewDataSource{
	if ([self.listTableViewControllerDelegate respondsToSelector:@selector(refresh)]) {
        [self.listTableViewControllerDelegate refresh];
    }
	_reloading=YES;
}

-(void)doneLoadingTableViewData{
	_reloading=NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tbView];
}

/*
 *上提加载更多
 */
-(void)reloadTableViewDataSource1{
	if ([self.listTableViewControllerDelegate respondsToSelector:@selector(loadMore)]) {
        [self.listTableViewControllerDelegate loadMore];
    }
	_reloading1=YES;
}

-(void)doneLoadingTableViewData1{
	_reloading1=NO;
	[_loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.tbView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
	return _reloading;
}

-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view{
	return [NSDate date];
}

#pragma mark -
#pragma mark LoadMoreTableFooterDelegate Methods
- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreTableFooterView *)view{
	[self reloadTableViewDataSource1];
	[self performSelector:@selector(doneLoadingTableViewData1) withObject:nil afterDelay:3.0];
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view{
	return _reloading1;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
	point=scrollView.contentOffset;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	CGPoint pt=scrollView.contentOffset;
	//上提－加载更多
	if (point.y<pt.y) {
		[_loadMoreFooterView loadMoreScrollViewDidScroll:scrollView];
	}else {		//下拉刷新
		[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
	}
}

//停止拖动时触发
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate{
	CGPoint pt=scrollView.contentOffset;
	//上提－加载更多
	if (point.y<pt.y) {
		[_loadMoreFooterView loadMoreScrollViewDidEndDragging:scrollView];
	}else {		//下拉刷新
		[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	}
	
	if (!decelerate) {
        if ([self.listTableViewControllerDelegate respondsToSelector:@selector(loadImagesForOneScreenRows)]) {
            [self.listTableViewControllerDelegate loadImagesForOneScreenRows];
        }
	}
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	if ([self.listTableViewControllerDelegate respondsToSelector:@selector(loadImagesForOneScreenRows)]) {
        [self.listTableViewControllerDelegate loadImagesForOneScreenRows];
    }
}

#pragma mark -
#pragma mark private methods
/*
 *设置“刷新”和“加载更多”视图
 */
- (void)initRefreshAndLoadMoreView{
    //设置下拉刷新视图
    if (_refreshHeaderView==nil) {
		_refreshHeaderView=[[EGORefreshTableHeaderView alloc]
											 initWithFrame:CGRectMake(0.0f,
																	  0.0f-self.tbView.bounds.size.height,
																	  self.view.frame.size.width,
																	  self.tbView.bounds.size.height)];
		_refreshHeaderView.delegate=self;
		[self.tbView addSubview:_refreshHeaderView];
	}
	
	//设置上提载入更多视图
	if (_loadMoreFooterView==nil) {
		_loadMoreFooterView=[[LoadMoreTableFooterView alloc]
										   initWithFrame:CGRectMake(0.0f, 
																	self.tbView.contentSize.height,
																	self.tbView.frame.size.width,
																	self.tbView.bounds.size.height)];
		
		_loadMoreFooterView.delegate=self;
		[self.tbView addSubview:_loadMoreFooterView];
	}
    
}


//#pragma mark -
//#pragma mark UITableViewDelegate(由子類自行實現)
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//	return 0;
//}
//
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return nil;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 0;
//}





@end
