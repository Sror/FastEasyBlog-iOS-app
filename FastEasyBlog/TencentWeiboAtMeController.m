//
//  TencentWeiboAtMeController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/24/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "TencentWeiboAtMeController.h"
#import "OpenApi.h"
#import "WeiboCell.h"
#import "TencentWeiboInfo.h"
#import "TencentWeiboList.h"
#import "TencentWeiboManager.h"
#import "TencentWeiboRePublishOrCommentController.h"
#import "WeiboDetailController.h"

@interface TencentWeiboAtMeController ()

- (void)loadweiboList;

@end

@implementation TencentWeiboAtMeController


- (void)dealloc{
	[super dealloc];
}

- (id)initWithRefreshHeaderViewEnabled:(BOOL)enableRefreshHeaderView
          andLoadMoreFooterViewEnabled:(BOOL)enableLoadMoreFooterView{
    self = [super initWithRefreshHeaderViewEnabled:enableRefreshHeaderView
                      andLoadMoreFooterViewEnabled:enableLoadMoreFooterView];
    if (self) {
        
    }
    return self;
}

- (id)initWithRefreshHeaderViewEnabled:(BOOL)enableRefreshHeaderView
          andLoadMoreFooterViewEnabled:(BOOL)enableLoadMoreFooterView
                     andTableViewFrame:(CGRect)frame{
    self = [super initWithRefreshHeaderViewEnabled:enableRefreshHeaderView
                      andLoadMoreFooterViewEnabled:enableLoadMoreFooterView
                                 andTableViewFrame:frame];
    if (self) {
        
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)loadweiboList{
    [super loadWeiboList];
    
    OpenApi *myApi=[TencentWeiboManager getOpenApi];
    myApi.delegate=self;
    [myApi getAtMeWeiboList:[NSString stringWithFormat:@"%ld",self.pageFlag] 
                       pageTime:[NSString stringWithFormat:@"%ld",self.pageTime] 
                         reqNum:@"20" 
                           type:self.weiboType 
                    contentType:self.contentType];
        
        
    [GlobalInstance showHUD:@"微博数据加载中,请稍后" 
                        andView:self.view 
                         andHUD:self.hud];
        
    self.imageDownloadsInProgress=[NSMutableDictionary dictionary];    
}

#pragma mark - tencentweibo delegate -
-(void)tencentWeiboRequestDidReturnResponse:(TencentWeiboList *)result{
    switch (self.pageFlag) {
        case 0:
            self.dataSource=result.list;
            break;
            
        case 1:
            if ([result.list count]!=0) {
                NSMutableArray *newsList=[[[NSMutableArray alloc]initWithArray:self.dataSource copyItems:NO]autorelease];
                [newsList addObjectsFromArray:result.list];
                self.dataSource=newsList;
            }
            break;
            
        case 2:
            if ([result.list count]!=0) {
                NSMutableArray *newList=[[[NSMutableArray alloc]initWithArray:result.list copyItems:NO]autorelease];
                [newList addObjectsFromArray:self.dataSource];
                self.dataSource=newList;
            }
            break;
            
        default:
            break;
    }
    
    [GlobalInstance hideHUD:self.hud];
    self.tableView.hidden=NO;
	[self.tableView reloadData];
}

-(void)tencentWeiboRequestFailWithError{
    [GlobalInstance hideHUD:self.hud];
    [GlobalInstance showMessageBoxWithMessage:@"请求数据失败"];
}

#pragma mark - Bind check notification handle -
- (void)handleBindNotification:(BOOL)isBound{
    if (isBound) {
        if (self.dataSource==nil) {
            [self loadweiboList];
        }
    }else {
        self.tableView.hidden=YES;
        self.dataSource=nil;
    }
}


#pragma mark - override super's method -
- (void)initBlocks{
    [super initBlocks];
    
    __block TencentWeiboAtMeController *blockedSelf=self;
    
    //load more
    self.loadMoreDataSourceFunc=^{
        blockedSelf.pageFlag=1;
        blockedSelf.pageTime=self.lastItemTimeStamp;
        
        [self loadweiboList];
        blockedSelf.reloading1=YES;
    };
    
    //load more completed
    self.loadMoreDataSourceCompleted=^{
        blockedSelf.reloading1=NO;
        [self.loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
    };
    
    //refresh
    self.refreshDataSourceFunc=^{
        blockedSelf.pageFlag=2;
        blockedSelf.pageTime=self.firstItemTimeStamp;
        
        [self loadweiboList];
        blockedSelf.reloading=YES;
    };
    
    //refresh completed
    self.refreshDataSourceCompleted=^{
        blockedSelf.reloading=NO;
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    };
    
    
    self.heightForRowAtIndexPathDelegate=^(UITableView *tableView, NSIndexPath *indexPath){
        BOOL hasWeiboImg=NO;
        BOOL hasSourceImg=NO;
        CGFloat currentCellContentHeight=0.0f;                   //µ±«∞µ•‘™∏Òƒ⁄»›∏ﬂ∂»
        TencentWeiboInfo *currentWeiboInfo=[self.dataSource objectAtIndex:indexPath.row];
        hasWeiboImg=([currentWeiboInfo.image isKindOfClass:[NSArray class]]&&currentWeiboInfo.image.count>0);
        currentCellContentHeight=[GlobalInstance getHeightWithFontText:currentWeiboInfo.text font:WEIBOTEXTFONT constraint:DEFAULT_CONSTRAINT_SIZE minHeight:MIN_CONTENT_HEIGHT]+CELL_CONTENT_SOURCE_MARGIN*2;
        if (currentWeiboInfo.type!=1) {
            hasSourceImg=([currentWeiboInfo.source.image isKindOfClass:[NSArray class]]&&(currentWeiboInfo.source.image.count>0));
            if ([currentWeiboInfo.source.text isNotEqualToString:@""]) {
                NSString *sourceContent=[NSString stringWithFormat:@"%@: %@",currentWeiboInfo.source.nick,currentWeiboInfo.source.text];
                currentCellContentHeight+=[GlobalInstance getHeightWithFontText:sourceContent font:SOURCEWEIBOTEXTFONT constraint:DEFAULT_CONSTRAINT_SIZE minHeight:MIN_CONTENT_HEIGHT];
                currentCellContentHeight+=CELL_CONTENT_SOURCE_MARGIN*1;
            }
        }
        
        if (hasWeiboImg||hasSourceImg) {
            return TABLE_HEADER_HEIGHT+currentCellContentHeight+TABLE_FOOTER_HEIGHT+5+WEIBO_IMAGE_HEIGHT+IMAGE_MARGIN;
        }else{
            return TABLE_HEADER_HEIGHT+currentCellContentHeight+TABLE_FOOTER_HEIGHT+5;
        }
    };
    
}


@end
