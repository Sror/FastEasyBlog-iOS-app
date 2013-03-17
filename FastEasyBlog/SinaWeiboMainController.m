//
//  SinaWeiboMainController.m
//  FastEasyBlog
//
//  Created by svp on 24.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "SinaWeiboMainController.h"

#define TABLE_HEADER_HEIGHT 50.0f
#define TABLE_FOOTER_HEIGHT 20.0f
#define CELL_CONTENT_WIDTH 245.0f
#define CELL_CONTENT_MARGIN 0.0f
#define MIN_CONTENT_HEIGHT 20.0f
#define CELL_CONTENT_SOURCE_MARGIN 3.0f
#define DEFAULT_CONSTRAINT_SIZE \
CGSizeMake(CELL_CONTENT_WIDTH-(CELL_CONTENT_MARGIN*2),20000.f)

#define WEIBO_IMAGE_HEIGHT 120.0f
#define IMAGE_MARGIN 3.0f

@interface SinaWeiboMainController()

//微博筛选类型:0(全部)/1(原创)/2(图片)/3(视频)/4(音乐)
@property (nonatomic,retain) NSString *feature;
@property (nonatomic,retain) NSArray* groupOptions;
@property (nonatomic,retain) UIButton *tipBtn;

@end

@implementation SinaWeiboMainController

@synthesize groupOptions=_groupOptions;
@synthesize tipBtn=_tipBtn;
@synthesize feature;

#pragma mark - methods -
- (void)dealloc {
    [feature release],feature=nil;
    [_groupOptions release],_groupOptions=nil;
    [super dealloc];
}

- (id)initWithRefreshHeaderViewEnabled:(BOOL)enableRefreshHeaderView
          andLoadMoreFooterViewEnabled:(BOOL)enableLoadMoreFooterView{
    self=[super initWithRefreshHeaderViewEnabled:enableRefreshHeaderView
                    andLoadMoreFooterViewEnabled:enableRefreshHeaderView];
    if (self) {
        self.engine.delegate=self;
        self.feature=@"0";
        
        if (![AppConfig(@"sinaWeibo_main_tip_hasShown") boolValue]) {
            _tipBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            _tipBtn.frame=CGRectMake(0, 0, WINDOWWIDTH, WINDOWHEIGHT);
            [_tipBtn setBackgroundImage:[UIImage imageNamed:@"sinaWeibo_tip.png"] forState:UIControlStateNormal];
            [_tipBtn addTarget:self action:@selector(tipButton_touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return self;
}

- (id)initWithRefreshHeaderViewEnabled:(BOOL)enableRefreshHeaderView
          andLoadMoreFooterViewEnabled:(BOOL)enableLoadMoreFooterView
                     andTableViewFrame:(CGRect)frame{
    self=[super initWithRefreshHeaderViewEnabled:enableRefreshHeaderView
                    andLoadMoreFooterViewEnabled:enableLoadMoreFooterView
                               andTableViewFrame:frame];
    if (self) {
        self.engine.delegate=self;
        self.feature=@"0";
        
        if (![AppConfig(@"sinaWeibo_main_tip_hasShown") boolValue]) {
            _tipBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            _tipBtn.frame=CGRectMake(0, 0, WINDOWWIDTH, WINDOWHEIGHT);
            [_tipBtn setBackgroundImage:[UIImage imageNamed:@"sinaWeibo_tip.png"] forState:UIControlStateNormal];
            [_tipBtn addTarget:self action:@selector(tipButton_touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    super.bindCheckHandleDelegate=self;
    [self initBlocks];
    
    [self.tableView reloadData];
    self.tableView.hidden=YES;
	
    //注册微博列表的手势
    [self registerGestureOperation];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

/*
 *加载圍脖列表
 */
-(void)loadDataSource{
    [super loadDataSource];
    
    NSMutableDictionary *requestParams=[[NSMutableDictionary alloc]init];
    switch (self.loadtype) {
        case firstLoad:             //首次加载
            [requestParams setObject:self.feature forKey:@"feature"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.count] 
                              forKey:@"count"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.page] 
                              forKey:@"page"];
            break;
            
        case refresh:             //刷新
            [requestParams setObject:self.since_id forKey:@"since_id"];
            [requestParams setObject:self.feature forKey:@"feature"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.count] 
                              forKey:@"count"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.page] 
                              forKey:@"page"];
            break;
            
        case loadMore:             //加载更多
            [requestParams setObject:self.max_id forKey:@"max_id"];
            [requestParams setObject:self.feature forKey:@"feature"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.count] 
                              forKey:@"count"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.page] 
                              forKey:@"page"];
            break;
    }
    
    [self.engine loadRequestWithMethodName:@"statuses/home_timeline.json"
                           httpMethod:@"GET"
                               params:requestParams
                         postDataType:kWBRequestPostDataTypeNone
                     httpHeaderFields:nil];
    
    [requestParams release];
    
    [GlobalInstance showHUD:@"微博数据加载中,请稍后" andView:self.view andHUD:self.hud];
	self.imageDownloadsInProgress=[NSMutableDictionary dictionary];
}


#pragma mark - private methods -
- (void)tipButton_touchUpInside:(id)sender{
    //设置alpha渐变到消失，然后移除
    [UIView animateWithDuration:1 
                     animations:^{
                         self.tipBtn.alpha=0.0;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [[FEBAppConfig sharedAppConfig] setValue:[NSNumber numberWithBool:YES] forKey:@"sinaWeibo_main_tip_hasShown"];
                             [self.tipBtn removeFromSuperview];
                         }
                     }];
}

/*
 *设置导航栏标题
 */
-(void)setNavBarTitle:(NSString*)title{
    ((ClickableLabel*)[self.parentViewController.navigationItem.titleView viewWithTag:NAVIGATIONTITLELBL_TAG]).text=title;
    SinaWeiboSwitchController *switchCtrller=(SinaWeiboSwitchController*)self.parentViewController;
    if (switchCtrller) {
        [switchCtrller.childControllerNavTitlesArr replaceObjectAtIndex:0 withObject:title];
    }
}

- (void)showListView
{
    _groupOptions = [NSArray arrayWithObjects:
                     [NSDictionary dictionaryWithObjectsAndKeys:@"全部微博",@"text",@"0",@"value", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"原创微博",@"text",@"1",@"value", nil], 
                     [NSDictionary dictionaryWithObjectsAndKeys:@"图片微博",@"text",@"2",@"value", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"视频微博",@"text",@"3",@"value", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"音乐微博",@"text",@"4",@"value", nil],
                     nil];
    
    PopListView *popListView = [[PopListView alloc] initWithTitle:@"分组列表" options:self.groupOptions];
    popListView.delegate = self;
    [popListView showInView:self.parentViewController.navigationController.view animated:YES];
    [popListView release];
}

#pragma mark -  PopListView delegates
- (void) PopListView:(PopListView *)popListView
    didSelectedIndex:(NSInteger)anIndex
{
    [self setNavBarTitle:[[self.groupOptions objectAtIndex:anIndex] objectForKey:@"text"]];
    UIButton *guideBtn=(UIButton*)[self.parentViewController.navigationItem.titleView viewWithTag:POPVIEWGUIDE_TAG];
    [guideBtn setBackgroundImage:[UIImage imageNamed:@"pulldown.png"] forState:UIControlStateNormal];
    self.feature=[[self.groupOptions objectAtIndex:anIndex] objectForKey:@"value"];
    self.since_id=@"0";
    self.max_id=@"0";
    [self loadDataSource];
}

- (void) PopListViewDidCancel
{
    UIButton *guideBtn=(UIButton*)[self.parentViewController.navigationItem.titleView viewWithTag:POPVIEWGUIDE_TAG];
    [guideBtn setBackgroundImage:[UIImage imageNamed:@"pulldown.png"] forState:UIControlStateNormal];
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
    NSInteger code=[error code];
    NSString *errorCode=[[[error userInfo] objectForKey:@"error_code"] stringValue];
    if ((code==100)&&[errorCode isEqualToString:@"21327"]) {
        [GlobalInstance showMessageBoxWithMessage:@"授权已过期，请重新绑定!"];
        [self.engine logOut];
        return;
        
    }
    //关闭加载指示器
    [GlobalInstance showMessageBoxWithMessage:@"获取数据失败"];
}

#pragma mark - Bind check notification handle -
- (void)handleBindNotification:(BOOL)isBound{
    //如果已綁定并且是首次加载
    if (isBound) {
        if (self.dataSource==nil) {
            if (self.tipBtn) {
                [[UIApplication sharedApplication].keyWindow addSubview:self.tipBtn];
                [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.tipBtn];
            }
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
    
    __block SinaWeiboMainController *blockedSelf=self;
    
    //load more
    self.loadMoreDataSourceFunc=^{
        blockedSelf.loadtype=loadMore;
        blockedSelf.page+=1;
        [blockedSelf loadDataSource];
        blockedSelf.isLoadingMore=YES;
    };
    
    //load more completed
    self.loadMoreDataSourceCompleted=^{
        blockedSelf.isLoadingMore=NO;
        [blockedSelf.loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:
         blockedSelf.tableView];
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
        [blockedSelf.refreshHeaderView 
         egoRefreshScrollViewDataSourceDidFinishedLoading:
         blockedSelf.tableView];
    };
    
    self.heightForRowAtIndexPathDelegate=^(UITableView *tableView, NSIndexPath *indexPath){
        BOOL hasWeiboImg=NO;
        BOOL hasSourceImg=NO;
        
        CGFloat currentCellContentHeight=0.0f;                   //当前单元格内容高度
        SinaWeiboInfo *currentWeiboInfo=[blockedSelf.dataSource objectAtIndex:indexPath.row];
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
