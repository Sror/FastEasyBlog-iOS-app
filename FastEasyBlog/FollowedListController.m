//
//  FollowedListController.m
//  FastEasyBlog
//
//  Created by svp on 24.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "FollowedListController.h"
#import "FollowedCell.h"
#import "Followed.h"

#import "WBEngine.h"
#import "OpenApi.h"

#import "SinaWeiboManager.h"
#import "TencentWeiboManager.h"
#import "RenRenManager.h"

#import "ChinesePinYinAddress.h"

@interface FollowedListController()

//设置“刷新”和“加载更多”视图
- (void)initRefreshAndLoadMoreView;

//上提加载更多
-(void)reloadTableViewDataSource1;
-(void)doneLoadingTableViewData1;

//加载当前显示在屏幕中的记录的图片
-(void)loadImagesForOneScreenRows;

//加载关注列表
-(void)loadFollowedList;

//下载图片
- (void)startIconDownload:(NSString*)headurl
             forIndexPath:(NSIndexPath *)indexPath;

//加载新浪微博关注列表
- (void)loadSinaWeiboFollowedList;

//加载腾讯微博关注列表
- (void)loadTencentWeiboFollowedList;

//加载人人好友列表
- (void)loadRenRenFollowedList;

//处理数据源，生成用户的分组集合
- (void)handleDataSourceAndGenerateGroupedUserSet;

//生成索引
- (void)generateIndex;

//分组用户集合
- (void)groupUserSet;

//fields
//----------------------common---------------------------      
@property (nonatomic,retain) LoadMoreTableFooterView *loadMoreFooterView;       
@property (nonatomic,assign) CGPoint point;                                      
@property (nonatomic,assign) BOOL _reloading;
@property (nonatomic,assign) BOOL _reloading1;
@property (nonatomic,retain) NSMutableDictionary *userGroupedDictionary;
@property (nonatomic,retain) NSMutableArray *allIndexCharacter;


//----------------------for sina weibo ------------------
@property (nonatomic,assign) int nextCursor;        //cursor for paging
@property (nonatomic,assign) int prevCursor;        //cursor for paging


//----------------------for tencent weibo ------------------
@property (nonatomic,assign) int reqnum;            //1 to 30 for paging
@property (nonatomic,assign) int startIndex;        //reqnum * (page-1)
@property (nonatomic,assign) int page;


//----------------------for renren weibo ------------------
@property (nonatomic,assign) int pageForRenRen;
@property (nonatomic,assign) int count;             //default:500

@end

@implementation FollowedListController

@synthesize followedTableView,
            followedList,
            imageDownloadsInProgress,
            userGroupedDictionary,
            allIndexCharacter;

- (void)dealloc {
    [followedTableView release],followedTableView=nil;
    [followedList release],followedList=nil;
    [imageDownloadsInProgress release],imageDownloadsInProgress=nil;
    [_loadMoreFooterView release],_loadMoreFooterView=nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             platform:(AllPlatform)pt{
    if(self=[super initWithNibName:nibNameOrNil bundle:nil]){
        _currentLoadType=firstLoad;
		_currentPlatform=pt;
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBarButtonForNavigationBar];
    self.navigationItem.title=@"我关注的好友";
    
    self.followedTableView.delegate=self;
    self.followedTableView.dataSource=self;
    [self.followedTableView reloadData];
    self.followedTableView.hidden=YES;
    
    [self initRefreshAndLoadMoreView];
    [self loadFollowedList];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - tableview delegate -
-(UITableViewCell*)tableView:(UITableView *)tableView
       cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *currentIndexStr=[self.allIndexCharacter objectAtIndex:indexPath.section];
    NSArray *currentSectionDataSource=[self.userGroupedDictionary objectForKey:currentIndexStr];
    
	Followed *followed=[currentSectionDataSource objectAtIndex:indexPath.row];
    static NSString *followedCellIdentifier=@"followedCellIdentifier";
	FollowedCell *cell=[tableView dequeueReusableCellWithIdentifier:followedCellIdentifier];
	if(!cell){
		cell=[[[FollowedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:followedCellIdentifier]autorelease];
	}
	
	cell.nick=followed.nick;
    cell.desc=followed.desc;
	if(!followed.headImg){
		cell.headImg=[UIImage imageNamed:@"placeholder.png"];
        if (self.followedTableView.dragging==NO&&self.followedTableView.decelerating==NO) {
            [self startIconDownload:followed.headImgUrl forIndexPath:indexPath];
        }
	}else{
		cell.headImg=followed.headImg;
	}
	
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    NSString *currentIndexStr=[self.allIndexCharacter objectAtIndex:indexPath.section];
    NSArray *currentSectionDataSource=[self.userGroupedDictionary objectForKey:currentIndexStr];
    
    Followed *selectedFollowed=[currentSectionDataSource objectAtIndex:indexPath.row];
    if (selectedFollowed==nil) {
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(didSelectedFollowed:)]) {
            [self.delegate didSelectedFollowed:selectedFollowed];
        }
    }];
}

//用于分组与索引
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	NSArray *sectionDataSource=[self.userGroupedDictionary objectForKey:[self.allIndexCharacter objectAtIndex:section]];
    
    return [sectionDataSource count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.allIndexCharacter count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.allIndexCharacter objectAtIndex:section];
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *result = [[[NSMutableArray alloc]init] autorelease];
    
    for(char c = 'A';c<='Z';c++)
        
        [result addObject:[NSString stringWithFormat:@"%c",c]];
    
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSInteger sectionIndex=0;
    for (NSString *indexCharStr in self.allIndexCharacter) {
        if ([title isEqualToString:indexCharStr]) {
            return sectionIndex;
        }
        sectionIndex++;
    }
    
    return sectionIndex;
}


#pragma mark - load followed list -
/*
 *加载关注列表
 */
-(void)loadFollowedList{
	switch (self.currentPlatform) {
        case SinaWeibo:
        {
            [self loadSinaWeiboFollowedList];
        }
            break;
            
        case RenRen:
        {
            [self loadRenRenFollowedList];
        }
            break;
            
        case TencentWeibo:
        {
            [self loadTencentWeiboFollowedList];
        }
            break;
            
        default:
            break;
    }
    
	self.imageDownloadsInProgress=[NSMutableDictionary dictionary];
}

/*
 *加载新浪微博关注列表
 */
- (void)loadSinaWeiboFollowedList{
	WBEngine *engine = [[WBEngine alloc]initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    engine.delegate=self;
	NSMutableDictionary *requestParams=[[NSMutableDictionary alloc]init];
    [requestParams setObject:engine.userID forKey:@"uid"];
    [requestParams setObject:@"50" forKey:@"count"];
    [requestParams setObject:@"0" forKey:@"trim_status"];
    switch (self.currentLoadType) {
        case firstLoad:
            [requestParams setObject:@"0" forKey:@"cursor"];
            break;
            
        case loadMore:
        {
            if (self.nextCursor==0) {       //没有更多记录
                [requestParams release];
                return;
            }
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.nextCursor] forKey:@"cursor"];
        }
            
            break;
            
        default:
            break;
    }
    
    [engine loadRequestWithMethodName:@"friendships/friends.json"
                           httpMethod:@"GET"
                               params:requestParams
                         postDataType:kWBRequestPostDataTypeNone
                     httpHeaderFields:nil];
    
    [requestParams release];
    
    //启用加载指示器
//    hud = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
//    hud.delegate=self;
}

/*
 *加载腾讯微博关注列表
 */
- (void)loadTencentWeiboFollowedList{
	OpenApi *myApi=[TencentWeiboManager getOpenApi];
    myApi.delegate=self;
    
    switch (self.currentLoadType) {
        case firstLoad:
        {
            self.page=1;
            [myApi getMyIdollist:@"json" reqnum:@"30" startIndex:@"0" install:@"0"];
        }
            break;
            
        case loadMore:
        {
            self.startIndex=(self.page-1)*30;
            [myApi getMyIdollist:@"json" reqnum:@"30" startIndex:[NSString stringWithFormat:@"%d",self.startIndex] install:@"0"];
        }
            break;
            
        default:
            break;
    }
}

/*
 *加载人人好友列表
 */
- (void)loadRenRenFollowedList{
    if (self.currentLoadType==firstLoad) {
        self.pageForRenRen=1;
    }
    
	NSMutableDictionary *params=[NSMutableDictionary dictionaryWithCapacity:10];
	[params setObject:@"friends.getFriends" forKey:@"method"];
	[params setObject:@"JSON" forKey:@"format"];
	[params setObject:[NSString stringWithFormat:@"%d",self.pageForRenRen] forKey:@"page"];
	[params setObject:@"500" forKey:@"count"];
    [params setObject:@"" forKey:@"fields"];
	[[Renren sharedRenren]requestWithParams:params andDelegate:self];
}


#pragma mark - about head image -
- (void)startIconDownload:(NSString*)headurl
             forIndexPath:(NSIndexPath *)indexPath{
    IconDownloader *headImgDownLoader=[self.imageDownloadsInProgress objectForKey:indexPath];
    if (!headImgDownLoader) {
        headImgDownLoader=[[IconDownloader alloc]init];
        headImgDownLoader.imgUrl=headurl;
        headImgDownLoader.imgHeight=40.0f;
        headImgDownLoader.imgWidth=40.0f;
        headImgDownLoader.indexPathInTableView=indexPath;
        headImgDownLoader.delegate=self;
        [self.imageDownloadsInProgress setObject:headImgDownLoader forKey:indexPath];
        [headImgDownLoader startDownload];
        [headImgDownLoader release];
    }
}

/*
 *下载完成之后的回调方法
 */
-(void)appImageDidLoad:(NSIndexPath *)indexPath{
    NSString *currentIndexStr=[self.allIndexCharacter objectAtIndex:indexPath.section];
    NSArray *currentSectionDataSource=[self.userGroupedDictionary objectForKey:currentIndexStr];
    
    Followed *followed=[currentSectionDataSource objectAtIndex:indexPath.row];
    FollowedCell *cell=(FollowedCell*)[self.followedTableView cellForRowAtIndexPath:indexPath];
    IconDownloader *iconDownloader=nil;
    iconDownloader=[self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader) {
        followed.headImg=iconDownloader.appIcon;
        cell.headImg=iconDownloader.appIcon;
    }
}

#pragma mark -
#pragma mark about load more data or refresh new data
/*
 *加载当前显示在屏幕中的记录的图片
 */
-(void)loadImagesForOneScreenRows{
    if ([self.followedList count]>0) {
        //取得当前tableview中的可见cell集合
        NSArray *visiblePaths=[self.followedTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            
            NSString *currentIndexStr=[self.allIndexCharacter objectAtIndex:indexPath.section];
            NSArray *currentSectionDataSource=[self.userGroupedDictionary objectForKey:currentIndexStr];
            
            Followed *followed=[currentSectionDataSource objectAtIndex:indexPath.row];
            if (!followed.headImg) {
                [self startIconDownload:followed.headImgUrl forIndexPath:indexPath];
            }
        }
    }
}

#pragma mark - WBEngineDelegate Methods (Sina weibo) -
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    if ([result isKindOfClass:[NSDictionary class]])
    {
        //get paged cursor
        self.nextCursor=[[result objectForKey:@"next_cursor"]intValue];
        self.prevCursor=[[result objectForKey:@"previous_cursor"]intValue];
        
        switch (self.currentLoadType) {
            case firstLoad:
                self.followedList=[SinaWeiboManager resolveSinaWeiboFollowedUserInfo:result];
                break;
                
            case loadMore:
            {
                NSMutableArray *newList=[[[NSMutableArray alloc]initWithArray:self.followedList copyItems:NO]autorelease];
                NSMutableArray *tmpArr=[SinaWeiboManager resolveSinaWeiboFollowedUserInfo:result];
                if ([tmpArr count]!=0) {
                    [newList addObjectsFromArray:tmpArr];
                    self.followedList=newList;
                }
            }
                break;
                
            default:
                break;
        }
        
        [self handleDataSourceAndGenerateGroupedUserSet];
        self.followedTableView.hidden=NO;
        [self.followedTableView reloadData];
    }
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    [GlobalInstance showMessageBoxWithMessage:@"获取数据失败"];
}

#pragma mark - RenrenDelegate (ren ren) -
-(void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse *)response{
	switch (self.currentLoadType) {
        case firstLoad:
            self.followedList=[RenRenManager resolveRenRenFriends:response];
            break;
            
        case loadMore:
        {
            NSMutableArray *newList=[[[NSMutableArray alloc]initWithArray:self.followedList copyItems:NO]autorelease];
            NSMutableArray *tmpArr=[RenRenManager resolveRenRenFriends:response];
            if ([tmpArr count]!=0) {
                [newList addObjectsFromArray:tmpArr];
                self.followedList=newList;
            }
        }
            break;
            
        default:
            break;
    }
    
    [self handleDataSourceAndGenerateGroupedUserSet];
    self.followedTableView.hidden=NO;
    [self.followedTableView reloadData];
}

-(void)renren:(Renren *)renren requestFailWithError:(ROError *)error{	
	[GlobalInstance showMessageBoxWithMessage:@"获取数据失败"];
}

#pragma mark - TencentWeibo Delegate (tencent weibo ) -
- (void)tencentWeiboRequestDidReturnResponseForOthers:(id)result{
    NSMutableArray *followedArr=(NSMutableArray *)result;
    if (followedArr) {
        switch (self.currentLoadType) {
            case firstLoad:
                self.followedList=followedArr;
                break;
                
            case loadMore:
            {
                NSMutableArray *newList=[[[NSMutableArray alloc]initWithArray:self.followedList copyItems:NO]autorelease];
                if ([followedArr count]!=0) {
                    [newList addObjectsFromArray:followedArr];
                    self.followedList=newList;
                }
            }
                break;
                
            default:
                
                break;
        }
        [self handleDataSourceAndGenerateGroupedUserSet];
        self.followedTableView.hidden=NO;
        [self.followedTableView reloadData];
    }
}

- (void)tencentWeiboRequestFailWithError{
    [GlobalInstance showMessageBoxWithMessage:@"获取数据失败!"];
}

#pragma mark - NavigationBar handle logic-
/*
 *为导航栏设置左侧的自定义返回按钮
 */
-(void)setLeftBarButtonForNavigationBar{
    
    UIButton *btn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                 frame:CGRectMake(0, 0, 45, 45)
                                               imgName:@"closeBtn.png"
                                           eventTarget:self
                                           touchUpFunc:@selector(closeButton_touchUpInside)
                                         touchDownFunc:@selector(closeButton_touchDown)];
	
	UIBarButtonItem *backBarItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
	self.navigationItem.leftBarButtonItem=backBarItem;
	[backBarItem release];
}

-(void)closeButton_touchUpInside{
    UIButton *btn=(UIButton*)self.navigationItem.leftBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
	
    [self dismissModalViewControllerAnimated:YES];
}

-(void)closeButton_touchDown{
	UIButton *btn=(UIButton*)self.navigationItem.leftBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"closeBtn_highlight.png"] forState:UIControlStateNormal];
}

#pragma mark - about refresh and loadMore -
/*
 *设置“刷新”和“加载更多”视图
 */
- (void)initRefreshAndLoadMoreView{
	//设置上提载入更多视图
	if (_loadMoreFooterView==nil) {
		_loadMoreFooterView=[[LoadMoreTableFooterView alloc]
                             initWithFrame:CGRectMake(0.0f, 
                                                      self.followedTableView.contentSize.height,
                                                      self.followedTableView.frame.size.width,
                                                      self.followedTableView.bounds.size.height)];
		
		_loadMoreFooterView.delegate=self;
		[self.followedTableView addSubview:self.loadMoreFooterView];
	}
    
}

/*
 *上提加载更多
 */
-(void)reloadTableViewDataSource1{
    if (self.currentPlatform==TencentWeibo) {
        self.page+=1;
    }else if(self.currentPlatform==RenRen){
        self.pageForRenRen+=1;
    }
    self.currentLoadType=loadMore;
    [self loadFollowedList];
    self._reloading1=YES;
}

-(void)doneLoadingTableViewData1{
    self._reloading1=NO;
    [self.loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.followedTableView];
}


#pragma mark -
#pragma mark LoadMoreTableFooterDelegate Methods
- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreTableFooterView *)view{
    [self reloadTableViewDataSource1];
    [self performSelector:@selector(doneLoadingTableViewData1) withObject:nil afterDelay:3.0];
}

- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view{
    return self._reloading1;
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    self.point=scrollView.contentOffset;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint pt=scrollView.contentOffset;
    //上提－加载更多
    if (self.point.y<pt.y) {
        [self.loadMoreFooterView loadMoreScrollViewDidScroll:scrollView];
    }
}

//停止拖动时触发
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate{
    CGPoint pt=scrollView.contentOffset;
    //上提－加载更多
    if (self.point.y<pt.y) {
        [self.loadMoreFooterView loadMoreScrollViewDidEndDragging:scrollView];
    }
    
    if (!decelerate) {
        [self loadImagesForOneScreenRows];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self loadImagesForOneScreenRows];
}

#pragma mark - user group -
/*
 *处理数据源，生成用户的分组集合
 */
- (void)handleDataSourceAndGenerateGroupedUserSet{
    if (!self.followedList||[self.followedList count]==0) {
        return;
    } 
    [self generateIndex];
    [self groupUserSet];
}

//生成索引
- (void)generateIndex{
    NSMutableArray *tmpAllIndexCharacter=[[NSMutableArray alloc]init];
    for (int i=0; i<self.followedList.count; i++) {
        Followed *obj=(Followed*)[self.followedList objectAtIndex:i];
        BOOL isChinese=[GlobalInstance isChineseCharacter:[obj.nick characterAtIndex:0]];
        NSString *firstString=@"#";
        if (isChinese) {
            char firstChar=pinyinFirstLetter([obj.nick characterAtIndex:0]);
            firstString=[NSString stringWithFormat:@"%c",firstChar];
        }else{
            firstString=[obj.nick substringWithRange:NSMakeRange(0, 1)];
        }

        if (![tmpAllIndexCharacter containsObject:[firstString uppercaseString]]) {
            [tmpAllIndexCharacter addObject:[firstString uppercaseString]];
        }
    }
    self.allIndexCharacter=tmpAllIndexCharacter;
    [tmpAllIndexCharacter release];
    
    //sort
    [self.allIndexCharacter sortUsingSelector:@selector(compare:)];
}

//分组用户集合
- (void)groupUserSet{
    NSMutableDictionary *tmpUserGroupedSet=[[NSMutableDictionary alloc]init];
    for (NSString *sectionString in self.allIndexCharacter) {
        NSMutableArray *sectionDataSource=[[NSMutableArray alloc]init];
        for (Followed *followed in self.followedList) {
            BOOL isChinese=[GlobalInstance isChineseCharacter:[followed.nick characterAtIndex:0]];
            NSString *firstCharStr=@"#";
            
            if (isChinese) {
                char firstChar=pinyinFirstLetter([followed.nick characterAtIndex:0]);
                firstCharStr=[NSString stringWithFormat:@"%c",firstChar];
            }else{
                firstCharStr=[followed.nick substringWithRange:NSMakeRange(0, 1)];
            }

            if ([sectionString isEqualToString:[firstCharStr uppercaseString]]) {
                [sectionDataSource addObject:followed];
            }
        }
        [tmpUserGroupedSet setValue:sectionDataSource forKey:sectionString];
        [sectionDataSource release];
    }
    self.userGroupedDictionary=tmpUserGroupedSet;
    [tmpUserGroupedSet release];
}


@end
