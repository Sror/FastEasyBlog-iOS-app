//
//  TencentWeiboBaseController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "TencentWeiboBaseController.h"
#import "WeiboDetailController.h"

@interface TencentWeiboBaseController ()

//评论/转发(分享)的实现
- (void)doCommentOrRepublishActionForWeibo:(TencentWeiboInfo*)currentWeibo
                               operateType:(operateType)_operateType;


@end

@implementation TencentWeiboBaseController

@synthesize photoArray=_photoArray;
@synthesize imageDownloadsInProgress=_imageDownloadsInProgress;

@synthesize point;
@synthesize reloading;
@synthesize reloading1;
@synthesize pageFlag;
@synthesize pageTime;
@synthesize contentType=_contentType;
@synthesize weiboType=_weiboType;

@synthesize firstItemTimeStamp;
@synthesize lastItemTimeStamp;

- (void)dealloc{
    [_photoArray release],_photoArray=nil;
    [_imageDownloadsInProgress release],_imageDownloadsInProgress=nil;
    
    [_contentType release],_contentType=nil;
    [_weiboType release],_weiboType=nil;
    
    [super dealloc];
}

- (id)initWithRefreshHeaderViewEnabled:(BOOL)enableRefreshHeaderView
          andLoadMoreFooterViewEnabled:(BOOL)enableLoadMoreFooterView{
    self=[super initWithRefreshHeaderViewEnabled:enableRefreshHeaderView
                    andLoadMoreFooterViewEnabled:enableRefreshHeaderView];
    if (self) {
        self.pageFlag=0;
        self.pageTime=0;
        self.contentType=@"0";
        self.weiboType=@"0";
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
    self.view.frame=CGRectMake(0, 0, WINDOWWIDTH, 436);
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

#pragma mark - 手势处理 -
/*
 *注册手势
 */
- (void)registerGestureOperation{
	UISwipeGestureRecognizer *recognizer; 
    
	recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];	//右滑(转发)
    [self.tableView addGestureRecognizer:recognizer];
	[recognizer release];
	
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];	//左滑(评论)
    [self.tableView addGestureRecognizer:recognizer];
	[recognizer release];
}

/*
 *手势处理逻辑
 */
- (void)handleGesture:(UISwipeGestureRecognizer*)gestureRecognizer{
	CGPoint tapPoint = [gestureRecognizer locationInView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tapPoint];
	if (indexPath == nil){
		return ;
	}
	else{
		//获取当前单元格
		TencentWeiboInfo *weibo=(TencentWeiboInfo*)[self.dataSource objectAtIndex:indexPath.row];
        
        //左滑(评论)
        if(gestureRecognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
            [self doCommentOrRepublishActionForWeibo:weibo operateType:comment];
        }
        
        //右滑(分享)
        if(gestureRecognizer.direction==UISwipeGestureRecognizerDirectionRight) {
            [self doCommentOrRepublishActionForWeibo:weibo operateType:republish];
        }
	}
}

/*
 *评论/转发(分享)的实现
 */
- (void)doCommentOrRepublishActionForWeibo:(TencentWeiboInfo*)currentWeibo
                               operateType:(operateType)_operateType{
    //传递参数
	NSMutableDictionary *commentParams=[[NSMutableDictionary alloc]init];
    TencentWeiboRePublishOrCommentController *RandCCtrller;
    
    switch (_operateType) {
        case republish:
            [commentParams setObject:currentWeibo.uniqueId forKey:@"theSubjectId"];
            [commentParams setObject:[NSString stringWithFormat:@"转发%@的微博",currentWeibo.nick] forKey:@"showTitle"];
            [commentParams setObject:[NSString stringWithFormat:@"// @%@ :%@",currentWeibo.nick,currentWeibo.text] forKey:@"sourceContent"];
            break;
            
        case comment:
            [commentParams setObject:currentWeibo.uniqueId forKey:@"theSubjectId"];
            [commentParams setObject:[NSString stringWithFormat:@"评论给%@",currentWeibo.nick] forKey:@"showTitle"];
            [commentParams setObject:@"" forKey:@"sourceContent"];
            break;
            
        case reply:
            
            break;
    }
	
    RandCCtrller=[[TencentWeiboRePublishOrCommentController alloc]initWithNibName:@"TencentWeiboRePublishOrCommentView" bundle:nil operateType:_operateType comeInParam:commentParams];
	[commentParams release];
    
    UINavigationController *randcNavCtrller=[[UINavigationController alloc]initWithRootViewController:RandCCtrller];
    [RandCCtrller release];
    randcNavCtrller.modalTransitionStyle=UIModalTransitionStyleCoverVertical;    
	
	//弹出模式视图
    [self presentModalViewController:randcNavCtrller animated:YES];
    [randcNavCtrller release];
}

#pragma mark - 加载微博列表 -
/*
 *加载微博列表
 */
-(void)loadWeiboList{
    if (![TencentWeiboManager isBoundToApplication]) {
        return;
    }
}

#pragma mark - about head image -
- (void)startIconDownload:(NSString*)headurl
             forIndexPath:(NSIndexPath *)indexPath{
    IconDownloader *headImgDownLoader=
    [self.imageDownloadsInProgress objectForKey:indexPath];
    
    if (!headImgDownLoader) {
        headImgDownLoader=[[IconDownloader alloc]init];
        headImgDownLoader.imgUrl=headurl;
        headImgDownLoader.imgHeight=40.0f;
        headImgDownLoader.imgWidth=40.0f;
        headImgDownLoader.indexPathInTableView=indexPath;
        headImgDownLoader.delegate=self;
        [self.imageDownloadsInProgress setObject:headImgDownLoader
                                          forKey:indexPath];
        [headImgDownLoader startDownload];
        [headImgDownLoader release];
    }
}

#pragma mark - WeiboImageDelegate -
- (void)showWeiboImage:(id)sender{             //显示微博图片
	WeiboCell *cell=[self cellForImageView:sender];		//获得单元格(待实现)
    if (cell) {
        NSString *weiboImgUrl=[NSString stringWithFormat:@"%@/%d",cell.imgUrl,WEIBO_IMAGE_BIG];
        
        [self showImage:weiboImgUrl];
    }
}

- (void)showSourceWeiboImage:(id)sender{       //显示原微博图片
	WeiboCell *cell=[self cellForImageView:sender];		//获得单元格(待实现)
    if (cell) {
        NSString *weiboImgUrl=[NSString stringWithFormat:@"%@/%d",cell.imgUrl,WEIBO_IMAGE_BIG];
        
        [self showImage:weiboImgUrl];
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
- (WeiboCell*)cellForImageView:(id)clickedImgView{
	NSArray *visiblePaths=[self.tableView indexPathsForVisibleRows];
	for(NSIndexPath *item in visiblePaths){
		WeiboCell *currentCell=(WeiboCell*)[self.tableView cellForRowAtIndexPath:item];
		if(currentCell.weiboImgView==clickedImgView||currentCell.sourceImgView==clickedImgView){
			return currentCell;
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

#pragma mark - others -
-(BOOL)checkBindInfo{
    return [TencentWeiboManager isBoundToApplication];
}

- (void)initBlocks{
    [super initBlocks];
    
    __block TencentWeiboBaseController *blockedSelf=self;
    
    blockedSelf.loadImagesForVisiableRowsFunc=^(){
        if ([blockedSelf.dataSource count]>0) {
            //取得当前tableview中的可见cell集合
            NSArray *visiblePaths=[blockedSelf.tableView indexPathsForVisibleRows];
            for (NSIndexPath *indexPath in visiblePaths) {
                TencentWeiboInfo *weibo=(TencentWeiboInfo*)[blockedSelf.dataSource objectAtIndex:indexPath.row];
                if (!weibo.headImg) {
                    [blockedSelf startIconDownload:weibo.head
                                      forIndexPath:indexPath];
                }else if(!weibo.weiboImg&&([weibo.image isKindOfClass:[NSArray class]] &&weibo.image.count>0)){      //下载原创微博的图片
                    NSString *imgUrl=[NSString stringWithFormat:@"%@/%f",[weibo.image objectAtIndex:0],WEIBO_IMAGE_MIDDLE_HEIGHT];
                    
                    WeiboCell *cell=(WeiboCell*)[blockedSelf.tableView cellForRowAtIndexPath:indexPath];
                    if (cell) {
                        [cell.weiboImgView setImageWithURL:[NSURL URLWithString:imgUrl]
                                          placeholderImage:[UIImage imageNamed:@"smallImagePlaceHolder.png"]
                                                   success:^(UIImage *image, BOOL cached) {
                                                       if (cached) {
                                                           NSLog(@"cached");
                                                       }else {
                                                           NSLog(@"unCached");
                                                       }
                                                       CGSize itemSize=CGSizeMake(WEIBO_IMAGE_HEIGHT*2, WEIBO_IMAGE_HEIGHT*2);
                                                       weibo.weiboImg=[GlobalInstance thumbnailWithImageWithoutScale:image size:itemSize];
                                                       cell.weiboImg=weibo.weiboImg;
                                                   }
                                                   failure:^(NSError *error) {
                                                       
                                                   }];
                    }
                    
                }else if(!weibo.sourceImg&&([weibo.source.image isKindOfClass:[NSArray class]]&&(weibo.source.image.count>0))){                             //下载原微博的图片
                    NSString *sourceImgUrl=[NSString stringWithFormat:@"%@/%f",[weibo.source.image objectAtIndex:0],WEIBO_IMAGE_MIDDLE_HEIGHT];
                    
                    WeiboCell *cell=(WeiboCell*)[blockedSelf.tableView cellForRowAtIndexPath:indexPath];
                    if (cell) {
                        [cell.sourceImgView setImageWithURL:[NSURL URLWithString:sourceImgUrl]
                                           placeholderImage:[UIImage imageNamed:@"smallImagePlaceHolder.png"]
                                                    success:^(UIImage *image, BOOL cached) {
                                                        CGSize itemSize=CGSizeMake(WEIBO_IMAGE_HEIGHT*2, WEIBO_IMAGE_HEIGHT*2);
                                                        weibo.sourceImg=[GlobalInstance thumbnailWithImageWithoutScale:image size:itemSize];
                                                        cell.sourceImg=weibo.sourceImg;
                                                    }
                                                    failure:^(NSError *error) {
                                                        
                                                    }];
                    }
                    
                    
                }
            }
        }
    };
    
    //about images
    blockedSelf.appImageDownloadCompleted=^(NSIndexPath *indexPath){
        TencentWeiboInfo *weibo=(TencentWeiboInfo*)[blockedSelf.dataSource objectAtIndex:indexPath.row];
        WeiboCell *cell=(WeiboCell*)[blockedSelf.tableView cellForRowAtIndexPath:indexPath];
        IconDownloader *iconDownloader=nil;
        iconDownloader=[blockedSelf.imageDownloadsInProgress objectForKey:indexPath];
        if (iconDownloader) {
            weibo.headImg=iconDownloader.appIcon;
            cell.headImage=iconDownloader.appIcon;
        }
    };
    
    self.didSelectRowAtIndexPathDelegate=^(UITableView *tableView , NSIndexPath *indexPath){
        TencentWeiboInfo *currentWeiboInfo=[self.dataSource objectAtIndex:indexPath.row];
        
        WeiboDetailController *detailCtrller=[[WeiboDetailController alloc]initWithNibName:@"WeiboDetailView"
                                                                                    bundle:nil
                                                                        tencentWeiboDetail:currentWeiboInfo];
        
        [self.navigationController pushViewController:detailCtrller animated:YES];
        [detailCtrller release];
    };
    
    self.cellForRowAtIndexPathDelegate=^(UITableView *tableView, NSIndexPath *indexPath){
        return [self tableView:tableView cellForRowAtIndexPath:indexPath];
    };
    
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

- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TencentWeiboInfo *currentWeiboInfo=[self.dataSource objectAtIndex:indexPath.row];
    WeiboCell *cell=nil;
    
    //判断是否有图片
    BOOL hasWeiboImg=([currentWeiboInfo.image isKindOfClass:[NSArray class]]&&currentWeiboInfo.image.count>0);
    BOOL hasSourceImg=([currentWeiboInfo.source.image isKindOfClass:[NSArray class]]&&(currentWeiboInfo.source.image.count>0));
    
    if (currentWeiboInfo.type==1&&(hasWeiboImg==NO)) {
        static NSString *cellIdentifier=@"tencentWeiboCellIdentifier";
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell=[[[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
        }
    }else if(currentWeiboInfo.type==1&&(hasWeiboImg==YES)){
        static NSString *cellIdentifierWithImg=@"tencentWeiboCellIdentifierWithImg";
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifierWithImg];
        if (!cell) {
            cell=[[[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierWithImg]autorelease];
        }
        cell.imgUrl=[currentWeiboInfo.image objectAtIndex:0];
    }
    else if(currentWeiboInfo.type!=1&&(hasSourceImg==NO)){     //转发
        static NSString *cellIdentifierForSource=@"tencentWeiboCellIdentifierForSource";
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifierForSource];
        if (!cell) {
            cell=[[[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierForSource]autorelease];
        }
    }else if(currentWeiboInfo.type!=1&&(hasSourceImg==YES)){
        static NSString *cellIdentifierForSourceWithImg=@"tencentWeiboCellIdentifierForSourceWithImg";
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifierForSourceWithImg];
        if (!cell) {
            cell=[[[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierForSourceWithImg]autorelease];
        }
        cell.imgUrl=[currentWeiboInfo.source.image objectAtIndex:0];
    }
    cell.showWeiboImgDelegate=self;
    cell.hasWeiboImg=hasWeiboImg;
    cell.hasSourceWeiboImg=hasSourceImg;
    
    //设置头像
    if (!currentWeiboInfo.headImg) {
        cell.headImage=[UIImage imageNamed:@"placeholder.png"];
        if (self.tableView.dragging==NO&&self.tableView.decelerating==NO) {
            [self startIconDownload:currentWeiboInfo.head forIndexPath:indexPath];
        }
    }else {
        cell.headImage=currentWeiboInfo.headImg;
    }
    
    cell.userName=currentWeiboInfo.nick;
    cell.publishDate=[TencentWeiboManager resolveTencentWeiboDate:currentWeiboInfo.timestamp];
    cell.comeFrom=currentWeiboInfo.from;
    
    cell.txtWeibo=currentWeiboInfo.text;
    if (currentWeiboInfo.type!=1&&currentWeiboInfo.source) {
        if ([currentWeiboInfo.source.text isNotEqualToString:@""]) {
            NSString *shortSourceWeiboTxt=currentWeiboInfo.source.text;
            if (shortSourceWeiboTxt.length>70) {
                shortSourceWeiboTxt=[NSString stringWithFormat:@"%@...",[shortSourceWeiboTxt substringToIndex:70]];
            }
            
            NSString *sourceContent=[NSString stringWithFormat:@"%@: %@",currentWeiboInfo.source.nick,shortSourceWeiboTxt];
            cell.txtSourceWeibo=sourceContent;
        }
    }
    
    if (hasSourceImg) {             //有图片
        if (!currentWeiboInfo.sourceImg) {
            NSString *sourceImgUrl=[NSString stringWithFormat:@"%@/%f",[currentWeiboInfo.source.image objectAtIndex:0],WEIBO_IMAGE_MIDDLE_HEIGHT];
            [cell.sourceImgView setImageWithURL:[NSURL URLWithString:sourceImgUrl]
                               placeholderImage:[UIImage imageNamed:@"smallImagePlaceHolder.png"]
                                        success:^(UIImage *image, BOOL cached) {
                                            CGSize itemSize=CGSizeMake(WEIBO_IMAGE_HEIGHT*2, WEIBO_IMAGE_HEIGHT*2);
                                            currentWeiboInfo.sourceImg=[GlobalInstance thumbnailWithImageWithoutScale:image size:itemSize];
                                            cell.sourceImg=currentWeiboInfo.sourceImg;
                                        }
                                        failure:^(NSError *error) {
                                            
                                        }];
        }else{
            cell.sourceImg=currentWeiboInfo.sourceImg;
        }
    }
    
    if (hasWeiboImg) {					//设置原创微博图片
        if (!currentWeiboInfo.weiboImg) {
            cell.weiboImg=[UIImage imageNamed:@"smallImagePlaceHolder.png"];
            NSString *imgUrl=[NSString stringWithFormat:@"%@/%f",[currentWeiboInfo.image objectAtIndex:0],WEIBO_IMAGE_MIDDLE_HEIGHT];
            [cell.weiboImgView setImageWithURL:[NSURL URLWithString:imgUrl]
                              placeholderImage:[UIImage imageNamed:@"smallImagePlaceHolder.png"]
                                       success:^(UIImage *image, BOOL cached) {
                                           CGSize itemSize=CGSizeMake(WEIBO_IMAGE_HEIGHT*2, WEIBO_IMAGE_HEIGHT*2);
                                           currentWeiboInfo.weiboImg=[GlobalInstance thumbnailWithImageWithoutScale:image size:itemSize];
                                           cell.weiboImg=currentWeiboInfo.weiboImg;
                                       }
                                       failure:^(NSError *error) {
                                           
                                       }];
        }else {
            cell.weiboImg=currentWeiboInfo.weiboImg;
        }
    }
    
    if (indexPath.row==0) {
        firstItemTimeStamp=currentWeiboInfo.timestamp;
    }else if (indexPath.row==[self.dataSource count]-1) {
        lastItemTimeStamp=currentWeiboInfo.timestamp;
    }
    
    [cell resizeViewFrames];
    
    return cell;
}

@end
