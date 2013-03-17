//
//  SinaWeiboCommentToMeController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 10/4/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "SinaWeiboCommentToMeController.h"

@interface SinaWeiboCommentToMeController ()

- (void)loadDataSource;

@end

@implementation SinaWeiboCommentToMeController

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

- (void)loadDataSource{
    [super loadDataSource];
    
	NSMutableDictionary *requestParams=[[NSMutableDictionary alloc]init];
    switch (self.loadtype) {
        case firstLoad:             
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.count] 
                              forKey:@"count"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.page] 
                              forKey:@"page"];
            break;
            
        case refresh:             
            [requestParams setObject:self.since_id forKey:@"since_id"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.count] 
                              forKey:@"count"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.page] 
                              forKey:@"page"];
            break;
            
        case loadMore:             
            [requestParams setObject:self.max_id forKey:@"max_id"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.count] 
                              forKey:@"count"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.page] 
                              forKey:@"page"];
            break;
    }
    
    [self.engine loadRequestWithMethodName:@"comments/to_me.json"
                           httpMethod:@"GET"
                               params:requestParams
                         postDataType:kWBRequestPostDataTypeNone
                     httpHeaderFields:nil];
    
    [requestParams release];
    
    [GlobalInstance showHUD:@"微博数据加载中,请稍后..." andView:self.view andHUD:self.hud];
	
	self.imageDownloadsInProgress=[NSMutableDictionary dictionary];
}

#pragma mark - WBEngineDelegate Methods
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
        
        switch (self.loadtype) {
            case firstLoad:             
                self.dataSource=[SinaWeiboManager resolveCommentToMeWeiboDataToArray:[dict objectForKey:@"comments"]];
                break;
                
            case refresh:				
            {        			
                NSMutableArray *newList=[[[NSMutableArray alloc]initWithArray:[SinaWeiboManager resolveCommentToMeWeiboDataToArray:[dict objectForKey:@"comments"]] copyItems:NO]autorelease];
                if ([newList count]!=0) {
                    [newList addObjectsFromArray:self.dataSource];
                    self.dataSource=newList;
                }
            }
                break;
                
            case loadMore:            
            {
                NSMutableArray *newList=[[[NSMutableArray alloc]initWithArray:self.dataSource copyItems:NO]autorelease];
                NSMutableArray *tmpArr=[SinaWeiboManager resolveCommentToMeWeiboDataToArray:[dict objectForKey:@"comments"]];
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
        
        [GlobalInstance hideHUD:self.hud];
    }
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    [GlobalInstance hideHUD:self.hud];
    [GlobalInstance showMessageBoxWithMessage:@"获取数据失败"];
}

- (void)engineAuthorizeExpired:(WBEngine *)engine{
    [GlobalInstance hideHUD:self.hud];
}

- (void)engineNotAuthorized:(WBEngine *)engine{
    [GlobalInstance hideHUD:self.hud];
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
    
    __block SinaWeiboCommentToMeController *blockedSelf=self;
    
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
        [blockedSelf.loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:blockedSelf.tableView];
    };
    
    //refresh
    self.refreshDataSourceFunc=^{
        blockedSelf.loadtype=refresh;
        [blockedSelf loadDataSource];
        blockedSelf.isRefreshing=YES;
    };
    
    //refresh completed
    self.refreshDataSourceCompleted=^{
        blockedSelf.isRefreshing=NO;
        [blockedSelf.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:blockedSelf.tableView];
    };
    
    self.cellForRowAtIndexPathDelegate=^(UITableView *tableView, NSIndexPath *indexPath){
        SinaWeiboInfo *weibo=[blockedSelf.dataSource objectAtIndex:indexPath.row];
        BOOL isRePublish=(weibo.retweeted_status!=nil);
        BOOL hasWeiboImg=[weibo.thumbnail_pic isNotEqualToString:@""];
        BOOL hasSourceImg=[weibo.retweeted_status.thumbnail_pic isNotEqualToString:@""];
        WeiboCell *cell;
        
        if (indexPath.row==0) {
            blockedSelf.since_id=weibo.idstr;
        }else if(indexPath.row+1==[self.dataSource count]){
            blockedSelf.max_id=weibo.idstr;
        }
        
        if (!isRePublish&&!hasWeiboImg) {                   	
            static NSString *WeiboCellIdentifier=@"WeiboCellIdentifier";
            cell=[tableView dequeueReusableCellWithIdentifier:WeiboCellIdentifier];
            if (!cell) {
                cell=[[[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeiboCellIdentifier]autorelease];
            }
        }else if(!isRePublish&&hasWeiboImg){                	
            static NSString *WeiboCellIdentifierWithImg=@"WeiboCellIdentifierWithImg";
            cell=[tableView dequeueReusableCellWithIdentifier:WeiboCellIdentifierWithImg];
            if (!cell) {
                cell=[[[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeiboCellIdentifierWithImg]autorelease];
            }
            cell.imgUrl=weibo.original_pic;
        }else if(isRePublish&&!hasSourceImg){               
            static NSString *WeiboCellIdentifierForSource=@"WeiboCellIdentifierForSource";
            cell=[tableView dequeueReusableCellWithIdentifier:WeiboCellIdentifierForSource];
            if (!cell) {
                cell=[[[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WeiboCellIdentifierForSource]autorelease];
            }
        }else if(isRePublish&&hasSourceImg){                
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
        
        if (!weibo.headImg) {
            cell.headImage=[UIImage imageNamed:@"placeholder.png"];
            if (blockedSelf.tableView.dragging==NO && blockedSelf.tableView.decelerating==NO) {
                [blockedSelf startIconDownload:weibo.user.profile_image_url forIndexPath:indexPath];
            }
        }else {
            cell.headImage=weibo.headImg;
        }
        
        cell.userName=weibo.user.screen_name;
        cell.comeFrom=weibo.source;
        cell.txtWeibo=weibo.text;
        cell.publishDate=[SinaWeiboManager resolveSinaWeiboDate:weibo.created_at];
        
        if (weibo.retweeted_status.text&&[weibo.retweeted_status.text isNotEqualToString:@""]) {
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
        
        CGFloat currentCellContentHeight=0.0f;                   
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
        
        if (hasWeiboImg||hasSourceImg) {
            return TABLE_HEADER_HEIGHT+currentCellContentHeight+TABLE_FOOTER_HEIGHT+5.0f+WEIBO_IMAGE_HEIGHT+IMAGE_MARGIN;
        }else{
            return TABLE_HEADER_HEIGHT+currentCellContentHeight+TABLE_FOOTER_HEIGHT+5;
        } 
    };
    
}

@end
