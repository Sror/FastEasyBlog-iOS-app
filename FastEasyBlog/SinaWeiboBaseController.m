//
//  SinaWeiboBaseController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 11/4/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "SinaWeiboBaseController.h"

@interface SinaWeiboBaseController ()

@end

@implementation SinaWeiboBaseController

- (void)dealloc{
    [_since_id release],_since_id=nil;
    [_max_id release],_max_id=nil;
    
    [_photoArray release],_photoArray=nil;
    _engine.delegate=nil;
    [_engine release],_engine=nil;
    
    [super dealloc];
}


- (id)initWithRefreshHeaderViewEnabled:(BOOL)enableRefreshHeaderView
          andLoadMoreFooterViewEnabled:(BOOL)enableLoadMoreFooterView{
    self=[super initWithRefreshHeaderViewEnabled:enableRefreshHeaderView
                    andLoadMoreFooterViewEnabled:enableRefreshHeaderView];
    if (self) {
        _engine=[[WBEngine alloc]initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
        
        self.loadtype=firstLoad;
        self.since_id=@"0";
        self.max_id=@"0";
        self.count=20;
        self.page=1;
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
    
	recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self 
                                                          action:@selector(handleGesture:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];	//右滑(转发)
    [self.tableView addGestureRecognizer:recognizer];
	[recognizer release];
	
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self 
                                                          action:@selector(handleGesture:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];	//左滑评论
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
		SinaWeiboInfo *weibo=(SinaWeiboInfo*)[self.dataSource objectAtIndex:indexPath.row];
        
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

#pragma mark - 评论/转发(分享)的实现 -
/*
 *评论/转发(分享)的实现
 */
- (void)doCommentOrRepublishActionForWeibo:(SinaWeiboInfo*)currentWeibo
                               operateType:(operateType)_operateType{
    //传递参数
	NSMutableDictionary *commentParams=[[NSMutableDictionary alloc]init];
    SinaWeiboRePublishOrCommentController *RandCCtrller;
    
    switch (_operateType) {
        case republish:
            [commentParams setObject:[NSString stringWithFormat:@"转发%@的微博",currentWeibo.user.screen_name] forKey:@"showTitle"];
            [commentParams setObject:currentWeibo.idstr forKey:@"theSubjectId"];
            [commentParams setObject:[NSString stringWithFormat:@"// @%@ :%@",currentWeibo.user.screen_name,currentWeibo.text] forKey:@"sourceContent"];
            break;
            
        case comment:
            [commentParams setObject:[NSString stringWithFormat:@"评论给%@",currentWeibo.user.screen_name] forKey:@"showTitle"];
            [commentParams setObject:currentWeibo.idstr forKey:@"theSubjectId"];
            [commentParams setObject:@"0" forKey:@"commentType"];				
            [commentParams setObject:@"" forKey:@"sourceContent"];
            break;
            
        case reply:
            
            break;
            
        default:
            break;
    }
	
    RandCCtrller=[[SinaWeiboRePublishOrCommentController alloc]initWithNibName:@"SinaWeiboRePublishOrCommentView" bundle:nil operateType:_operateType comeInParam:commentParams];
	[commentParams release];
    
    UINavigationController *randcNavCtrller=[[UINavigationController alloc]initWithRootViewController:RandCCtrller];
    [RandCCtrller release];
    randcNavCtrller.modalTransitionStyle=UIModalTransitionStyleCoverVertical;    
	
	//弹出模式视图
    [self presentModalViewController:randcNavCtrller animated:YES];
    [randcNavCtrller release];
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


#pragma mark - 加载微博列表 -
/*
 *加载微博列表
 */
-(void)loadDataSource{
    if (![SinaWeiboManager isBoundToApplication]) {
        return;
    }
}

#pragma mark - WeiboImage Delegate -
- (void)showWeiboImage:(id)sender{             //显示微博图片
    WeiboCell *cell=[self cellForImageView:sender];
	if (cell) {
        NSString *weiboImgUrl=cell.imgUrl;
        [self showImage:weiboImgUrl];
    }
}

- (void)showSourceWeiboImage:(id)sender{       //显示原微博图片
	WeiboCell *cell=[self cellForImageView:sender];
    if (cell) {
        NSString *weiboImgUrl=cell.imgUrl;
        [self showImage:weiboImgUrl];
    }
}

- (void)showImage:(NSString*)imgUrl{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:imgUrl]]];
    
    self.photoArray = photos;
	
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
    return [SinaWeiboManager isBoundToApplication];
}

- (void)initBlocks{
    [super initBlocks];
    
    __block SinaWeiboBaseController *blockedSelf=self;
    
    //load more completed
    self.loadMoreDataSourceCompleted=^{
        blockedSelf.isLoadingMore=NO;
        [blockedSelf.loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:
         blockedSelf.tableView];
    };
    
    //refresh completed
    self.refreshDataSourceCompleted=^{
        blockedSelf.isRefreshing=NO;
        [blockedSelf.refreshHeaderView
         egoRefreshScrollViewDataSourceDidFinishedLoading:
         blockedSelf.tableView];
    };
    
    self.loadImagesForVisiableRowsFunc=^(){
        if ([blockedSelf.dataSource count]>0) {
            //取得当前tableview中的可见cell集合
            NSArray *visiblePaths=[blockedSelf.tableView indexPathsForVisibleRows];
            for (NSIndexPath *indexPath in visiblePaths) {
                SinaWeiboInfo *weibo=(SinaWeiboInfo*)[blockedSelf.dataSource objectAtIndex:indexPath.row];
                if (!weibo.headImg) {
                    [blockedSelf startIconDownload:weibo.user.profile_image_url forIndexPath:indexPath];
                }else if(!weibo.weiboImg&&[weibo.thumbnail_pic isNotEqualToString:@""]){      //下载原创微博的图片
                    WeiboCell *cell=(WeiboCell*)[blockedSelf.tableView cellForRowAtIndexPath:indexPath];
                    if (cell) {
                        [cell.weiboImgView setImageWithURL:[NSURL URLWithString:weibo.retweeted_status.thumbnail_pic] 
                                          placeholderImage:[UIImage imageNamed:@"smallImagePlaceHolder.png"]  
                                                   success:^(UIImage *image, BOOL cached) {
                                                       CGSize itemSize=CGSizeMake(WEIBO_IMAGE_HEIGHT*2, WEIBO_IMAGE_HEIGHT*2);
                                                       weibo.weiboImg=[GlobalInstance thumbnailWithImageWithoutScale:image size:itemSize];
                                                       cell.weiboImg=weibo.weiboImg; 
                                                   } 
                                                   failure:^(NSError *error) {
                                                       
                                                   }];
                    }
                }else if(!weibo.sourceImg&&weibo.retweeted_status&&[weibo.retweeted_status.thumbnail_pic isNotEqualToString:@""]){                             //下载原微博的图片                
                    WeiboCell *cell=(WeiboCell*)[blockedSelf.tableView cellForRowAtIndexPath:indexPath];
                    if (cell) {
                        [cell.sourceImgView setImageWithURL:[NSURL URLWithString:weibo.retweeted_status.thumbnail_pic] 
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
    self.appImageDownloadCompleted=^(NSIndexPath *indexPath){
        SinaWeiboInfo *weibo=(SinaWeiboInfo*)[blockedSelf.dataSource objectAtIndex:indexPath.row];
        WeiboCell *cell=(WeiboCell*)[blockedSelf.tableView cellForRowAtIndexPath:indexPath];
        IconDownloader *iconDownloader=nil;
        iconDownloader=[blockedSelf.imageDownloadsInProgress objectForKey:indexPath];
        if (iconDownloader) {
            weibo.headImg=iconDownloader.appIcon;
            cell.headImage=iconDownloader.appIcon;
        }
    };
    
    self.didSelectRowAtIndexPathDelegate=^(UITableView *tableView, NSIndexPath *indexPath){
        SinaWeiboInfo *currentWeiboInfo=[blockedSelf.dataSource objectAtIndex:indexPath.row];
        
        WeiboDetailController *detailController=[[WeiboDetailController alloc]initWithNibName:@"WeiboDetailView" bundle:nil sinaWeiboDetail:currentWeiboInfo];
        
        [blockedSelf.navigationController pushViewController:detailController
                                                    animated:YES];
        [detailController release];
    };
    
    self.cellForRowAtIndexPathDelegate=^(UITableView *tableView, NSIndexPath *indexPath){
        SinaWeiboInfo *weibo=[blockedSelf.dataSource objectAtIndex:indexPath.row];
        BOOL isRePublish=(weibo.retweeted_status!=nil);
        BOOL hasWeiboImg=[weibo.thumbnail_pic isNotEqualToString:@""];
        BOOL hasSourceImg=[weibo.retweeted_status.thumbnail_pic isNotEqualToString:@""];
        WeiboCell *cell;
        
        //记录第一条和最后一条
        if (indexPath.row==0) {
            blockedSelf.since_id=weibo.idstr;
        }else if(indexPath.row+1==[blockedSelf.dataSource count]){
            blockedSelf.max_id=weibo.idstr;
        }
        
        if (!isRePublish&&!hasWeiboImg) {                   	//原創無圖片
            static NSString *WeiboCellIdentifier=@"WeiboCellIdentifier";
            cell=[tableView dequeueReusableCellWithIdentifier:WeiboCellIdentifier];
            if (!cell) {
                cell=[[[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeiboCellIdentifier]autorelease];
            }
        }else if(!isRePublish&&hasWeiboImg){                	//原創有圖片
            static NSString *WeiboCellIdentifierWithImg=@"WeiboCellIdentifierWithImg";
            cell=[tableView dequeueReusableCellWithIdentifier:WeiboCellIdentifierWithImg];
            if (!cell) {
                cell=[[[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeiboCellIdentifierWithImg]autorelease];
            }
            cell.imgUrl=weibo.original_pic;
        }else if(isRePublish&&!hasSourceImg){               //帶原圍脖無圖片
            static NSString *WeiboCellIdentifierForSource=@"WeiboCellIdentifierForSource";
            cell=[tableView dequeueReusableCellWithIdentifier:WeiboCellIdentifierForSource];
            if (!cell) {
                cell=[[[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeiboCellIdentifierForSource]autorelease];
            }
        }else if(isRePublish&&hasSourceImg){                //帶原圍脖有圖片
            static NSString *WeiboCellIdentifierForSourceWithImg=@"WeiboCellIdentifierForSourceWithImg";
            cell=[tableView dequeueReusableCellWithIdentifier:WeiboCellIdentifierForSourceWithImg];
            if (!cell) {
                cell=[[[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeiboCellIdentifierForSourceWithImg]autorelease];
            }
            cell.imgUrl=weibo.retweeted_status.original_pic;
        }
        
        cell.hasWeiboImg=hasWeiboImg;
        cell.hasSourceWeiboImg=hasSourceImg;
        cell.showWeiboImgDelegate=self;
        
        //设置头像
        if (!weibo.headImg) {
            cell.headImage=[UIImage imageNamed:@"placeholder.png"];
            if (blockedSelf.tableView.dragging==NO&&blockedSelf.tableView.decelerating==NO) {
                [blockedSelf startIconDownload:weibo.user.profile_image_url forIndexPath:indexPath];
            }
        }else {
            cell.headImage=weibo.headImg;
        }
        
        cell.userName=weibo.user.screen_name;
        cell.comeFrom=weibo.source;
        cell.txtWeibo=weibo.text;
        cell.publishDate=[SinaWeiboManager resolveSinaWeiboDate:weibo.created_at];
        
        if (weibo.retweeted_status.text&&
            [weibo.retweeted_status.text isNotEqualToString:@""]) {
            NSString *shortSourceWeiboTxt=weibo.retweeted_status.text;
            if (shortSourceWeiboTxt.length>70) {
                shortSourceWeiboTxt=[NSString stringWithFormat:@"%@...",[shortSourceWeiboTxt substringToIndex:70]];
            }
            NSString *sourceContent=[NSString stringWithFormat:@"%@: %@",weibo.retweeted_status.user.screen_name,shortSourceWeiboTxt];
            cell.txtSourceWeibo=sourceContent;
        }
        
        if (hasSourceImg) {
            if (!weibo.sourceImg) {
                cell.sourceImg=[UIImage imageNamed:@"smallImagePlaceHolder.png"];
                NSString *sourceImgUrl=weibo.retweeted_status.thumbnail_pic;
                
                [cell.sourceImgView setImageWithURL:[NSURL URLWithString:sourceImgUrl]
                                   placeholderImage:[UIImage imageNamed:@"smallImagePlaceHolder.png"]
                                            success:^(UIImage *image, BOOL cached) {
                                                CGSize itemSize=CGSizeMake(WEIBO_IMAGE_HEIGHT*2, WEIBO_IMAGE_HEIGHT*2);
                                                weibo.sourceImg=[GlobalInstance thumbnailWithImageWithoutScale:image size:itemSize];
                                                cell.sourceImg=weibo.sourceImg;
                                            }
                                            failure:^(NSError *error) {
                                                
                                            }];
                
            }else{
                cell.sourceImg=weibo.sourceImg;
            }
        }
        
        if (hasWeiboImg) {
            if (!weibo.weiboImg) {
                [cell.weiboImgView setImageWithURL:[NSURL URLWithString:weibo.thumbnail_pic]
                                  placeholderImage:[UIImage imageNamed:@"smallImagePlaceHolder.png"]
                                           success:^(UIImage *image, BOOL cached) {
                                               CGSize itemSize=CGSizeMake(WEIBO_IMAGE_HEIGHT*2, WEIBO_IMAGE_HEIGHT*2);
                                               weibo.weiboImg=[GlobalInstance thumbnailWithImageWithoutScale:image size:itemSize];
                                               cell.weiboImg=weibo.weiboImg;
                                           }
                                           failure:^(NSError *error) {
                                               
                                           }];
            }else {
                cell.weiboImg=weibo.weiboImg;
            }
        }
        
        [cell resizeViewFrames];
        return cell;
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
