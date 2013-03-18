//
//  RenRenMainController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "RenRenMainController.h"
#import "RenRenFeedCategoryController.h"
#import "RenRenManager.h"
#import "RenRenNews.h"
#import "RenRenAttachment.h"
#import "RenRenSource.h"
#import "RenRenNewsTableViewCell.h"
#import "RenRenNewsTableViewCellForStatus.h"
#import "RenRenNewsTableViewCellForBlog.h"
#import "RenRenNewsTableViewCellForPhoto.h"
#import "RenRenRePublishOrCommentController.h"
#import "RenRenPublishController.h"

#import "BlogDetailController.h"
#import "StatusDetailController.h"
#import "PhotoDetailController.h"

#define CELL_CONTENT_MARGIN 0.0f
#define MIN_CONTENT_HEIGHT 20.0f
#define CELL_CONTENT_WIDTH 245.0f
#define CELL_CONTENT_MARGIN 0.0f
#define MIN_CONTENT_HEIGHT 20.0f

#define DEFAULT_CONSTRAINT_SIZE \
CGSizeMake(CELL_CONTENT_WIDTH-(CELL_CONTENT_MARGIN*2),20000.f)

//以下常量用来显示“五分之四”效果
#define KMENUFULLWIDTH 320.0f
#define KMENUDISPLAYEDWIDTH 280.0f
#define	KMENUOVERLAYWIDTH (self.view.bounds.size.width-KMENUDISPLAYEDWIDTH)
#define KMENUBOUNCEOFFSET 10.0f
#define KMENUBOUNCEDURATION .3f
#define KMENUSLIDEDURATION .3f

typedef enum{
    TAG_HOMEPAGE_BUTTON,
    TAG_PUBLISH_BUTTON
}TAG;

@interface RenRenMainController()

// Private Properties:（分屏效果）
@property (retain, nonatomic) UIPanGestureRecognizer *navigationBarPanGestureRecognizer;
@property (nonatomic,retain) UIButton *tipBtn;

//设置“刷新”和“加载更多”视图
- (void)initRefreshAndLoadMoreView;

//设置左侧自定义导航按钮
-(void)setLeftBarButtonForNavigationBar;

//实例化状态单元格
-(UITableViewCell*)initCellForStatusWithIndexPath:(NSIndexPath*)indexPath
                                   withRenRenNews:(RenRenNews*)news
                                     forTableView:(UITableView*)tableView;

//实例化日志单元格
-(UITableViewCell*)initCellForBlogWithIndexPath:(NSIndexPath*)indexPath
                                 withRenRenNews:(RenRenNews*)news
                                   forTableView:(UITableView*)tableView;

//实例化照片单元格
-(UITableViewCell*)initCellForPhotoWithIndexPath:(NSIndexPath*)indexPath
                                  withRenRenNews:(RenRenNews*)news
                                    forTableView:(UITableView*)tableView;

//注册手势
- (void)registerGestureOperation;

//手势处理逻辑
- (void)handleGesture:(UISwipeGestureRecognizer*)gestureRecognizer;

@end


@implementation RenRenMainController

@synthesize photoArray=_photoArray;
@synthesize newsTableView;
@synthesize newsList;
@synthesize imageDownloadsInProgress;
@synthesize currentPage;
@synthesize navigationBarPanGestureRecognizer = _navigationBarPanGestureRecognizer;
@synthesize currentCategories;
@synthesize tipBtn=_tipBtn;

#pragma mark -
#pragma mark life cycle

- (void)dealloc {
    [_photoArray release],_photoArray=nil;
	_refreshHeaderView=nil;
	_loadMoreFooterView=nil;
	[newsTableView release];
	[newsList release];
	[imageDownloadsInProgress release];
    [_navigationBarPanGestureRecognizer release],_navigationBarPanGestureRecognizer=nil;
    [currentCategories release],currentCategories=nil;
	[super dealloc];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
        //21,23分别表示个人和主页分享的日志
        self.currentCategories=@"10,11,20,21,22,23,30,31,32,36";
        currentPage=1;
	}
	return self;
}


- (void)viewDidLoad {
	[super viewDidLoad];
    super.delegate=self;
    super.bindCheckHandleDelegate=self;
    self.navigationController.delegate=self;
	self.navigationItem.title=@"新鲜事";
	
	self.newsTableView.delegate=self;
	self.newsTableView.dataSource=self;
    self.newsTableView.hidden=YES;
	
    //设置“刷新”和“加载更多”视图
    [self initRefreshAndLoadMoreView];
    
	//设置最后一次的“更新时间”
	[_refreshHeaderView refreshLastUpdatedDate];
    
	//注册微博列表的手势
    [self registerGestureOperation];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setRightBarButtonForNavigationBar];
	
	if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
		if (![[self.navigationController.navigationBar gestureRecognizers] containsObject:self.navigationBarPanGestureRecognizer])
		{
			UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
			self.navigationBarPanGestureRecognizer = panGestureRecognizer;
			[panGestureRecognizer release];
			
			[self.navigationController.navigationBar addGestureRecognizer:self.navigationBarPanGestureRecognizer];
		}
		
		// Check if we have a revealButton already.
		if (![self.navigationItem leftBarButtonItem])
		{
			// If not, allocate one and add it.
			[self setLeftBarButtonForNavigationBar];
		}
	}
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return NO;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
    self.newsTableView=nil;
    self.newsList=nil;
	_refreshHeaderView=nil;
	_loadMoreFooterView=nil;
}

- (void)tipButton_touchUpInside:(id)sender{
    //设置alpha渐变到消失，然后移除
    [UIView animateWithDuration:1 
                     animations:^{
                         self.tipBtn.alpha=0.0;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [[FEBAppConfig sharedAppConfig] setValue:[NSNumber numberWithBool:YES] forKey:@"renren_main_tip_hasShown"];
                             [self.tipBtn removeFromSuperview];
                         }
                     }];
}


#pragma mark - RenrenDelegate -
-(void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse *)response{
    //判斷加載類型
    switch (loadtype) {
        case firstLoad:
            self.newsList=[RenRenManager resolveNewsToObject:response];
            break;
            
        case refresh:           //由於人人API的原因，刷新跟首次加載處理方式相同
            self.newsList=[RenRenManager resolveNewsToObject:response];
            break;
            
        case loadMore:
        {
            NSMutableArray *newList=[[[NSMutableArray alloc]initWithArray:self.newsList copyItems:NO]autorelease];
            NSMutableArray *tmpArr=[RenRenManager resolveNewsToObject:response];
            if ([tmpArr count]!=0) {
                [newList addObjectsFromArray:tmpArr];
                self.newsList=newList;
            }
        }
            break;
            
        default:
            break;
    }
    
	self.newsTableView.hidden=NO;
	[self.newsTableView reloadData];
    
    [GlobalInstance hideHUD:self.hud];
}

-(void)renren:(Renren *)renren requestFailWithError:(ROError *)error{
    //关闭加载指示器
    [GlobalInstance hideHUD:self.hud];
	[GlobalInstance showMessageBoxWithMessage:@"API请求错误"];
}

#pragma mark -
#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [self.newsList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView
       cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.row<self.newsList.count) {
		RenRenNews *news=(RenRenNews*)[self.newsList objectAtIndex:indexPath.row];
		if ([news.feed_type intValue]==10||[news.feed_type intValue]==11) {			//状态
			return [self initCellForStatusWithIndexPath:indexPath withRenRenNews:news forTableView:tableView];
		}else if ([news.feed_type intValue]==20||[news.feed_type intValue]==21||[news.feed_type intValue]==22||[news.feed_type intValue]==23) {		//日志
			return [self initCellForBlogWithIndexPath:indexPath withRenRenNews:news forTableView:tableView];
		}else if([news.feed_type intValue]==30||[news.feed_type intValue]==31||[news.feed_type intValue]==32||[news.feed_type intValue]==36){     //照片
            return [self initCellForPhotoWithIndexPath:indexPath withRenRenNews:news forTableView:tableView];
        }
	}
	
	return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	//浮动的内容高度
	CGFloat floatContentHeight=0.0;
	RenRenNews *news=(RenRenNews*)[self.newsList objectAtIndex:indexPath.row];
	if ([news.feed_type intValue]==10||[news.feed_type intValue]==11) {
		floatContentHeight=[GlobalInstance getHeightWithFontText:news.message font:RENRENSTATUSFONT constraint:DEFAULT_CONSTRAINT_SIZE minHeight:MIN_CONTENT_HEIGHT]+5.0f;
	}else if ([news.feed_type intValue]==20||[news.feed_type intValue]==21||[news.feed_type intValue]==22||[news.feed_type intValue]==23) {
		floatContentHeight=[GlobalInstance getHeightWithText:news.title fontSize:15 constraint:DEFAULT_CONSTRAINT_SIZE minHeight:MIN_CONTENT_HEIGHT]+[GlobalInstance getHeightWithFontText:news.description font:RENRENBLOGINTRODUCTIONFONT constraint:DEFAULT_CONSTRAINT_SIZE minHeight:MIN_CONTENT_HEIGHT];
		floatContentHeight+=5.0f;
	}else if([news.feed_type intValue]==30||[news.feed_type intValue]==31||[news.feed_type intValue]==32||[news.feed_type intValue]==36){
//        CGFloat albumNameHeight=[GlobalInstance getHeightWithFontText:news.title font:RENRENALBUMNAMEFONT constraint:DEFAULT_CONSTRAINT_SIZE minHeight:20];
        floatContentHeight=[GlobalInstance getHeightWithText:((RenRenAttachment*)[news.attachment objectAtIndex:0]).content fontSize:15.0f constraint:CGSizeMake(320, 480) minHeight:20.0];
    }
	
	return TABLE_HEADER_HEIGHT+floatContentHeight+TABLE_FOOTER_HEIGHT;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
	int index=indexPath.row;
	RenRenNews *currentNews=[self.newsList objectAtIndex:index];
    //日誌
	if ([currentNews.feed_type intValue]==20||[currentNews.feed_type intValue]==21||[currentNews.feed_type intValue]==22||[currentNews.feed_type intValue]==23) {
        BlogDetailController *detailController=[[[BlogDetailController alloc]initWithNibName:@"BlogDetailView" bundle:nil news:currentNews]autorelease];
        
		[self.navigationController pushViewController:detailController animated:YES];
	}else if([currentNews.feed_type intValue]==10||[currentNews.feed_type intValue]==11){
        StatusDetailController *detailCtrller=[[[StatusDetailController alloc]initWithNibName:@"StatusDetailView" bundle:nil news:currentNews]autorelease];
        
        [self.navigationController pushViewController:detailCtrller animated:YES];
    }else if([currentNews.feed_type intValue]==30||[currentNews.feed_type intValue]==31||[currentNews.feed_type intValue]==32||[currentNews.feed_type intValue]==36){
        PhotoDetailController *detailCtrller=[[[PhotoDetailController alloc]initWithNibName:@"PhotoDetailView" bundle:nil news:currentNews]autorelease];
        
        [self.navigationController pushViewController:detailCtrller animated:YES];
    }
}


#pragma mark -
#pragma mark about head image
- (void)startIconDownload:(NSString*)headurl
             forIndexPath:(NSIndexPath *)indexPath{
	IconDownloader *downLoader=[self.imageDownloadsInProgress objectForKey:indexPath];
	if (!downLoader) {
		downLoader=[[[IconDownloader alloc]init]autorelease];
		downLoader.imgUrl=headurl;
		downLoader.imgHeight=40.0f;
		downLoader.imgWidth=40.0f;
		downLoader.indexPathInTableView=indexPath;
		downLoader.delegate=self;
		[self.imageDownloadsInProgress setObject:downLoader forKey:indexPath];
		[downLoader startDownload];
	}
}

/*
 *下载完成之后的回调方法
 */
-(void)appImageDidLoad:(NSIndexPath *)indexPath{
	IconDownloader *iconDownloader=[self.imageDownloadsInProgress objectForKey:indexPath];
	if (iconDownloader) {
		RenRenNews *news=(RenRenNews*)[self.newsList objectAtIndex:indexPath.row];
		news.headImg=iconDownloader.appIcon;
		RenRenNewsTableViewCell *cell=(RenRenNewsTableViewCell*)[self.newsTableView cellForRowAtIndexPath:indexPath];
		cell.headImage=iconDownloader.appIcon;
	}
}


//加载当前显示在屏幕中的记录的图片
-(void)loadImagesForOneScreenRows{
    if ([self.newsList count]>0) {
        //取得当前tableview中的可见cell集合
        NSArray *visiblePaths=[self.newsTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            RenRenNews *renrenNews=(RenRenNews*)[self.newsList objectAtIndex:indexPath.row];
            if (!renrenNews.headImg) {
                [self startIconDownload:renrenNews.headurl forIndexPath:indexPath];
            }
            
            //如果为图片单元格,则需要加载图片
            if ([renrenNews.feed_type intValue]==30||[renrenNews.feed_type intValue]==31||[renrenNews.feed_type intValue]==32||[renrenNews.feed_type intValue]==36) {
                if (!renrenNews.photoImg) {
                    RenRenNewsTableViewCellForPhoto *photoCell=(RenRenNewsTableViewCellForPhoto*)[self.newsTableView cellForRowAtIndexPath:indexPath];
                    if (photoCell) {
                        [photoCell.photoImgView setImageWithURL:[NSURL URLWithString:((RenRenAttachment*)[renrenNews.attachment objectAtIndex:0]).raw_src]
                                               placeholderImage:[UIImage imageNamed:@"smallImagePlaceHolder.png"] 
                                                        success:^(UIImage *image, BOOL cached) {
                                                            CGSize itemSize=CGSizeMake(SMALL_PHOTO_WIDTH*2, SMALL_PHOTO_HEIGHT*2);
                                                            renrenNews.photoImg=[GlobalInstance thumbnailWithImageWithoutScale:image size:itemSize];
                                                            photoCell.photoImg=renrenNews.photoImg;
                                                            
                                                        } 
                                                        failure:^(NSError *error) {
                                                            
                                                        }];
                    }
                    
                }
            }
        }
    }
}

/*
 *下拉刷新
 */
-(void)reloadTableViewDataSource{
	//加载新鲜事信息
	currentPage=1;
	[self loadNewsInfoList];
	_reloading=YES;
    loadtype=refresh;               //設置加載類型為刷新
}

-(void)doneLoadingTableViewData{
	_reloading=NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.newsTableView];
}

/*
 *上提加载更多
 */
-(void)reloadTableViewDataSource1{
	currentPage+=1;
	[self loadNewsInfoList];
	_reloading1=YES;
    loadtype=loadMore;              //設置加載類型為“加載更多”
}

-(void)doneLoadingTableViewData1{
	_reloading1=NO;
	[_loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.newsTableView];
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
        [self loadImagesForOneScreenRows];
	}
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self loadImagesForOneScreenRows];
}

#pragma mark - about UI -
/*
 *设置左侧自定义导航按钮
 */
-(void)setLeftBarButtonForNavigationBar{
	UIButton *leftNavigationBarItem=[UIButton buttonWithType:UIButtonTypeCustom];
	leftNavigationBarItem.frame=CGRectMake(5, 5, 38, 32);
	[leftNavigationBarItem addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
	[leftNavigationBarItem setBackgroundImage:[UIImage imageNamed:@"feedType.png"] forState:UIControlStateNormal];
	UIBarButtonItem *leftBarItem=[[UIBarButtonItem alloc]initWithCustomView:leftNavigationBarItem];
	
	self.navigationItem.leftBarButtonItem=leftBarItem;
	[leftBarItem release];
}

/*
 *为导航栏设置右侧的自定义按钮
 */
-(void)setRightBarButtonForNavigationBar{
    //homePage button
    UIButton *homePageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    homePageBtn.tag=TAG_HOMEPAGE_BUTTON;
    homePageBtn.frame=CGRectMake(275,0,40,40);
    [homePageBtn setBackgroundImage:[UIImage imageNamed:@"homePageBtn.png"] forState:UIControlStateNormal];
    [homePageBtn addTarget:self action:@selector(homePageBtn_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [homePageBtn addTarget:self action:@selector(homePageBtn_TouchDown:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *menuBtn_homePage=[[UIBarButtonItem alloc]initWithCustomView:homePageBtn];
    
    //publish button 
    UIButton *publishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.tag=TAG_PUBLISH_BUTTON;
    publishBtn.frame=CGRectMake(240, 0,33,33);
    [publishBtn setBackgroundImage:[UIImage imageNamed:@"publish_SubBtn.png"] forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishBtn_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [publishBtn addTarget:self action:@selector(publishBtn_TouchDown:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *menuBtn_publish=[[UIBarButtonItem alloc]initWithCustomView:publishBtn];
    NSArray *barButtonItemArr=[[NSArray alloc]initWithObjects:menuBtn_homePage,menuBtn_publish, nil];
    
    self.navigationItem.rightBarButtonItems=barButtonItemArr;
    [menuBtn_homePage release];
    [menuBtn_publish release];
    [barButtonItemArr release];
}

- (void)publishBtn_TouchUpInside:(id)sender{
    //移除高亮效果
	UIButton *btn=nil;
    NSArray *barButtonArr=self.navigationItem.rightBarButtonItems;
    for (NSObject *item in barButtonArr) {
        UIButton *tmpBtn=(UIButton*)(((UIBarButtonItem*)item).customView);
        if (tmpBtn.tag==TAG_PUBLISH_BUTTON) {
            btn=tmpBtn;
            continue;
        }
    }
    if (btn) {
        [btn setBackgroundImage:[UIImage imageNamed:@"publish_SubBtn.png"] forState:UIControlStateNormal];
        
        if ([AppConfig(@"isAudioOpen") boolValue]) {
            [GlobalInstance playTipAudio:[[NSBundle mainBundle] URLForResource:@"drip" withExtension:@"WAV"]];
        }
    }
    
    RenRenPublishController *renrenPubCtrller=[[RenRenPublishController alloc]initWithNibName:@"RenRenPublishView" bundle:nil];
    UINavigationController *renrenNavCtrller=[[UINavigationController alloc]initWithRootViewController:renrenPubCtrller];
    [renrenPubCtrller release];
    
    [self presentModalViewController:renrenNavCtrller animated:YES];
    [renrenNavCtrller release];
}

- (void)publishBtn_TouchDown:(id)sender{
    UIButton *btn=nil;
    NSArray *barButtonArr=self.navigationItem.rightBarButtonItems;
    for (NSObject *item in barButtonArr) {
        UIButton *tmpBtn=(UIButton*)(((UIBarButtonItem*)item).customView);
        if (tmpBtn.tag==TAG_PUBLISH_BUTTON) {
            btn=tmpBtn;
            continue;
        }
    }
    if (btn) {
	[btn setBackgroundImage:[UIImage imageNamed:@"publish_SubBtn.png"] forState:UIControlStateNormal];
    }
}


#pragma mark -
#pragma mark others
/*
 *加载新鲜事列表
 */
-(void)loadNewsInfoList{
    if (![RenRenManager isBoundToApplication]) {
        return;
    }
	NSMutableDictionary *params=[NSMutableDictionary dictionaryWithCapacity:10];
	[params setObject:@"feed.get" forKey:@"method"];
	[params setObject:self.currentCategories forKey:@"type"];
	[params setObject:@"JSON" forKey:@"format"];
	[params setObject:[NSString stringWithFormat:@"%d",currentPage] forKey:@"page"];
	[params setObject:@"30" forKey:@"count"];
	[[Renren sharedRenren]requestWithParams:params andDelegate:self];
    
    [GlobalInstance showHUD:@"新鲜事加载中,请稍后..." andView:self.view andHUD:self.hud];
	
	//实例化图片缓存/下载对象
	self.imageDownloadsInProgress=[NSMutableDictionary dictionary];
}

/*
 *实例化状态单元格
 */
-(UITableViewCell*)initCellForStatusWithIndexPath:(NSIndexPath*)indexPath
                                   withRenRenNews:(RenRenNews*)news
                                     forTableView:(UITableView*)tableView{
	static NSString *identifierForStatus=@"newsCellIdentifierForStatus";
	RenRenNewsTableViewCellForStatus *cell=(RenRenNewsTableViewCellForStatus *)[tableView dequeueReusableCellWithIdentifier:identifierForStatus];
    [cell retain];
	if (cell==nil) {
		cell=[[RenRenNewsTableViewCellForStatus alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierForStatus];
        [cell retain];
	}
	
	if (!news.headImg) {
		cell.headImage=[UIImage imageNamed:@"placeholder.png"];
		if (self.newsTableView.dragging==NO&&self.newsTableView.decelerating==NO) {
            [self startIconDownload:news.headurl forIndexPath:indexPath];
		}
	}else {
		cell.headImage=news.headImg;
	}
	
	cell.feedType=news.feed_type;
	cell.userName=news.name;
	cell.publishDate=[RenRenManager resolveRenRenDate:news.update_time];
	cell.statusContent=news.message;
	
    //	cell.commentNum=[NSString stringWithFormat:@"评论 %d",[[news.comments objectForKey:@"count"]intValue]];
	[cell resizeViewFrames];
	
	return cell;
	
}

//实例化日志单元格
-(UITableViewCell*)initCellForBlogWithIndexPath:(NSIndexPath*)indexPath
                                 withRenRenNews:(RenRenNews*)news
                                   forTableView:(UITableView*)tableView{
	static NSString *identifierForBlog=@"newsCellIdentifierForBlog";
	RenRenNewsTableViewCellForBlog *cell=nil;
    
    cell=(RenRenNewsTableViewCellForBlog *)[tableView dequeueReusableCellWithIdentifier:identifierForBlog];
    [cell retain];
    if (cell==nil) {
        cell=[[RenRenNewsTableViewCellForBlog alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierForBlog];
        [cell retain];
    }
	
	if (!news.headImg) {
		cell.headImage=[UIImage imageNamed:@"placeholder.png"];
		if (self.newsTableView.dragging==NO&&self.newsTableView.decelerating==NO) {
            [self startIconDownload:news.headurl forIndexPath:indexPath];
		}
	}else {
		cell.headImage=news.headImg;
	}
	
	cell.feedType=news.feed_type;
	cell.userName=news.name;
	cell.publishDate=[RenRenManager resolveRenRenDate:news.update_time];
	cell.title=news.title;
	cell.introduction=news.description;
	
    //	cell.commentNum=[NSString stringWithFormat:@"评论 %d",[[news.comments objectForKey:@"count"]intValue]];
	[cell resizeViewFrames];
	
	return cell;
}

//实例化照片单元格
-(UITableViewCell*)initCellForPhotoWithIndexPath:(NSIndexPath*)indexPath
                                  withRenRenNews:(RenRenNews*)news
                                    forTableView:(UITableView*)tableView{
    static NSString *identifierForPhoto=@"newsCellIdentifierForPhoto";
    
	RenRenNewsTableViewCellForPhoto *cell=(RenRenNewsTableViewCellForPhoto *)[tableView dequeueReusableCellWithIdentifier:identifierForPhoto];
    [cell retain];
	if (cell==nil) {
		cell=[[RenRenNewsTableViewCellForPhoto alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierForPhoto];
        [cell retain];
	}
    
    cell.showImgDelegate=self;
    
    //原始图片地址
    cell.imgUrl=((RenRenAttachment*)[news.attachment objectAtIndex:0]).raw_src;
    
    if (!news.headImg) {
		cell.headImage=[UIImage imageNamed:@"placeholder.png"];
		if (self.newsTableView.dragging==NO&&self.newsTableView.decelerating==NO) {
            [self startIconDownload:news.headurl forIndexPath:indexPath];
		}
	}else {
		cell.headImage=news.headImg;
	}
    
    cell.feedType=news.feed_type;
    cell.userName=news.name;
    cell.publishDate=[RenRenManager resolveRenRenDate:news.update_time];
    
    cell.desc=((RenRenAttachment*)[news.attachment objectAtIndex:0]).content;
    cell.albumName=news.title;
    
    NSString *comeFrom=(news.source&&news.source.text&&[news.source.text isNotEqualToString:@""])?news.source.text:@"网页";  
    cell.comeFrom=[NSString stringWithFormat:@"通过%@发布",comeFrom];
    
    //下载照片
    if (!news.photoImg) {
		[cell.photoImgView setImageWithURL:[NSURL URLWithString:((RenRenAttachment*)[news.attachment objectAtIndex:0]).raw_src]
                          placeholderImage:[UIImage imageNamed:@"smallImagePlaceHolder.png"] 
                                   success:^(UIImage *image, BOOL cached) {
                                       if (cached) {
                                           NSLog(@"cached");
                                       }else {
                                           NSLog(@"unCached");
                                       }
                                       CGSize itemSize=CGSizeMake(SMALL_PHOTO_WIDTH*2, SMALL_PHOTO_HEIGHT*2);
                                       news.photoImg=[GlobalInstance thumbnailWithImageWithoutScale:image size:itemSize];
                                       cell.photoImg=news.photoImg;   
                                   } 
                                   failure:^(NSError *error) {
                                       
                                   }];
    }else {
        cell.photoImg=news.photoImg;
    }
    
	[cell resizeViewFrames];
	return cell;
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
                                                     0.0f-self.newsTableView.bounds.size.height,
                                                     self.view.frame.size.width,
                                                     self.newsTableView.bounds.size.height)];
		_refreshHeaderView.delegate=self;
		[self.newsTableView addSubview:_refreshHeaderView];
	}
	
	//设置上提载入更多视图
	if (_loadMoreFooterView==nil) {
		_loadMoreFooterView=[[LoadMoreTableFooterView alloc]
                             initWithFrame:CGRectMake(0.0f, 
                                                      self.newsTableView.contentSize.height,
                                                      self.newsTableView.frame.size.width,
                                                      self.newsTableView.bounds.size.height)];
		
		_loadMoreFooterView.delegate=self;
		[self.newsTableView addSubview:_loadMoreFooterView];
	}
    
}

#pragma mark - Bind check notification handle -
-(BOOL)checkBindInfo{
    return [RenRenManager isBoundToApplication];
}

- (void)handleBindNotification:(BOOL)isBound{
    //如果已綁定并且是首次加载
    if (isBound) {                                  //如果已綁定
        if (self.newsList==nil) {                   //并且是首次加载 
            if (![AppConfig(@"renren_main_tip_hasShown") boolValue]) {
                _tipBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                _tipBtn.frame=CGRectMake(0, 0, WINDOWWIDTH, WINDOWHEIGHT);
                [_tipBtn setBackgroundImage:[UIImage imageNamed:@"renren_tip.png"] forState:UIControlStateNormal];
                [_tipBtn addTarget:self action:@selector(tipButton_touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
                
                [[UIApplication sharedApplication].keyWindow addSubview:_tipBtn];
                [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_tipBtn];
            }
            [self loadNewsInfoList];                //加载新鲜事列表
            loadtype=firstLoad;                     //設置加載類型為首次加載
        }
    }else {
        self.newsTableView.hidden=YES;
        self.newsList=nil;
    }
}

#pragma mark - WeiboImageDelegate -
- (void)showWeiboImage:(id)sender{
    RenRenNewsTableViewCellForPhoto *cell=[self cellForImageView:sender];
	if (cell) {
        NSString *imgUrl=cell.imgUrl;
        [self showImage:imgUrl];
    }
}

- (void)showImage:(NSString*)imgUrl{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imgUrl]]];
    
    self.photoArray = photos;
	
	// Create browser
	MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    
    UINavigationController *navCtrller = [[UINavigationController alloc] initWithRootViewController:browser];
    navCtrller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:navCtrller animated:YES];
    [navCtrller release];
    
    // Release
	[browser release];
	[photos release];
}

/*
 *根据被点击的按钮找到其所在的单元格
 */
- (RenRenNewsTableViewCellForPhoto*)cellForImageView:(id)clickedImgView{
	NSArray *visiblePaths=[self.newsTableView indexPathsForVisibleRows];
	for(NSIndexPath *item in visiblePaths){
        RenRenNews *renrenNews=(RenRenNews*)[self.newsList objectAtIndex:item.row];
        if ([renrenNews.feed_type intValue]==30||[renrenNews.feed_type intValue]==31||[renrenNews.feed_type intValue]==32||[renrenNews.feed_type intValue]==36) {
            RenRenNewsTableViewCellForPhoto *currentCell=(RenRenNewsTableViewCellForPhoto*)[self.newsTableView cellForRowAtIndexPath:item];
            if(currentCell.photoImgView==clickedImgView){
                return currentCell;
            }
        }
	}
	return nil;
}

#pragma mark - MWPhotoBrowserDelegate -
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photoArray.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser
             photoAtIndex:(NSUInteger)index {
    if (index < self.photoArray.count)
        return [self.photoArray objectAtIndex:index];
    return nil;
}

#pragma mark - 手势处理 -
/*
 *注册手势
 */
- (void)registerGestureOperation{
	UISwipeGestureRecognizer *recognizer; 
    
	recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];			//右滑(转发)
    [self.newsTableView addGestureRecognizer:recognizer];
	[recognizer release];
	
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];			//左滑评论
    [self.newsTableView addGestureRecognizer:recognizer];
	[recognizer release];
}

/*
 *手势处理逻辑
 */
- (void)handleGesture:(UISwipeGestureRecognizer*)gestureRecognizer{
	CGPoint tapPoint = [gestureRecognizer locationInView:self.newsTableView];
	NSIndexPath *indexPath = [self.newsTableView indexPathForRowAtPoint:tapPoint];
	if (indexPath == nil){
		return ;
	}
	else{
		//获取当前单元格
		RenRenNews *news=(RenRenNews*)[self.newsList objectAtIndex:indexPath.row];
        
        //左滑(评论)
        if(gestureRecognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
            [self doCommentOrRepublishActionForWeibo:news operateType:YES];
        }
        
        //右滑(分享)
        if(gestureRecognizer.direction==UISwipeGestureRecognizerDirectionRight) {
            [self doCommentOrRepublishActionForWeibo:news operateType:NO];
        }
	}
}

/*
 *评论/转发(分享)的实现
 */
- (void)doCommentOrRepublishActionForWeibo:(RenRenNews*)currentNews
                               operateType:(operateType)_operateType{
    //传递参数
	NSMutableDictionary *commentParams=[[NSMutableDictionary alloc]init];
    RenRenRePublishOrCommentController *RandCCtrller;
    [commentParams setObject:currentNews.feed_type forKey:@"feedType"];
    [commentParams setObject:currentNews.source_id forKey:@"theSubjectId"];
    [commentParams setObject:currentNews.actor_id forKey:@"ownerId"];
    [commentParams setObject:@"" forKey:@"rid"];
    
    switch (_operateType) {
        case republish:
            if ([currentNews.feed_type intValue]==10||[currentNews.feed_type intValue]==11) {                           //转发状态
                [commentParams setObject:[NSString stringWithFormat:@"转发%@的状态",currentNews.name] forKey:@"showTitle"];
                [commentParams setObject:@"0" forKey:@"commentType"];					
                [commentParams setObject:[NSString stringWithFormat:@"转自%@:%@",currentNews.name,currentNews.message] forKey:@"sourceContent"];
            }else if([currentNews.feed_type intValue]==20||[currentNews.feed_type intValue]==22){                 //分享(发表的日志)
                [commentParams setObject:[NSString stringWithFormat:@"分享%@的日志",currentNews.name] forKey:@"showTitle"];
                [commentParams setObject:@"0" forKey:@"commentType"];			
                [commentParams setObject:@"" forKey:@"sourceContent"];
            }else if([currentNews.feed_type intValue]==21||[currentNews.feed_type intValue]==23){               //分享(分享的日志)
                [commentParams setObject:[NSString stringWithFormat:@"分享%@的日志",currentNews.name] forKey:@"showTitle"];
                [commentParams setObject:@"0" forKey:@"commentType"];
                [commentParams setObject:@"" forKey:@"sourceContent"];
            }else if([currentNews.feed_type intValue]==30||[currentNews.feed_type intValue]==31){               //分享(上传的照片)
                [commentParams setObject:[NSString stringWithFormat:@"分享%@的照片",currentNews.name] forKey:@"showTitle"];
                [commentParams setObject:@"0" forKey:@"commentType"];			
                [commentParams setObject:@"" forKey:@"sourceContent"];
                [commentParams setObject:((RenRenAttachment*)[currentNews.attachment objectAtIndex:0]).media_id forKey:@"theSubjectId"];
            }else if([currentNews.feed_type intValue]==32||[currentNews.feed_type intValue]==36){               //分享(分享的照片)
                [commentParams setObject:[NSString stringWithFormat:@"分享%@的照片",currentNews.name] forKey:@"showTitle"];
                [commentParams setObject:@"0" forKey:@"commentType"];			
                [commentParams setObject:@"" forKey:@"sourceContent"];
            }
            break;
            
        case comment:
            [commentParams setObject:[NSString stringWithFormat:@"评论给%@",currentNews.name] forKey:@"showTitle"];
            [commentParams setObject:@"0" forKey:@"commentType"];				
            [commentParams setObject:@"" forKey:@"sourceContent"];
            if ([currentNews.feed_type intValue]==20||[currentNews.feed_type intValue]==22) {
                [commentParams setObject:currentNews.source_id forKey:@"theSubjectId"];
                [commentParams setObject:currentNews.actor_id forKey:@"ownerId"];
            }else if([currentNews.feed_type intValue]==21||[currentNews.feed_type intValue]==23){
                [commentParams setObject:((RenRenAttachment*)[currentNews.attachment objectAtIndex:0]).media_id forKey:@"theSubjectId"];
                [commentParams setObject:((RenRenAttachment*)[currentNews.attachment objectAtIndex:0]).owner_id forKey:@"ownerId"];
            }else if([currentNews.feed_type intValue]==30||[currentNews.feed_type intValue]==31){
                [commentParams setObject:currentNews.actor_id forKey:@"ownerId"];
                [commentParams setObject:((RenRenAttachment*)[currentNews.attachment objectAtIndex:0]).media_id forKey:@"theSubjectId"];
            }else if([currentNews.feed_type intValue]==32||[currentNews.feed_type intValue]==36){
                [commentParams setObject:((RenRenAttachment*)[currentNews.attachment objectAtIndex:0]).media_id forKey:@"theSubjectId"];
                [commentParams setObject:((RenRenAttachment*)[currentNews.attachment objectAtIndex:0]).owner_id forKey:@"ownerId"];
            }
            break;
            
        default:
            break;
    }
	
    RandCCtrller=[[RenRenRePublishOrCommentController alloc]initWithNibName:@"RenRenRePublishOrCommentView" bundle:nil operateType:_operateType comeInParam:commentParams];
	[commentParams release];
    
    UINavigationController *randcNavCtrller=[[UINavigationController alloc]initWithRootViewController:RandCCtrller];
    [RandCCtrller release];
    randcNavCtrller.modalTransitionStyle=UIModalTransitionStyleCoverVertical;    
	
	//弹出模式视图
    [self presentModalViewController:randcNavCtrller animated:YES];
    [randcNavCtrller release];
}

@end
