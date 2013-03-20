//
//  WeiboDetailController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 10/23/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "WeiboDetailController.h"
#import "ICUTemplateMatcher.h"
#import "SinaWeiboUser.h"
#import "SinaWeiboManager.h"
#import "SinaWeiboRePublishOrCommentController.h"
#import "TencentWeiboManager.h"
#import "TencentWeiboList.h"
#import "TencentWeiboRePublishOrCommentController.h"



#define WEIBO_IMAGE_BIG 460

#define TEMPLATE_PATH [[NSBundle mainBundle] pathForResource:@"weiboDetail" ofType:@"html"]

@interface WeiboDetailController ()

@property (nonatomic,retain) MGTemplateEngine *engine;
@property (nonatomic,retain) SinaWeiboInfo *sinaWeiboDetail;
@property (nonatomic,retain) TencentWeiboInfo *tencentWeiboDetail;
@property (nonatomic,retain) NSString *htmlStr;

@property (nonatomic,retain) NSMutableArray *sinaWeiboDataArr;

@property (nonatomic,retain) NSMutableArray *tencentWeiboDataArr;

@property (nonatomic,retain) WBEngine *engineForRAndCList;
@property (nonatomic,retain) WBEngine *engineForRAndCNum;

@property (nonatomic,assign) loadType loadtypeForRePublish;
@property (nonatomic,assign) loadType loadtypeForComment;
@property (nonatomic,assign) dataType currentDataType;      //comment / republish

//sina weibo
@property (nonatomic,retain) NSString *maxId;
@property (nonatomic,assign) int page;

//tencent weibo 
@property (nonatomic,assign) long lastItemTimeStamp;
@property (nonatomic,retain) NSString *lastItemWeiboId;

@property (nonatomic,retain) NSDictionary *currentSelectedItem;

@end

@implementation WeiboDetailController

@synthesize currentPlatform;
@synthesize sinaWeiboDetail;
@synthesize tencentWeiboDetail;
@synthesize htmlStr;

@synthesize sinaWeiboDataArr;

@synthesize tencentWeiboDataArr;


@synthesize loadtypeForRePublish;
@synthesize loadtypeForComment;
@synthesize currentDataType;

@synthesize page;
@synthesize maxId;

@synthesize lastItemTimeStamp;
@synthesize lastItemWeiboId;

@synthesize currentSelectedItem;

- (void)dealloc{
    [_engine release],_engine=nil;
    _engine.delegate=nil;
    _webView.delegate=nil;
    [_webView release],_webView=nil;
    [sinaWeiboDetail release],sinaWeiboDetail=nil;
    [tencentWeiboDetail release],tencentWeiboDetail=nil;
    [htmlStr release],htmlStr=nil;
    
    [sinaWeiboDataArr release],sinaWeiboDataArr=nil;
    
    [tencentWeiboDataArr release],tencentWeiboDataArr=nil;
    
    [_engineForRAndCList release],_engineForRAndCList=nil;
    _engineForRAndCList.delegate=self;
    
    [_engineForRAndCNum release],_engineForRAndCNum=nil;
    _engineForRAndCNum.delegate=self;
    
    [maxId release],maxId=nil;
    
    [lastItemWeiboId release],lastItemWeiboId=nil;
    
    [currentSelectedItem release],currentSelectedItem=nil;
    
    [super dealloc];
}

#pragma mark - init methods -
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Set up template engine with your chosen matcher.
        _engine = [[MGTemplateEngine templateEngine] retain];
        [self.engine setDelegate:self];
        [self.engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:self.engine]];
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, VIEWCONTENTWIDTH, VIEWCONTENTHEIGHT+44)];
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [GlobalInstance clearWebViewBackground:self.webView];
        self.webView.delegate = self;
        
        _engineForRAndCList=[[WBEngine alloc]initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
        _engineForRAndCList.delegate=self;
        
        _engineForRAndCNum=[[WBEngine alloc]initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
        _engineForRAndCNum.delegate=self;
        
        self.loadtypeForRePublish=firstLoad;
		self.loadtypeForComment=firstLoad;
		
		//other args
        page=1;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
      sinaWeiboDetail:(SinaWeiboInfo*)weiboInfo
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentPlatform=SinaWeibo;
        self.sinaWeiboDetail=[weiboInfo retain];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
   tencentWeiboDetail:(TencentWeiboInfo*)weiboInfo{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentPlatform=TencentWeibo;
        self.tencentWeiboDetail=[weiboInfo retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    super.delegate=self;
    [self.view addSubview:super.toolbar];
    [self.view addSubview:self.webView];
    
    switch (self.currentPlatform) {
        case SinaWeibo:
            self.navigationItem.title=[NSString stringWithFormat:@"%@的微博",self.sinaWeiboDetail.user.screen_name];
            [self initSinaWeiboTmplate];
            break;
            
        case TencentWeibo:
            self.navigationItem.title=[NSString stringWithFormat:@"%@的微博",self.tencentWeiboDetail.nick];
            [self initTencentWeiboTemplate];
            break;
            
        default:
            break;
    }
	
    [GlobalInstance showHUD:@"微博详情加载中,请稍后..." 
                    andView:self.view 
                     andHUD:self.hud];
	// Process the template and display the results.
	self.htmlStr = [self.engine processTemplateInFileAtPath:TEMPLATE_PATH 
                                              withVariables:nil];
	DebugLog(@"Processed template:\r%@", self.htmlStr);
    [self.webView loadHTMLString:self.htmlStr 
                         baseURL:[[NSBundle mainBundle]bundleURL]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.webView stopLoading];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - init template -
- (void)initSinaWeiboTmplate{
    //weibo
    [self.engine setObject:self.sinaWeiboDetail.user.profile_image_url forKey:@"weibo_headImgUrl"];
    [self.engine setObject:self.sinaWeiboDetail.user.screen_name forKey:@"weibo_userName"];
    
    if (!self.sinaWeiboDetail.text) {
        self.sinaWeiboDetail.text=@"";
    }
    [self.engine setObject:[self.sinaWeiboDetail.text handleForShowing] forKey:@"weibo_text"];
    
    if (self.sinaWeiboDetail.bmiddle_pic) {
        [self.engine setObject:[NSNumber numberWithBool:YES] forKey:@"hasWeiboImg"];
        [self.engine setObject:self.sinaWeiboDetail.bmiddle_pic forKey:@"weibo_imgUrl"];
    }else {
        [self.engine setObject:[NSNumber numberWithBool:NO] forKey:@"hasWeiboImg"];
    }
    
    [self.engine setObject:self.sinaWeiboDetail.source forKey:@"weibo_comeFrom"];
    [self.engine setObject:[SinaWeiboManager resolveSinaWeiboDate:self.sinaWeiboDetail.created_at] forKey:@"weibo_pubDate"];
    
    //source weibo
    if (self.sinaWeiboDetail.retweeted_status&&self.sinaWeiboDetail.retweeted_status.user) {
        [self.engine setObject:[NSNumber numberWithBool:YES] forKey:@"hasSource"];
        
        [self.engine setObject:self.sinaWeiboDetail.retweeted_status.user.profile_image_url forKey:@"source_headImgUrl"];
        [self.engine setObject:self.sinaWeiboDetail.retweeted_status.user.screen_name forKey:@"source_userName"];
        
        if (!self.sinaWeiboDetail.retweeted_status.text) {
            self.sinaWeiboDetail.retweeted_status.text=@"";
        }
        [self.engine setObject:[self.sinaWeiboDetail.retweeted_status.text handleForShowing] forKey:@"source_text"];
        
        if (self.sinaWeiboDetail.retweeted_status.bmiddle_pic) {
            [self.engine setObject:[NSNumber numberWithBool:YES] forKey:@"hasSourceImg"];
            [self.engine setObject:self.sinaWeiboDetail.retweeted_status.bmiddle_pic forKey:@"source_imgUrl"];
        }else {
            [self.engine setObject:[NSNumber numberWithBool:NO] forKey:@"hasSourceImg"];
        }
        
        [self.engine setObject:self.sinaWeiboDetail.retweeted_status.source forKey:@"source_comeFrom"];
        
        [self.engine setObject:[SinaWeiboManager resolveSinaWeiboDate:self.sinaWeiboDetail.retweeted_status.created_at] forKey:@"source_pubDate"];
    }else {
        [self.engine setObject:[NSNumber numberWithBool:NO] forKey:@"hasSource"];
    }
    
    //others
    [self.engine setObject:[NSString stringWithFormat:@"%d",self.sinaWeiboDetail.reposts_count] forKey:@"republishNum"];
    [self.engine setObject:[NSString stringWithFormat:@"%d",self.sinaWeiboDetail.comments_count] forKey:@"commentNum"];
    [self.engine setObject:[[NSBundle mainBundle] URLForResource:@"rePublishGuide" withExtension:@"png"] forKey:@"default_guide_imgUrl"];
    
    [self.engine setObject:[[NSBundle mainBundle] URLForResource:@"commentGuide" withExtension:@"png"] forKey:@"comment_guide_imgUrl"];
}

- (void)initTencentWeiboTemplate{
    //weibo
    [self.engine setObject:self.tencentWeiboDetail.head forKey:@"weibo_headImgUrl"];
    [self.engine setObject:self.tencentWeiboDetail.nick forKey:@"weibo_userName"];
    
    if (!self.tencentWeiboDetail.text) {
        self.tencentWeiboDetail.text=@"";
    }
    [self.engine setObject:[self.tencentWeiboDetail.text handleForShowing] forKey:@"weibo_text"];
    
    if ([self.tencentWeiboDetail.image isKindOfClass:[NSArray class]]&&self.tencentWeiboDetail.image.count>0) {
        [self.engine setObject:[NSNumber numberWithBool:YES] forKey:@"hasWeiboImg"];
        [self.engine setObject:[NSString stringWithFormat:@"%@/%d",[self.tencentWeiboDetail.image objectAtIndex:0],WEIBO_IMAGE_BIG] forKey:@"weibo_imgUrl"];
    }else {
        [self.engine setObject:[NSNumber numberWithBool:NO] forKey:@"hasWeiboImg"];
    }
    
    [self.engine setObject:self.tencentWeiboDetail.from forKey:@"weibo_comeFrom"];
    [self.engine setObject:[TencentWeiboManager resolveTencentWeiboDate:self.tencentWeiboDetail.timestamp] forKey:@"weibo_pubDate"];
    
    //source weibo
    if (self.tencentWeiboDetail.type!=1&&self.tencentWeiboDetail.type!=5) {
        [self.engine setObject:[NSNumber numberWithBool:YES] forKey:@"hasSource"];
        
        [self.engine setObject:self.tencentWeiboDetail.source.head forKey:@"source_headImgUrl"];
        [self.engine setObject:self.tencentWeiboDetail.source.nick forKey:@"source_userName"];
        
        if (!self.tencentWeiboDetail.source.text) {
            self.tencentWeiboDetail.source.text=@"";
        }
        [self.engine setObject:[self.tencentWeiboDetail.source.text handleForShowing] forKey:@"source_text"];
        
        if ([self.tencentWeiboDetail.source.image isKindOfClass:[NSArray class]]&&self.tencentWeiboDetail.source.image.count>0) {
            [self.engine setObject:[NSNumber numberWithBool:YES] forKey:@"hasSourceImg"];
            [self.engine setObject:[NSString stringWithFormat:@"%@/%d",[self.tencentWeiboDetail.source.image objectAtIndex:0],WEIBO_IMAGE_BIG] forKey:@"source_imgUrl"];
        }else {
            [self.engine setObject:[NSNumber numberWithBool:NO] forKey:@"hasSourceImg"];
        }
        
        [self.engine setObject:self.tencentWeiboDetail.source.from forKey:@"source_comeFrom"];
        
        [self.engine setObject:[TencentWeiboManager resolveTencentWeiboDate:self.tencentWeiboDetail.source.timestamp] forKey:@"source_pubDate"];
    }else {
        [self.engine setObject:[NSNumber numberWithBool:NO] forKey:@"hasSource"];
    }
    
    //others
    [self.engine setObject:[NSString stringWithFormat:@"%d",self.tencentWeiboDetail.count] forKey:@"republishNum"];
    [self.engine setObject:[NSString stringWithFormat:@"%d",self.tencentWeiboDetail.mcount] forKey:@"commentNum"];
    
    [self.engine setObject:[[NSBundle mainBundle] URLForResource:@"rePublishGuide" withExtension:@"png"] forKey:@"default_guide_imgUrl"];
    [self.engine setObject:[[NSBundle mainBundle] URLForResource:@"commentGuide" withExtension:@"png"] forKey:@"comment_guide_imgUrl"];
}

#pragma mark - UIWebView Delegate -
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [GlobalInstance hideHUD:self.hud];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked:
        {
            TSMiniWebBrowser *webBrowser = [[[TSMiniWebBrowser alloc] initWithUrl:[request URL]]autorelease];
            webBrowser.delegate = self;
            webBrowser.mode = TSMiniWebBrowserModeNavigation;
            webBrowser.barStyle = UIBarStyleBlack;
            
            if (webBrowser.mode == TSMiniWebBrowserModeModal) {
                webBrowser.modalDismissButtonTitle = @"Home";
                [self presentModalViewController:webBrowser animated:YES];
            } else if(webBrowser.mode == TSMiniWebBrowserModeNavigation) {
                [self.navigationController pushViewController:webBrowser 
                                                     animated:YES];
            }
        }
            return NO;
            break;
            
        default:
            break;
    }
    
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:[@"FEB" lowercaseString]]) {
        NSString *cmdName=(NSString *)[components objectAtIndex:1];
        if([cmdName isEqualToString:@"loadRepublishList"]) {
            NSString *loadTypeStr=(NSString*)[components objectAtIndex:2];
            self.loadtypeForRePublish=[loadTypeStr isEqualToString:@"0"]?firstLoad:loadMore;
            switch (self.currentPlatform) {
                case SinaWeibo:
                    [self loadRepublishListForSinaWeibo];
                    break;
                    
                case TencentWeibo:
                    [self loadRepublishListForTencentWeibo];
                    break;
                    
                default:
                    break;
            }
        }else if([cmdName isEqualToString:@"loadCommentList"]){
            NSString *loadTypeStr=(NSString*)[components objectAtIndex:2];
            self.loadtypeForComment=[loadTypeStr isEqualToString:@"0"]?firstLoad:loadMore;
            switch (self.currentPlatform) {
                case SinaWeibo:
                    [self loadCommentListForSinaWeibo];
                    break;
                    
                case TencentWeibo:
                    [self loadCommentListForTencentWeibo];
                    break;
                    
                default:
                    break;
            }
        }else if([cmdName startsWith:@"popActiveSheet"]){
            int itemIndex=[(NSString*)[components objectAtIndex:2] intValue];
            switch (self.currentPlatform) {
                case SinaWeibo:
                    self.currentSelectedItem=[self.sinaWeiboDataArr objectAtIndex:itemIndex];
                    
                    break;
                    
                case TencentWeibo:
                    self.currentSelectedItem=[self.tencentWeiboDataArr objectAtIndex:itemIndex];
                    break;
                    
                default:
                    break;
            }
            
            //NSString *name=[self.currentSelectedItem objectForKey:@"name"];
            UIActionSheet *actionSheet=nil;
            NSString *operationName=@"";
            if ([cmdName isEqualToString:@"popActiveSheet_republish"]) {
                operationName=@"转发";
            }else {
                operationName=@"回复";
            }
            
            actionSheet=[[UIActionSheet alloc]initWithTitle:@"" 
                                                   delegate:self 
                                          cancelButtonTitle:@"取消" 
                                     destructiveButtonTitle:operationName 
                                          otherButtonTitles:nil];
            
			
			[actionSheet showInView:[UIApplication sharedApplication].keyWindow];
			[actionSheet release];
		}
    }
    
    return YES;
}

#pragma mark - load republish or comment list -
- (void)loadRepublishListForSinaWeibo{
    self.currentDataType=dataType_rePublish;
	NSMutableDictionary *requestParams=[[[NSMutableDictionary alloc]init]autorelease];
    switch(self.loadtypeForRePublish){
		case firstLoad:
		{
            self.page=1;
			[requestParams setObject:self.sinaWeiboDetail.idstr forKey:@"id"];
            [requestParams setObject:@"10" forKey:@"count"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
		}
			break;
			
		case loadMore:
		{
            self.page+=1;
			[requestParams setObject:self.sinaWeiboDetail.idstr forKey:@"id"];
            [requestParams setObject:@"10" forKey:@"count"];
            [requestParams setObject:self.maxId forKey:@"max_id"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
		}
			break;
			
		default:
			break;
	}
    
    [self.engineForRAndCList loadRequestWithMethodName:@"statuses/repost_timeline.json"
                                            httpMethod:@"GET"
                                                params:requestParams
                                          postDataType:kWBRequestPostDataTypeNone
                                      httpHeaderFields:nil];
}


- (void)loadCommentListForSinaWeibo{
    self.currentDataType=dataType_comment;
    NSMutableDictionary *requestParams=[[[NSMutableDictionary alloc]init]autorelease];
	switch(self.loadtypeForComment){
		case firstLoad:
		{
            self.page=1;
			[requestParams setObject:self.sinaWeiboDetail.idstr forKey:@"id"];
            [requestParams setObject:@"10" forKey:@"count"];            
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
		}
			break;
			
		case loadMore:
		{
            self.page+=1;
			[requestParams setObject:self.sinaWeiboDetail.idstr forKey:@"id"];
            [requestParams setObject:@"10" forKey:@"count"];
            [requestParams setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
            [requestParams setObject:self.maxId forKey:@"max_id"];
		}
			break;
			
		default:
			break;
	}
    
    [self.engineForRAndCList loadRequestWithMethodName:@"comments/show.json"
                                            httpMethod:@"GET"
                                                params:requestParams
                                          postDataType:kWBRequestPostDataTypeNone
                                      httpHeaderFields:nil];
}

- (void)loadRepublishAndCommentNumForSinaWeibo{
    NSMutableDictionary *requestParams=[[NSMutableDictionary alloc]init];
    [requestParams setObject:self.sinaWeiboDetail.idstr forKey:@"ids"];
    
    [self.engineForRAndCNum loadRequestWithMethodName:@"statuses/count.json"
                                           httpMethod:@"GET"
                                               params:requestParams
                                         postDataType:kWBRequestPostDataTypeNone
                                     httpHeaderFields:nil];
    
    [requestParams release];
    
}

- (void)loadRepublishListForTencentWeibo{
    self.currentDataType=dataType_rePublish;
    OpenApi *myApi=[TencentWeiboManager getOpenApi];
    myApi.delegate=self;
    switch (self.loadtypeForRePublish) {
        case firstLoad:                 //首次加载
            self.lastItemWeiboId=@"0";
            self.lastItemTimeStamp=0;
            if (self.tencentWeiboDetail.type==1) {           //原创
                [myApi getWeiboCommentOrRepublishList:self.tencentWeiboDetail.uniqueId flag:@"0" pageFlag:@"0" pageTime:[NSString stringWithFormat:@"%lu",self.lastItemTimeStamp] reqNum:@"10" twitterid:self.lastItemWeiboId];
            }else if(self.tencentWeiboDetail.type!=1){       //非原创
                [myApi getRepublishWeiboCommentOrRepublishList:self.tencentWeiboDetail.uniqueId flag:@"1" pageFlag:@"0" pageTime:[NSString stringWithFormat:@"%lu",self.lastItemTimeStamp] reqNum:@"10" twitterid:self.lastItemWeiboId];
            }
            
            break;
            
        case loadMore:                  //加载更多
            if (self.tencentWeiboDetail.type==1) {           //原创
                [myApi getWeiboCommentOrRepublishList:self.tencentWeiboDetail.uniqueId flag:@"0" pageFlag:@"1" pageTime:[NSString stringWithFormat:@"%lu",self.lastItemTimeStamp] reqNum:@"10" twitterid:self.lastItemWeiboId];
            }else if(self.tencentWeiboDetail.type!=1){       //非原创
                [myApi getRepublishWeiboCommentOrRepublishList:self.tencentWeiboDetail.uniqueId flag:@"1" pageFlag:@"1" pageTime:[NSString stringWithFormat:@"%lu",self.lastItemTimeStamp] reqNum:@"10" twitterid:self.lastItemWeiboId];
            }
            
            break;
        default:
            break;
    }

}

- (void)loadCommentListForTencentWeibo{
	self.currentDataType=dataType_comment;
    OpenApi *myApi=[TencentWeiboManager getOpenApi];
    myApi.delegate=self;
    switch (loadtypeForComment) {
        case firstLoad:                 //首次加载
            if (self.tencentWeiboDetail.type==1) {           //原创
                [myApi getWeiboCommentOrRepublishList:self.tencentWeiboDetail.uniqueId flag:@"1" pageFlag:@"0" pageTime:@"0" reqNum:@"10" twitterid:@"0"];
            }else if(self.tencentWeiboDetail.type!=1){       //非原创
                [myApi getRepublishWeiboCommentOrRepublishList:self.tencentWeiboDetail.uniqueId flag:@"2" pageFlag:@"0" pageTime:@"0" reqNum:@"10" twitterid:@"0"];
            }
            
            break;
            
        case loadMore:                  //加载更多
            if (self.tencentWeiboDetail.type==1) {           //原创
                [myApi getWeiboCommentOrRepublishList:self.tencentWeiboDetail.uniqueId flag:@"1" pageFlag:@"1" pageTime:[NSString stringWithFormat:@"%lu",self.lastItemTimeStamp] reqNum:@"10" twitterid:self.lastItemWeiboId];
            }else if(self.tencentWeiboDetail.type!=1){       //非原创
                [myApi getRepublishWeiboCommentOrRepublishList:self.tencentWeiboDetail.uniqueId flag:@"2" pageFlag:@"1" pageTime:[NSString stringWithFormat:@"%lu",self.lastItemTimeStamp] reqNum:@"10" twitterid:self.lastItemWeiboId];
            }
            
            break;
            
        default:
            break;
    }
}

- (void)loadRepublishAndCommentNumForTencentWeibo{
    OpenApi *myApi=[TencentWeiboManager getOpenApi];
    myApi.delegate=self;
    [myApi getRepublishAndCommentCountWithWeiboId:self.tencentWeiboDetail.uniqueId];
}

- (void)loadRepublishAndCommentNum{
    switch (self.currentPlatform) {
        case SinaWeibo:
            [self loadRepublishAndCommentNumForSinaWeibo];
            break;
            
        case TencentWeibo:
            [self loadRepublishAndCommentNumForTencentWeibo];
            break;
            
        default:
            break;
    }
}

#pragma mark - WBEngin Delegate -
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    //republish and comment 
    if ([result isKindOfClass:[NSDictionary class]])
    {
        
        NSDictionary *dict = (NSDictionary *)result;
        NSString *scriptFuncStrFormat=@"";
        
        if (self.currentDataType==dataType_rePublish) {
            scriptFuncStrFormat=@"FEB.loadRepublishList(%@);";
            switch (self.loadtypeForRePublish) {         
                case firstLoad:                     //首次加載
                    self.sinaWeiboDataArr=nil;
                    self.sinaWeiboDataArr=[SinaWeiboManager resolveWeiboRAndCListToArrayForJSON:[dict objectForKey:@"reposts"]];
                    break;
                    
                case loadMore:                      //加載更多
                {
                    NSMutableArray *newList=[[[NSMutableArray alloc]initWithArray:self.sinaWeiboDataArr copyItems:NO]autorelease];
                    NSMutableArray *tmpArr=[SinaWeiboManager resolveWeiboRAndCListToArrayForJSON:[dict objectForKey:@"reposts"]];
                    if ([tmpArr count]!=0) {
                        [newList addObjectsFromArray:tmpArr];
                        self.sinaWeiboDataArr=newList;
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }else {
            scriptFuncStrFormat=@"FEB.loadCommentList(%@);";
            switch (self.loadtypeForComment) {
                case firstLoad:
                    self.sinaWeiboDataArr=nil;
                    self.sinaWeiboDataArr=[SinaWeiboManager resolveWeiboRAndCListToArrayForJSON:[dict objectForKey:@"comments"]];
                    break;
                    
                case loadMore:
                {
                    NSMutableArray *newList=[[[NSMutableArray alloc]initWithArray:self.sinaWeiboDataArr copyItems:NO]autorelease];
                    NSMutableArray *tmpArr=[SinaWeiboManager resolveWeiboRAndCListToArrayForJSON:[dict objectForKey:@"comments"]];
                    if ([tmpArr count]!=0) {
                        [newList addObjectsFromArray:tmpArr];
                        self.sinaWeiboDataArr=newList;
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        //记录最后一条记录用于翻页
        if (self.sinaWeiboDataArr.count>0) {
            NSMutableDictionary *lastDic=[self.sinaWeiboDataArr objectAtIndex:self.sinaWeiboDataArr.count-1];
            self.maxId=(NSString*)[lastDic objectForKey:@"uniqueId"];
        }
        
        [self callWebViewJavaScriptForRAndCList:scriptFuncStrFormat];
    }else if([result isKindOfClass:[NSArray class]]){
        if ([(NSArray*)result count]>0) {
            NSDictionary *data=(NSDictionary*)[(NSArray*)result objectAtIndex:0];
            NSString *rNum=[[data objectForKey:@"reposts"] stringValue];
            NSString *cNum=[[data objectForKey:@"comments"] stringValue];
            NSString *randcNumscript = [NSString stringWithFormat:@"FEB.reloadRAndCNum('%@','%@');", rNum,cNum];
            [self.webView stringByEvaluatingJavaScriptFromString:randcNumscript];
        }
    }
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    
}

#pragma mark - tencentweibo delegate -
- (void)tencentWeiboRequestDidReturnResponse:(TencentWeiboList *)result{
    NSString *scriptFuncStrFormat=nil;
    switch (self.currentDataType) {
        case dataType_comment:
        {
            scriptFuncStrFormat=@"FEB.loadCommentList(%@);";
            switch (loadtypeForComment) {
                case firstLoad:
                    self.tencentWeiboDataArr=nil;
                    self.tencentWeiboDataArr=result.list;
                    break;
                    
                case loadMore:                  //加载更多
                    if ([result.list count]!=0) {
                        NSMutableArray *newList=[[[NSMutableArray alloc]initWithArray:self.tencentWeiboDataArr copyItems:NO]autorelease];
                        [newList addObjectsFromArray:result.list];
                        self.tencentWeiboDataArr=newList;
                    }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case dataType_rePublish:
        {
            scriptFuncStrFormat=@"FEB.loadRepublishList(%@);";
            switch (loadtypeForRePublish) {
                case firstLoad:
                    self.tencentWeiboDataArr=nil;
                    self.tencentWeiboDataArr=result.list;
                    break;
                    
                case loadMore:
                    if ([result.list count]!=0) {
                        NSMutableArray *newList=[[[NSMutableArray alloc]initWithArray:self.tencentWeiboDataArr copyItems:NO]autorelease];
                        [newList addObjectsFromArray:result.list];
                        self.tencentWeiboDataArr=newList;
                    }
                    break;
                    
                default:
                    break;
            }
        }
            break;
    }
    
    if (self.tencentWeiboDataArr.count>0) {
        //记录最后一条，用于翻页
        NSDictionary *lastItem=[self.tencentWeiboDataArr objectAtIndex:self.tencentWeiboDataArr.count-1];
        self.lastItemTimeStamp=[[lastItem objectForKey:@"extra"] longValue];
        self.lastItemWeiboId=[lastItem objectForKey:@"uniqueId"];
    }
    
    [self callWebViewJavaScriptForRAndCList:scriptFuncStrFormat];

}

-(void)tencentWeiboRequestDidReturnResponseForOthers:(id)result{
    NSDictionary *data=(NSDictionary*)result;
    
    NSString *randcNumscript = [NSString stringWithFormat:@"FEB.reloadRAndCNum('%@','%@');", [data objectForKey:@"count"],[data objectForKey:@"mcount"]];
    [self.webView stringByEvaluatingJavaScriptFromString:randcNumscript];
}

- (void)tencentWeiboRequestFailWithError{
    [GlobalInstance showMessageBoxWithMessage:@"获取数据失败"];
}

#pragma mark - WeiboDetailForRAndCDelegate -
- (void)operate:(operateType)_operateType{
    switch (self.currentPlatform) {
        case SinaWeibo:
            [self presentSinaWeiboRAndCController:_operateType];
            break;
            
        case TencentWeibo:
            [self presentTencentWeiboRAndCController:_operateType];
            break;
            
        default:
            break;
    }
}

#pragma mark - UIActionSheet Delegate -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:                 //operate 
            [self handleRAndCActionSheetOperate];
            break;
            
        case 1:                 //cancel
            break;
    }
}

#pragma mark - rAndCDelegate -
/*
 *评论或转发成功
 */
- (void)rAndCSuccessfully{
    switch (self.currentPlatform) {
        case SinaWeibo:
        {
            //refresh 
            switch (self.currentDataType) {
                case dataType_rePublish:
                    self.loadtypeForRePublish=firstLoad;
                    [self loadRepublishListForSinaWeibo];
                    break;
                    
                case dataType_comment:
                    self.loadtypeForComment=firstLoad;
                    [self loadCommentListForSinaWeibo];
                    break;
            }
        }
            break;
            
        case TencentWeibo:{
            //refresh
            switch (self.currentDataType) {
                case dataType_rePublish:
                    self.loadtypeForRePublish=firstLoad;
                    [self loadRepublishListForTencentWeibo];
                    break;
                    
                case dataType_comment:
                    self.loadtypeForComment=firstLoad;
                    [self loadCommentListForTencentWeibo];
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - utility methods -
/*
 *使webview 调用js来加载转播与评论列表
 */
- (void)callWebViewJavaScriptForRAndCList:(NSString*)scriptFuncStrFormat{
    NSMutableDictionary *list=nil;
    
    switch (self.currentPlatform) {
        case SinaWeibo:
            if (self.sinaWeiboDataArr) {
                list=[[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.sinaWeiboDataArr,@"dataList", nil]autorelease];
            }else {
                list=[[[NSMutableDictionary alloc]initWithObjectsAndKeys:[[[NSArray alloc]init]autorelease],@"dataList", nil]autorelease];
            }
            break;
            
        case TencentWeibo:
            if (self.tencentWeiboDataArr) {
                list=[[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.tencentWeiboDataArr,@"dataList", nil]autorelease];
            }else {
                list=[[[NSMutableDictionary alloc]initWithObjectsAndKeys:[[[NSArray alloc]init]autorelease],@"dataList", nil]autorelease];
            }
            
            break;
            
        default:
            break;
    }
    
    NSError *error;
    NSData *listData=[NSJSONSerialization dataWithJSONObject:list options:0 error:&error];
    if (!listData) {
        DebugLog(@"Could not write JSON data: %@", error);
    }else {
        NSString *listString = [[[NSString alloc] initWithData:listData encoding:NSUTF8StringEncoding]autorelease];
        NSString *script = [NSString stringWithFormat:scriptFuncStrFormat, listString];
        [self.webView stringByEvaluatingJavaScriptFromString:script];
        //refresh republish and comment num
        [self loadRepublishAndCommentNum];
    }
}

- (void)presentSinaWeiboRAndCController:(operateType)_operateType{
    //传递参数
	NSMutableDictionary *commentParams=[[NSMutableDictionary alloc]init];
    SinaWeiboRePublishOrCommentController *RandCCtrller;
    
    switch (_operateType) {
        case republish:
            [commentParams setObject:[NSString stringWithFormat:@"转发%@的微博",self.sinaWeiboDetail.user.screen_name] forKey:@"showTitle"];
            [commentParams setObject:self.sinaWeiboDetail.idstr forKey:@"theSubjectId"];
            [commentParams setObject:[NSString stringWithFormat:@"// @%@ :%@",self.sinaWeiboDetail.user.screen_name,self.sinaWeiboDetail.text] forKey:@"sourceContent"];
            break;
            
        case comment:
            [commentParams setObject:[NSString stringWithFormat:@"评论给%@",self.sinaWeiboDetail.user.screen_name] forKey:@"showTitle"];
            [commentParams setObject:self.sinaWeiboDetail.idstr forKey:@"theSubjectId"];
            [commentParams setObject:@"0" forKey:@"commentType"];					
            [commentParams setObject:@"" forKey:@"sourceContent"];
            break;
            
        case reply:
            
        default:
            break;
    }
	
    RandCCtrller=[[SinaWeiboRePublishOrCommentController alloc]initWithNibName:@"SinaWeiboRePublishOrCommentView" bundle:nil operateType:_operateType comeInParam:commentParams];
    RandCCtrller.delegate=self;
	[commentParams release];
    
    UINavigationController *randcNavCtrller=[[UINavigationController alloc]initWithRootViewController:RandCCtrller];
    [RandCCtrller release];
    randcNavCtrller.modalTransitionStyle=UIModalTransitionStyleCoverVertical;    
	
	//弹出模式视图
    [self presentModalViewController:randcNavCtrller animated:YES];
    [randcNavCtrller release];
}

- (void)presentTencentWeiboRAndCController:(operateType)_operateType{
    //传递参数
	NSMutableDictionary *commentParams=[[NSMutableDictionary alloc]init];
    TencentWeiboRePublishOrCommentController *RandCCtrller;
    
    switch (_operateType) {
        case republish:
            [commentParams setObject:self.tencentWeiboDetail.uniqueId forKey:@"theSubjectId"];
            [commentParams setObject:[NSString stringWithFormat:@"转发%@的微博",self.tencentWeiboDetail.nick] forKey:@"showTitle"];
            [commentParams setObject:[NSString stringWithFormat:@"// @%@ :%@",self.tencentWeiboDetail.nick,self.tencentWeiboDetail.text] forKey:@"sourceContent"];
            break;
     
        case comment:
            [commentParams setObject:self.tencentWeiboDetail.uniqueId forKey:@"theSubjectId"];
            [commentParams setObject:[NSString stringWithFormat:@"评论给%@",self.tencentWeiboDetail.nick] forKey:@"showTitle"];
            [commentParams setObject:@"" forKey:@"sourceContent"];
            break;
    
        case reply:
            
            break;
    }
	
    RandCCtrller=[[TencentWeiboRePublishOrCommentController alloc]initWithNibName:@"TencentWeiboRePublishOrCommentView" bundle:nil operateType:_operateType comeInParam:commentParams];
    RandCCtrller.delegate=self;
	[commentParams release];
    
    UINavigationController *randcNavCtrller=[[UINavigationController alloc]initWithRootViewController:RandCCtrller];
    [RandCCtrller release];
    randcNavCtrller.modalTransitionStyle=UIModalTransitionStyleCoverVertical;    
	
	//弹出模式视图
    [self presentModalViewController:randcNavCtrller animated:YES];
    [randcNavCtrller release];
}

- (void)handleRAndCActionSheetOperate{
    switch (self.currentPlatform) {
        case SinaWeibo:
            [self handleRAndCActionSheetForSinaWeibo];
            break;
            
        case TencentWeibo:
            [self handleRAndCActionSheetForTencentWeibo];
            break;
            
        default:
            break;
    }
}

- (void)handleRAndCActionSheetForSinaWeibo{
    //传递参数
	NSMutableDictionary *commentParams=[[NSMutableDictionary alloc]init];
    SinaWeiboRePublishOrCommentController *RandCCtrller;
    operateType _operateType;
    
    switch (self.currentDataType) {
        case dataType_rePublish:
            _operateType=republish;
            [commentParams setObject:[NSString stringWithFormat:@"转发%@的微博",[self.currentSelectedItem objectForKey:@"name"]] forKey:@"showTitle"];
            [commentParams setObject:[self.currentSelectedItem objectForKey:@"uniqueId"] forKey:@"theSubjectId"];
            [commentParams setObject:[NSString stringWithFormat:@"// @%@ :%@",[self.currentSelectedItem objectForKey:@"name"],[self.currentSelectedItem objectForKey:@"text"]] forKey:@"sourceContent"];
            break;
            
        case dataType_comment:
            _operateType=reply;
            [commentParams setObject:[NSString stringWithFormat:@"评论给%@",[self.currentSelectedItem objectForKey:@"name"]] forKey:@"showTitle"];
            [commentParams setObject:[self.currentSelectedItem objectForKey:@"uniqueId"] forKey:@"theSubjectId"];
            [commentParams setObject:@"0" forKey:@"commentType"];
            [commentParams setObject:@"" forKey:@"sourceContent"];
            //for reply:微博的id
            [commentParams setObject:self.sinaWeiboDetail.idstr forKey:@"theSourceId"];
            break;
            
        default:
            break;
    }
	
    RandCCtrller=[[SinaWeiboRePublishOrCommentController alloc]initWithNibName:@"SinaWeiboRePublishOrCommentView" bundle:nil operateType:_operateType comeInParam:commentParams];
    RandCCtrller.delegate=self;
	[commentParams release];
    
    UINavigationController *randcNavCtrller=[[UINavigationController alloc]initWithRootViewController:RandCCtrller];
    [RandCCtrller release];
    randcNavCtrller.modalTransitionStyle=UIModalTransitionStyleCoverVertical;    
	
	//弹出模式视图
    [self presentModalViewController:randcNavCtrller animated:YES];
    [randcNavCtrller release];
}

- (void)handleRAndCActionSheetForTencentWeibo{
    //传递参数
	NSMutableDictionary *commentParams=[[NSMutableDictionary alloc]init];
    TencentWeiboRePublishOrCommentController *RandCCtrller;
    operateType _operateType;
    
    switch (self.currentDataType) {
        case dataType_rePublish:
            _operateType=republish;
            [commentParams setObject:[self.currentSelectedItem objectForKey:@"uniqueId"] forKey:@"theSubjectId"];
            [commentParams setObject:[NSString stringWithFormat:@"转发%@的微博",[self.currentSelectedItem objectForKey:@"name"]] forKey:@"showTitle"];
            [commentParams setObject:[NSString stringWithFormat:@"// @%@ :%@",[self.currentSelectedItem objectForKey:@"name"],[self.currentSelectedItem objectForKey:@"text"]] forKey:@"sourceContent"];
            break;
            
        case dataType_comment:
            _operateType=reply;
            [commentParams setObject:[self.currentSelectedItem objectForKey:@"uniqueId"] forKey:@"theSubjectId"];
            [commentParams setObject:[NSString stringWithFormat:@"回复给%@",[self.currentSelectedItem objectForKey:@"name"]] forKey:@"showTitle"];
            [commentParams setObject:@"" forKey:@"sourceContent"];
            break;
    }
	
    RandCCtrller=[[TencentWeiboRePublishOrCommentController alloc]initWithNibName:@"TencentWeiboRePublishOrCommentView" bundle:nil operateType:_operateType comeInParam:commentParams];
    RandCCtrller.delegate=self;
	[commentParams release];
    
    UINavigationController *randcNavCtrller=[[UINavigationController alloc]initWithRootViewController:RandCCtrller];
    [RandCCtrller release];
    randcNavCtrller.modalTransitionStyle=UIModalTransitionStyleCoverVertical;    
	
	//弹出模式视图
    [self presentModalViewController:randcNavCtrller animated:YES];
    [randcNavCtrller release];
}

@end
