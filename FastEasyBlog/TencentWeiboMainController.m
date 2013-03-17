//
//  TencentWeiboController.m
//  FastEasyBlog
//
//  Created by svp on 24.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "TencentWeiboMainController.h"
#import "OpenApi.h"
#import "WeiboCell.h"
#import "TencentWeiboInfo.h"

#import "TencentWeiboManager.h"
#import "TencentWeiboSwitchController.h"
#import "MBProgressHUD.h"
#import "Global.h"
#import "ExtensionMethods.h"
#import "TencentWeiboRePublishOrCommentController.h"


#define TABLE_HEADER_HEIGHT 50.0f
#define TABLE_FOOTER_HEIGHT 20.0f
#define CELL_CONTENT_WIDTH 245.0f
#define CELL_CONTENT_MARGIN 0.0f
#define CELL_CONTENT_SOURCE_MARGIN 3.0f
#define DEFAULT_CONSTRAINT_SIZE \
CGSizeMake(CELL_CONTENT_WIDTH-(CELL_CONTENT_MARGIN*2),20000.f)
#define IMAGE_MARGIN 3.0f

@interface TencentWeiboMainController()

@property (nonatomic,retain) NSArray* groupOptions;
@property (nonatomic,retain) UIButton *tipBtn;

@end

@implementation TencentWeiboMainController

@synthesize groupOptions=_groupOptions;
@synthesize tipBtn=_tipBtn;

- (void)dealloc {
    [_groupOptions release],_groupOptions=nil;
    [super dealloc];
}

- (id)initWithRefreshHeaderViewEnabled:(BOOL)enableRefreshHeaderView
          andLoadMoreFooterViewEnabled:(BOOL)enableLoadMoreFooterView{
    self = [super initWithRefreshHeaderViewEnabled:enableRefreshHeaderView
                      andLoadMoreFooterViewEnabled:enableLoadMoreFooterView];
    if (self) {
        
        if (![AppConfig(@"tencentWeibo_main_tip_hasShown") boolValue]) {
            _tipBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            _tipBtn.frame=CGRectMake(0, 0, WINDOWWIDTH, WINDOWHEIGHT);
            [_tipBtn setBackgroundImage:[UIImage imageNamed:@"tencentWeibo_tip.png"] forState:UIControlStateNormal];
            [_tipBtn addTarget:self action:@selector(tipButton_touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        }
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
        
        if (![AppConfig(@"tencentWeibo_main_tip_hasShown") boolValue]) {
            _tipBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            _tipBtn.frame=CGRectMake(0, 0, WINDOWWIDTH, WINDOWHEIGHT);
            [_tipBtn setBackgroundImage:[UIImage imageNamed:@"tencentWeibo_tip.png"] forState:UIControlStateNormal];
            [_tipBtn addTarget:self action:@selector(tipButton_touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    super.bindCheckHandleDelegate=self;
    
    [self initBlocks];
    
    [self.tableView reloadData];
    self.tableView.hidden=YES;
    
    self.navigationItem.title=@"腾讯微博";
    self.navigationController.delegate=self;
    
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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*
 *加载微博列表
 */
-(void)loadWeiboList{
    [super loadWeiboList];
    
    OpenApi *myApi=[TencentWeiboManager getOpenApi];
    myApi.delegate=self;
    if (self.pageFlag==0) {
        [myApi getMyHomeTimeLineWithPageFlag:
         [NSString stringWithFormat:@"%ld",self.pageFlag] 
                                    pageTime:[NSString stringWithFormat:@"%ld",self.pageTime]
                                      reqNum:@"20" 
                                        type:self.weiboType 
                                 contentType:self.contentType];
        
        [GlobalInstance showHUD:@"微博数据加载中,请稍后..." 
                        andView:self.view 
                         andHUD:self.hud];
        
        self.imageDownloadsInProgress=[NSMutableDictionary dictionary];
    }
}

- (void)tipButton_touchUpInside:(id)sender{
    //设置alpha渐变到消失，然后移除
    [UIView animateWithDuration:1 
                     animations:^{
                         self.tipBtn.alpha=0.0;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [[FEBAppConfig sharedAppConfig] setValue:[NSNumber numberWithBool:YES] forKey:@"tencentWeibo_main_tip_hasShown"];
                             [self.tipBtn removeFromSuperview];
                         }
                     }];
}

#pragma mark - private methods -
/*
 *设置导航栏标题
 */
-(void)setNavBarTitle:(NSString*)title{
    ((ClickableLabel*)[self.parentViewController.navigationItem.titleView viewWithTag:NAVIGATIONTITLELBL_TAG]).text=title;
    TencentWeiboSwitchController *switchCtrller=(TencentWeiboSwitchController*)self.parentViewController;
    if (switchCtrller) {
        [switchCtrller.childControllerNavTitlesArr replaceObjectAtIndex:0 withObject:title];
    }
}

- (void)showListView
{
    _groupOptions = [NSArray arrayWithObjects:
                     [NSDictionary dictionaryWithObjectsAndKeys:@"全部微博",@"text",@"0",@"value", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"原创微博",@"text",@"1",@"value", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"转发微博",@"text",@"2",@"value", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"文本微博",@"text",@"0x80",@"value", nil], 
                     [NSDictionary dictionaryWithObjectsAndKeys:@"链接微博",@"text",@"2",@"value", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"图片微博",@"text",@"4",@"value", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"视频微博",@"text",@"8",@"value", nil],
                     nil];
    
    PopListView *popListView = [[ PopListView alloc] initWithTitle:@"分组列表" options:self.groupOptions];
    popListView.delegate = self;
    [popListView showInView:self.parentViewController.navigationController.view animated:YES];
    [popListView release];
}

#pragma mark -  PopListView delegates -
- (void) PopListView:(PopListView *)popListView
    didSelectedIndex:(NSInteger)anIndex
{
    [self setNavBarTitle:[[self.groupOptions objectAtIndex:anIndex] objectForKey:@"text"]];
    UIButton *guideBtn=(UIButton*)[self.parentViewController.navigationItem.titleView viewWithTag:POPVIEWGUIDE_TAG];
    [guideBtn setBackgroundImage:[UIImage imageNamed:@"pulldown.png"] forState:UIControlStateNormal];
    if ([[self.groupOptions objectAtIndex:anIndex] objectForKey:@"text"]==@"全部微博") {
        self.contentType=@"0";
        self.weiboType=@"0";
    }else if([[self.groupOptions objectAtIndex:anIndex] objectForKey:@"text"]==@"原创微博"){
        self.contentType=@"0";
        self.weiboType=@"1";
    }else if([[self.groupOptions objectAtIndex:anIndex] objectForKey:@"text"]==@"转发微博"){
        self.contentType=@"0";
        self.weiboType=@"2";
    }else {
        self.contentType=[[self.groupOptions objectAtIndex:anIndex] objectForKey:@"value"];
        self.weiboType=@"0";
    }
    
    self.pageFlag=0;
    self.pageTime=0;
    [self loadWeiboList];
}

- (void) PopListViewDidCancel
{
    UIButton *guideBtn=(UIButton*)[self.parentViewController.navigationItem.titleView viewWithTag:POPVIEWGUIDE_TAG];
    [guideBtn setBackgroundImage:[UIImage imageNamed:@"pulldown.png"] forState:UIControlStateNormal];
}

#pragma mark - Click Event Delegate -
-(void)doClickAtTarget:(ClickableLabel *)label{
    UIButton *guideBtn=(UIButton*)[self.parentViewController.navigationItem.titleView viewWithTag:POPVIEWGUIDE_TAG];
    [guideBtn setBackgroundImage:[UIImage imageNamed:@"popup.png"] forState:UIControlStateNormal];
	[self showListView];
}

#pragma mark - tencentweibo delegate -
-(void)tencentWeiboRequestDidReturnResponse:(TencentWeiboList *)result{
    
    switch (self.pageFlag) {
        case 0:
            self.dataSource=result.list;
            break;
            
        case 1:
            //加载更多
            if ([result.list count]!=0) {
                NSMutableArray *newsList=[[[NSMutableArray alloc]initWithArray:self.dataSource copyItems:NO]autorelease];
                [newsList addObjectsFromArray:result.list];
                self.dataSource=newsList;
            }
            break;
            
        case 2:
            //刷新
            if ([result.list count]!=0) {
                NSMutableArray *newList=[[[NSMutableArray alloc]initWithArray:result.list copyItems:NO]autorelease];
                [newList addObjectsFromArray:self.dataSource];
                self.dataSource=newList;
            }
            break;
            
        default:
            break;
    }
    
    //关闭加载指示器
    [GlobalInstance hideHUD:self.hud];
    self.tableView.hidden=NO;
	[self.tableView reloadData];
}

-(void)tencentWeiboRequestFailWithError{
    [GlobalInstance hideHUD:self.hud];
    [GlobalInstance showMessageBoxWithMessage:@"数据加载失败"];
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
            [self loadWeiboList];
        }
    }else {
        self.tableView.hidden=YES;
        self.dataSource=nil;
    }
}

#pragma mark - override super's method -
- (void)initBlocks{
    [super initBlocks];
    
    __block TencentWeiboMainController *blockedSelf=self;
    
    //load more
    self.loadMoreDataSourceFunc=^{
        blockedSelf.pageFlag=1;
        blockedSelf.pageTime=self.lastItemTimeStamp;
        
        [self loadWeiboList];
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
        
        [blockedSelf loadWeiboList];
        blockedSelf.reloading=YES;
    };
    
    //refresh completed
    self.refreshDataSourceCompleted=^{
        blockedSelf.reloading=NO;
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    };
    
//    self.cellForRowAtIndexPathDelegate=^(UITableView *tableView, NSIndexPath *indexPath){
//        TencentWeiboInfo *currentWeiboInfo=[self.dataSource objectAtIndex:indexPath.row];
//        WeiboCell *cell=nil;
//        
//        //判断是否有图片
//        BOOL hasWeiboImg=([currentWeiboInfo.image isKindOfClass:[NSArray class]]&&currentWeiboInfo.image.count>0);
//        BOOL hasSourceImg=([currentWeiboInfo.source.image isKindOfClass:[NSArray class]]&&(currentWeiboInfo.source.image.count>0));
//        
//        if (currentWeiboInfo.type==1&&(hasWeiboImg==NO)) {
//            static NSString *cellIdentifier=@"tencentWeiboCellIdentifier";
//            cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//            if (!cell) {
//                cell=[[[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
//            }
//        }else if(currentWeiboInfo.type==1&&(hasWeiboImg==YES)){
//            static NSString *cellIdentifierWithImg=@"tencentWeiboCellIdentifierWithImg";
//            cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifierWithImg];
//            if (!cell) {
//                cell=[[[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierWithImg]autorelease];
//            }
//            cell.imgUrl=[currentWeiboInfo.image objectAtIndex:0];
//        }
//        else if(currentWeiboInfo.type!=1&&(hasSourceImg==NO)){     //转发
//            static NSString *cellIdentifierForSource=@"tencentWeiboCellIdentifierForSource";
//            cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifierForSource];
//            if (!cell) {
//                cell=[[[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierForSource]autorelease];
//            }
//        }else if(currentWeiboInfo.type!=1&&(hasSourceImg==YES)){
//            static NSString *cellIdentifierForSourceWithImg=@"tencentWeiboCellIdentifierForSourceWithImg";
//            cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifierForSourceWithImg];
//            if (!cell) {
//                cell=[[[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierForSourceWithImg]autorelease];
//            }
//            cell.imgUrl=[currentWeiboInfo.source.image objectAtIndex:0];
//        }
//        cell.showWeiboImgDelegate=self;
//        cell.hasWeiboImg=hasWeiboImg;
//        cell.hasSourceWeiboImg=hasSourceImg;
//        
//        //设置头像
//        if (!currentWeiboInfo.headImg) {
//            cell.headImage=[UIImage imageNamed:@"placeholder.png"];
//            if (self.tableView.dragging==NO&&self.tableView.decelerating==NO) {
//                [self startIconDownload:currentWeiboInfo.head forIndexPath:indexPath];
//            }
//        }else {
//            cell.headImage=currentWeiboInfo.headImg;
//        }
//        
//        cell.userName=currentWeiboInfo.nick;
//        cell.publishDate=[TencentWeiboManager resolveTencentWeiboDate:currentWeiboInfo.timestamp];
//        cell.comeFrom=currentWeiboInfo.from;
//        
//        cell.txtWeibo=currentWeiboInfo.text;
//        if (currentWeiboInfo.type!=1&&currentWeiboInfo.source) {
//            if ([currentWeiboInfo.source.text isNotEqualToString:@""]) {
//                NSString *shortSourceWeiboTxt=currentWeiboInfo.source.text;
//                if (shortSourceWeiboTxt.length>70) {
//                    shortSourceWeiboTxt=[NSString stringWithFormat:@"%@...",[shortSourceWeiboTxt substringToIndex:70]];
//                }
//                
//                NSString *sourceContent=[NSString stringWithFormat:@"%@: %@",currentWeiboInfo.source.nick,shortSourceWeiboTxt];
//                cell.txtSourceWeibo=sourceContent;
//            }
//        }
//        
//        if (hasSourceImg) {             //有图片
//            if (!currentWeiboInfo.sourceImg) {
//                NSString *sourceImgUrl=[NSString stringWithFormat:@"%@/%f",[currentWeiboInfo.source.image objectAtIndex:0],WEIBO_IMAGE_MIDDLE_HEIGHT];
//                [cell.sourceImgView setImageWithURL:[NSURL URLWithString:sourceImgUrl]
//                                   placeholderImage:[UIImage imageNamed:@"smallImagePlaceHolder.png"]
//                                            success:^(UIImage *image, BOOL cached) {
//                                                CGSize itemSize=CGSizeMake(WEIBO_IMAGE_HEIGHT*2, WEIBO_IMAGE_HEIGHT*2);
//                                                currentWeiboInfo.sourceImg=[GlobalInstance thumbnailWithImageWithoutScale:image size:itemSize];
//                                                cell.sourceImg=currentWeiboInfo.sourceImg;
//                                            }
//                                            failure:^(NSError *error) {
//                                                
//                                            }];
//            }else{
//                cell.sourceImg=currentWeiboInfo.sourceImg;
//            }
//        }
//        
//        if (hasWeiboImg) {					//设置原创微博图片
//            if (!currentWeiboInfo.weiboImg) {
//                cell.weiboImg=[UIImage imageNamed:@"smallImagePlaceHolder.png"];
//                NSString *imgUrl=[NSString stringWithFormat:@"%@/%f",[currentWeiboInfo.image objectAtIndex:0],WEIBO_IMAGE_MIDDLE_HEIGHT];
//                [cell.weiboImgView setImageWithURL:[NSURL URLWithString:imgUrl]
//                                  placeholderImage:[UIImage imageNamed:@"smallImagePlaceHolder.png"]
//                                           success:^(UIImage *image, BOOL cached) {
//                                               CGSize itemSize=CGSizeMake(WEIBO_IMAGE_HEIGHT*2, WEIBO_IMAGE_HEIGHT*2);
//                                               currentWeiboInfo.weiboImg=[GlobalInstance thumbnailWithImageWithoutScale:image size:itemSize];
//                                               cell.weiboImg=currentWeiboInfo.weiboImg;
//                                           }
//                                           failure:^(NSError *error) {
//                                               
//                                           }];
//            }else {
//                cell.weiboImg=currentWeiboInfo.weiboImg;
//            }
//        }
//        
//        if (indexPath.row==0) {
//            firstItemTimeStamp=currentWeiboInfo.timestamp;
//        }else if (indexPath.row==[self.dataSource count]-1) {
//            lastItemTimeStamp=currentWeiboInfo.timestamp;
//        }
//        
//        [cell resizeViewFrames];
//        
//        return cell;
//    };
    
    self.heightForRowAtIndexPathDelegate=^(UITableView *tableView, NSIndexPath *indexPath){
        BOOL hasWeiboImg=NO;
        BOOL hasSourceImg=NO;
        CGFloat currentCellContentHeight=0.0f;                   //当前单元格内容高度
        TencentWeiboInfo *currentWeiboInfo=[self.dataSource objectAtIndex:indexPath.row];
        hasWeiboImg=([currentWeiboInfo.image isKindOfClass:[NSArray class]]&&currentWeiboInfo.image.count>0);
        currentCellContentHeight=[GlobalInstance getHeightWithFontText:currentWeiboInfo.text font:WEIBOTEXTFONT constraint:DEFAULT_CONSTRAINT_SIZE minHeight:MIN_CONTENT_HEIGHT]+CELL_CONTENT_SOURCE_MARGIN*2;
        
        if (currentWeiboInfo.type!=1) {
            hasSourceImg=([currentWeiboInfo.source.image isKindOfClass:[NSArray class]]&&(currentWeiboInfo.source.image.count>0));
            if ([currentWeiboInfo.source.text isNotEqualToString:@""]) {
                NSString *shortSourceWeiboTxt=currentWeiboInfo.source.text;
                if (shortSourceWeiboTxt.length>70) {
                    shortSourceWeiboTxt=[NSString stringWithFormat:@"%@...",[shortSourceWeiboTxt substringToIndex:70]];
                }
                
                NSString *sourceContent=[NSString stringWithFormat:@"%@: %@",currentWeiboInfo.source.nick,shortSourceWeiboTxt];
                currentCellContentHeight+=[GlobalInstance getHeightWithFontText:sourceContent font:SOURCEWEIBOTEXTFONT constraint:DEFAULT_CONSTRAINT_SIZE minHeight:MIN_CONTENT_HEIGHT];
                currentCellContentHeight+=CELL_CONTENT_SOURCE_MARGIN*1;
            }
        }
        
        //如果有微博图片
        if (hasWeiboImg||hasSourceImg) {
            return TABLE_HEADER_HEIGHT+currentCellContentHeight+TABLE_FOOTER_HEIGHT+5+WEIBO_IMAGE_HEIGHT+IMAGE_MARGIN;
        }else{
            return TABLE_HEADER_HEIGHT+currentCellContentHeight+TABLE_FOOTER_HEIGHT+5;
        }
    };
    
}

@end
