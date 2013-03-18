//  我发表的微博
//  SinaWeiboPublishedByMeController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 10/4/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "SinaWeiboPublishedByMeController.h"

@interface SinaWeiboPublishedByMeController ()

//加载圍脖列表
-(void)loadDataSource;

@end

@implementation SinaWeiboPublishedByMeController

- (void)dealloc{
    [super dealloc];
}

- (id)initWithRefreshHeaderViewEnabled:(BOOL)enableRefreshHeaderView
          andLoadMoreFooterViewEnabled:(BOOL)enableLoadMoreFooterView{
    self=[super initWithRefreshHeaderViewEnabled:enableRefreshHeaderView andLoadMoreFooterViewEnabled:enableLoadMoreFooterView];
    if (self) {
        self.engine.delegate=self;
    }
    
    return self;
}

- (id)initWithRefreshHeaderViewEnabled:(BOOL)enableRefreshHeaderView
          andLoadMoreFooterViewEnabled:(BOOL)enableLoadMoreFooterView
                     andTableViewFrame:(CGRect)frame{
    self=[self initWithRefreshHeaderViewEnabled:enableRefreshHeaderView
                   andLoadMoreFooterViewEnabled:enableLoadMoreFooterView];
    if (self) {
        self.tableViewFrame=frame;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	super.bindCheckHandleDelegate=self;
    [self initBlocks];
    [self.tableView reloadData];
    self.tableView.hidden=YES;
	
    [self registerGestureOperation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

/*
 *加载圍脖列表
 */
-(void)loadDataSource{
    [super loadDataSource];
    
    NSMutableDictionary *requestParams=[[NSMutableDictionary alloc]init];
    [requestParams setObject:self.engine.userID forKey:@"uid"];
    switch (self.loadtype) {
        case firstLoad:             //首次加载
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.count]
                              forKey:@"count"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.page]
                              forKey:@"page"];
            break;
            
        case refresh:               //刷新
            [requestParams setObject:self.since_id forKey:@"since_id"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.count]
                              forKey:@"count"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.page]
                              forKey:@"page"];
            break;
            
        case loadMore:              //加载更多
            [requestParams setObject:self.max_id forKey:@"max_id"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.count]
                              forKey:@"count"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.page]
                              forKey:@"page"];
            break;
    }
    
    [self.engine loadRequestWithMethodName:@"statuses/user_timeline.json"
                                httpMethod:@"GET"
                                    params:requestParams
                              postDataType:kWBRequestPostDataTypeNone
                          httpHeaderFields:nil];
    
    [requestParams release];
    
    [GlobalInstance showHUD:@"微博数据加载中,请稍后..." 
                    andView:self.view 
                     andHUD:self.hud];
	
	self.imageDownloadsInProgress=[NSMutableDictionary dictionary];
}

#pragma mark - WBEngineDelegate Methods
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
        
        switch (self.loadtype) {
            case firstLoad:             //首次加载
                self.dataSource=[SinaWeiboManager resolveWeiboDataToArray:[dict objectForKey:@"statuses"]];
                break;
                
            case refresh:
            {        //刷新
                NSMutableArray *newList=[[[NSMutableArray alloc]initWithArray:[SinaWeiboManager resolveWeiboDataToArray:[dict objectForKey:@"statuses"]] copyItems:NO]autorelease];
                if ([newList count]!=0) {
                    [newList addObjectsFromArray:self.dataSource];
                    self.dataSource=newList;
                }
            }
                break;
                
            case loadMore:             //加载更多
            {
                NSMutableArray *newList=[[[NSMutableArray alloc]initWithArray:self.dataSource copyItems:NO]autorelease];
                NSMutableArray *tmpArr=[SinaWeiboManager resolveWeiboDataToArray:[dict objectForKey:@"statuses"]];
                if ([tmpArr count]!=0) {
                    [newList addObjectsFromArray:tmpArr];
                    self.dataSource=newList;
                }
            }
                break;
                
            default:
                break;
        }
        
        self.tableView.hidden=NO;
        [self.tableView reloadData];
        
        //关闭加载指示器
        [GlobalInstance hideHUD:self.hud];
    }
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    [GlobalInstance hideHUD:self.hud];
    [GlobalInstance showMessageBoxWithMessage:@"获取数据失败"];
}

#pragma mark - Bind check notification handle -
- (void)handleBindNotification:(BOOL)isBound{
    if (isBound) {
        if (self.dataSource==nil) {
            [self loadDataSource];
        }
    }else {
        self.tableView.hidden=YES;
        self.dataSource=nil;
    }
}

#pragma mark - override super's method -
- (void)initBlocks{
    [super initBlocks];
    
    __block SinaWeiboPublishedByMeController *blockedSelf=self;
    
    //load more
    self.loadMoreDataSourceFunc=^{
        blockedSelf.page+=1;
        blockedSelf.loadtype=loadMore;
        [blockedSelf loadDataSource];
        blockedSelf.isLoadingMore=YES;
    };
    
    //load more completed
    self.loadMoreDataSourceCompleted=^{
        blockedSelf.isLoadingMore=NO;
        [blockedSelf.loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:blockedSelf.tableView];
    };
    
    //refresh
    self.refreshDataSourceFunc=^{
        blockedSelf.page=1;
        blockedSelf.loadtype=refresh;
        [blockedSelf loadDataSource];
        blockedSelf.isRefreshing=YES;
    };
    
    //refresh completed
    self.refreshDataSourceCompleted=^{
        blockedSelf.isRefreshing=NO;
        [blockedSelf.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:blockedSelf.tableView];
    };
    
    
}

@end
