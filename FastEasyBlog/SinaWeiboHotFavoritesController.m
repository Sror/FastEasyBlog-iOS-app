//
//  SinaWeiboRecommendController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 10/4/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "SinaWeiboHotFavoritesController.h"

@interface SinaWeiboHotFavoritesController ()

//加载圍脖列表
-(void)loadDataSource;

@end

@implementation SinaWeiboHotFavoritesController

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
    self=[super initWithRefreshHeaderViewEnabled:enableRefreshHeaderView andLoadMoreFooterViewEnabled:enableLoadMoreFooterView andTableViewFrame:frame];
    if (self) {
        self.engine.delegate=self;
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
	
    //注册微博列表的手势
    [self registerGestureOperation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

/*
 *加载圍脖列表
 */
-(void)loadDataSource{
    [super loadDataSource];
    
    NSMutableDictionary *requestParams=[[NSMutableDictionary alloc]init];
    switch (self.loadtype) {
        case firstLoad:             //首次加载
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.count] forKey:@"count"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
            break;
            
        case refresh:             //刷新
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.count] forKey:@"count"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
            break;
            
        case loadMore:             //加载更多
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.count] forKey:@"count"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
            break;
    }
    
    [self.engine loadRequestWithMethodName:@"suggestions/favorites/hot.json"
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
    if ([result isKindOfClass:[NSArray class]])
    {
        NSArray *arr = (NSArray *)result;
        
        switch (self.loadtype) {
            case firstLoad:             //首次加载
                self.dataSource=[SinaWeiboManager resolveWeiboDataToArray:arr];
                break;
                
            case refresh:
            {        //刷新
                NSMutableArray *newList=[[[NSMutableArray alloc]initWithArray:[SinaWeiboManager resolveWeiboDataToArray:arr] copyItems:NO]autorelease];
                if ([newList count]!=0) {
                    [newList addObjectsFromArray:self.dataSource];
                    self.dataSource=newList;
                }
            }
                break;
                
            case loadMore:             //加载更多
            {
                NSMutableArray *newList=[[[NSMutableArray alloc]initWithArray:self.dataSource copyItems:NO]autorelease];
                NSMutableArray *tmpArr=[SinaWeiboManager resolveWeiboDataToArray:arr];
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
    //关闭加载指示器
    [GlobalInstance hideHUD:self.hud];
    [GlobalInstance showMessageBoxWithMessage:@"获取数据失败"];
}

#pragma mark - Bind check notification handle -
- (void)handleBindNotification:(BOOL)isBound{
    //如果已綁定并且是首次加载
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
    
    __block SinaWeiboHotFavoritesController *blockedSelf=self;
    
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
    
    
    self.heightForRowAtIndexPathDelegate=^(UITableView *tableView, NSIndexPath *indexPath){
        BOOL hasWeiboImg=NO;
        BOOL hasSourceImg=NO;
        
        CGFloat currentCellContentHeight=0.0f;                   //当前单元格内容高度
        SinaWeiboInfo *currentWeiboInfo=[self.dataSource objectAtIndex:indexPath.row];
        hasWeiboImg=[currentWeiboInfo.thumbnail_pic isNotEqualToString:@""];
        currentCellContentHeight=[GlobalInstance getHeightWithFontText:currentWeiboInfo.text font:WEIBOTEXTFONT constraint:DEFAULT_CONSTRAINT_SIZE minHeight:MIN_CONTENT_HEIGHT];
        if (currentWeiboInfo.retweeted_status!=nil&&[currentWeiboInfo.retweeted_status.text isNotEqualToString:@""]) {
            hasSourceImg=[currentWeiboInfo.retweeted_status.thumbnail_pic isNotEqualToString:@""];
            NSString *shortSourceWeiboTxt=currentWeiboInfo.retweeted_status.text;
            if (shortSourceWeiboTxt.length>70) {
                shortSourceWeiboTxt=[NSString stringWithFormat:@"%@...",[shortSourceWeiboTxt substringToIndex:70]];
            }
            NSString *sourceContent=[NSString stringWithFormat:@"%@: %@",currentWeiboInfo.retweeted_status.user.screen_name,shortSourceWeiboTxt];
            
            currentCellContentHeight+=[GlobalInstance getHeightWithFontText:sourceContent font:SOURCEWEIBOTEXTFONT constraint:DEFAULT_CONSTRAINT_SIZE minHeight:MIN_CONTENT_HEIGHT];
            currentCellContentHeight+=CELL_CONTENT_SOURCE_MARGIN;
        }
        
        //如果有微博图片
        if (hasWeiboImg||hasSourceImg) {
            return TABLE_HEADER_HEIGHT+currentCellContentHeight+TABLE_FOOTER_HEIGHT+5.0f+WEIBO_IMAGE_HEIGHT+IMAGE_MARGIN;
        }else{
            return TABLE_HEADER_HEIGHT+currentCellContentHeight+TABLE_FOOTER_HEIGHT+5.0f;
        }
    };
    
}

@end
