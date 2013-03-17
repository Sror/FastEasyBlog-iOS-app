//  
//  BlogDetailControllerViewController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 10/28/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "BlogDetailController.h"
#import "RenRenNews.h"
#import "RenRenBlog.h"
#import "RenRenAttachment.h"
#import "RenRenManager.h"
#import "ICUTemplateMatcher.h"
#import "RenRenRePublishOrCommentController.h"

#import "MoreOptionController.h"

#define TEMPLATE_PATH [[NSBundle mainBundle] pathForResource:@"blogDetail" ofType:@"html"]

typedef enum{
    TAG_FRONTBACKGROUNDVIEW=999,
}UIVIEW_TAG;

@interface BlogDetailController ()

@property (nonatomic,retain) MGTemplateEngine *engine;

@property (nonatomic,retain) RenRenNews *news;
@property (nonatomic,retain) RenRenBlog *newsDetail;
@property (nonatomic,assign) BOOL isLoadingBlog;
@property (nonatomic,assign) BOOL isPublishedBlog;
@property (nonatomic,assign) BOOL isSharedBlog;
@property (nonatomic,retain) NSMutableArray *commentList;
@property (nonatomic,retain) NSDictionary *selectedItem;

//more optional param values
@property (nonatomic,assign) BOOL isNightMode;
@property (nonatomic,assign) float lightValue;
@property (nonatomic,assign) int fontSizeSegmentedSelectedIndex;

@end

@implementation BlogDetailController

@synthesize engine=_engine;
@synthesize webView=_webView;
@synthesize news=_news;
@synthesize newsDetail=_newsDetail;
@synthesize isLoadingBlog;
@synthesize isPublishedBlog;
@synthesize isSharedBlog;
@synthesize commentList;
@synthesize selectedItem;

@synthesize isNightMode;
@synthesize lightValue;
@synthesize fontSizeSegmentedSelectedIndex;

- (void)dealloc{
    [_engine release],_engine=nil;
    _webView.delegate=nil;
    [_webView release],_webView=nil;
    [_newsDetail release],_newsDetail=nil;
    [_news release],_news=nil;
    [commentList release],commentList=nil;
    [selectedItem release],selectedItem=nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:OPTIONAL_NOTIFICATION object:nil];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _engine = [[MGTemplateEngine templateEngine] retain];
        [self.engine setDelegate:self];
        [self.engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:self.engine]];
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, VIEWCONTENTWIDTH, VIEWCONTENTHEIGHT+44)];
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [GlobalInstance clearWebViewBackground:self.webView];
        self.webView.delegate = self;
        
        self.isNightMode=NO;
        self.lightValue=0.5f;
        self.fontSizeSegmentedSelectedIndex=1;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
                 news:(RenRenNews*)currentNews{
    if (self=[self initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _news=[currentNews retain];
        super.delegate=self;
        isLoadingBlog=YES;
        
        isPublishedBlog=[self.news.feed_type isEqualToString:@"20"]||[self.news.feed_type isEqualToString:@"22"];
        isSharedBlog=[self.news.feed_type isEqualToString:@"21"]||[self.news.feed_type isEqualToString:@"23"];
    }
    
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self.view addSubview:super.toolbar];
    [self.view addSubview:self.webView];
    self.navigationItem.title=[NSString stringWithFormat:@"%@的日志",self.news.name];
    
    [GlobalInstance showHUD:@"日志详情加载中,请稍后..." 
                    andView:self.view 
                     andHUD:self.hud];
    [self getBlogInfo];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[UIScreen mainScreen] setBrightness:0.5f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.webView stopLoading];
    [GlobalInstance hideHUD:self.hud];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods -
/*
 *獲取用戶日誌
 */
- (void)getBlogInfo{
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithCapacity:10];
    if(isPublishedBlog){            //发表的日志
        [params setObject:self.news.source_id forKey:@"id"];    
        if ([self.news.actor_type isEqualToString:@"user"]) {
            [params setObject:self.news.actor_id forKey:@"uid"];
        }else{
            [params setObject:self.news.actor_id forKey:@"page_id"];
        }
    }else if(isSharedBlog){           //分享的日志
        [params setObject:((RenRenAttachment*)[self.news.attachment objectAtIndex:0]).media_id forKey:@"id"];
        [params setObject:((RenRenAttachment*)[self.news.attachment objectAtIndex:0]).owner_id forKey:@"uid"];
    }
    [params setObject:@"blog.get" forKey:@"method"];
    [params setObject:@"JSON" forKey:@"format"];
	[[Renren sharedRenren]requestWithParams:params andDelegate:self];
}

/*
 *加载评论列表
 */
- (void)loadCommentList{
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithCapacity:10];
	[params setObject:@"blog.getComments" forKey:@"method"];
    if(isPublishedBlog){            //发表的日志
        [params setObject:self.news.source_id forKey:@"id"]; 
        if ([self.news.actor_type isEqualToString:@"user"]) {
            [params setObject:self.news.actor_id forKey:@"uid"];
        }else{
            [params setObject:self.news.actor_id forKey:@"page_id"];
        }
    }else if(isSharedBlog){
        [params setObject:((RenRenAttachment*)[self.news.attachment objectAtIndex:0]).media_id forKey:@"id"];
        [params setObject:((RenRenAttachment*)[self.news.attachment objectAtIndex:0]).owner_id forKey:@"uid"];
    }
    
    [params setObject:@"JSON" forKey:@"format"];
    [params setObject:@"1" forKey:@"page"];
    [params setObject:@"1000" forKey:@"count"];
    [params setObject:@"0" forKey:@"order"];        //升序排列
	[[Renren sharedRenren]requestWithParams:params andDelegate:self];
}

/*
 *使webview 调用js来加载转播与评论列表
 */
- (void)callWebViewJavaScriptForCommentList{
    NSMutableDictionary *list=nil;
    if (self.commentList) {
        list=[[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.commentList,@"dataList", nil]autorelease];
    }else {
        list=[[[NSMutableDictionary alloc]initWithObjectsAndKeys:[[[NSArray alloc]init]autorelease],@"dataList", nil]autorelease];
    }
    
    NSError *error;
    NSData *listData=[NSJSONSerialization dataWithJSONObject:list options:0 error:&error];
    if (!listData) {
        DebugLog(@"Could not write JSON data: %@", error);
    }else {
        NSString *listString = [[[NSString alloc] initWithData:listData encoding:NSUTF8StringEncoding]autorelease];
        NSString *script = [NSString stringWithFormat:@"FEB.loadCommentList(%@);", listString];
        [self.webView stringByEvaluatingJavaScriptFromString:script];
    }
}

#pragma mark - RenrenDelegate -
-(void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse *)response{
    if (isLoadingBlog) {
        self.newsDetail=[RenRenManager resolveNewsDetailToObject:response];
        [self initHTMLTmplate];
        // Process the template and display the results.
        NSString *htmlStr = [self.engine processTemplateInFileAtPath:TEMPLATE_PATH withVariables:nil];
        DebugLog(@"Processed template:\r%@", htmlStr);
        [self.webView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle]bundleURL]];
        isLoadingBlog=NO;
    }else{                                  //加载评论
        self.commentList=[RenRenManager resolveBlogCommentsForJSON:response];
        [self callWebViewJavaScriptForCommentList];
    }
}

-(void)renren:(Renren *)renren requestFailWithError:(ROError *)error{
	[GlobalInstance showMessageBoxWithMessage:@"API请求错误"];
}

#pragma mark - init template -
- (void)initHTMLTmplate{
    [self.engine setObject:self.news.headurl forKey:@"headImgUrl"];
    [self.engine setObject:self.news.title forKey:@"blogTitle"];
    [self.engine setObject:self.newsDetail.content forKey:@"blogContent"];
    [self.engine setObject:[RenRenManager resolveRenRenDate:self.news.update_time] forKey:@"blogPubDate"];
    [self.engine setObject:self.newsDetail.comment_count forKey:@"commentNum"];
    
    //others
    [self.engine setObject:[[NSBundle mainBundle] URLForResource:@"rePublishGuide" withExtension:@"png"] forKey:@"default_guide_imgUrl"];
}

#pragma mark - UIWebView Delegate -
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [GlobalInstance hideHUD:self.hud];
    [self loadCommentList];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:[@"FEB" lowercaseString]]) {
        NSString *cmdName=(NSString *)[components objectAtIndex:1];
        if([cmdName startsWith:@"popActiveSheet"]){
            int itemIndex=[(NSString*)[components objectAtIndex:2] intValue];
            self.selectedItem=[self.commentList objectAtIndex:itemIndex];
            
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
        }else if([cmdName isEqualToString:@"changeFamily"]){
            NSString *familyName=AppConfig(@"renrenBlog_detail_fontName");
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"FEB.changeFontFamily('%@')",familyName]];
        }
    }
    
    return YES;
}

#pragma mark - UIActionSheet Delegate -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:                 //operate 
            [self handleCommentActionSheetOperate];
            break;
            
        case 1:                 //cancel
            break;
    }
}

- (void)handleCommentActionSheetOperate{
    //传递参数
	NSMutableDictionary *commentParams=[[NSMutableDictionary alloc]init];
	[commentParams setObject:self.news.feed_type forKey:@"feedType"];
	[commentParams setObject:[NSString stringWithFormat:@"评论给%@",[self.selectedItem objectForKey:@"name"]] forKey:@"showTitle"];
    if (isPublishedBlog) {
        [commentParams setObject:self.news.source_id forKey:@"theSubjectId"];
        [commentParams setObject:self.news.actor_id forKey:@"ownerId"];
    }else if(isSharedBlog){
        [commentParams setObject:((RenRenAttachment*)[self.news.attachment objectAtIndex:0]).media_id forKey:@"theSubjectId"];
        [commentParams setObject:((RenRenAttachment*)[self.news.attachment objectAtIndex:0]).owner_id forKey:@"ownerId"];
    }
	
	[commentParams setObject:[self.selectedItem objectForKey:@"uniqueId"] forKey:@"rid"];
	[commentParams setObject:@"0" forKey:@"commentType"];		//暂时全部置为公开
	[commentParams setObject:@"" forKey:@"sourceContent"];		//回复不需要原文
	
	
	RenRenRePublishOrCommentController *rePublishOrCommentController=[[RenRenRePublishOrCommentController alloc]initWithNibName:@"RenRenRePublishOrCommentView" bundle:nil operateType:comment comeInParam:commentParams];
    rePublishOrCommentController.delegate=self;
	[commentParams release];
    
    UINavigationController *rePublishOrCommentNavigationController=[[UINavigationController alloc]initWithRootViewController:rePublishOrCommentController];
    [rePublishOrCommentController release];
    rePublishOrCommentNavigationController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;                    //底部滑入
    
	
	//弹出模式视图
    [self presentModalViewController:rePublishOrCommentNavigationController animated:YES];
    [rePublishOrCommentNavigationController release];
}

#pragma mark - PlatformDetailControllerDelegate -
- (void)operate:(operateType)_operateType{
    //传递参数
	NSMutableDictionary *commentParams=[[NSMutableDictionary alloc]init];
    RenRenRePublishOrCommentController *RandCCtrller;
    [commentParams setObject:self.news.feed_type forKey:@"feedType"];    
    [commentParams setObject:self.news.source_id forKey:@"theSubjectId"];
    [commentParams setObject:self.news.actor_id forKey:@"ownerId"];
    [commentParams setObject:@"" forKey:@"rid"];
    
    switch (_operateType) {
        case republish:
            [commentParams setObject:[NSString stringWithFormat:@"分享%@的日志",self.news.name] forKey:@"showTitle"];
            [commentParams setObject:@"0" forKey:@"commentType"];				
            [commentParams setObject:@"" forKey:@"sourceContent"];
            break;
            
        case comment:
            [commentParams setObject:[NSString stringWithFormat:@"评论给%@",self.news.name] forKey:@"showTitle"];
            [commentParams setObject:@"0" forKey:@"commentType"];				
            [commentParams setObject:@"" forKey:@"sourceContent"];
            break;
            
        default:
            break;
    }
	
    RandCCtrller=[[RenRenRePublishOrCommentController alloc]initWithNibName:@"RenRenRePublishOrCommentView" bundle:nil operateType:_operateType comeInParam:commentParams];
    RandCCtrller.delegate=self;
    
    UINavigationController *randcNavCtrller=[[UINavigationController alloc]initWithRootViewController:RandCCtrller];
    [RandCCtrller release];
    randcNavCtrller.modalTransitionStyle=UIModalTransitionStyleCoverVertical;    
	
	//弹出模式视图
    [self presentModalViewController:randcNavCtrller animated:YES];
    [commentParams release];
    [randcNavCtrller release];
}

- (void)moreToolBar_TouchUpInside:(id)sender{
    UIView *bgView=[self.view viewWithTag:TAG_FRONTBACKGROUNDVIEW];
    if (bgView) {
        [self handleGesture:nil];
        return;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotificationForBlogDetail:) name:OPTIONAL_NOTIFICATION object:nil];
    
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOWWIDTH, VIEWCONTENTHEIGHT-145)];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.tag=TAG_FRONTBACKGROUNDVIEW;
    backgroundView.alpha=0.4;
    [backgroundView addGestureRecognizer:[[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)]autorelease]];
    
    [self.view addSubview:backgroundView];
    [self.view bringSubviewToFront:backgroundView];
    [backgroundView release];
    
    MoreOptionController *moreOptionCtrller=[[MoreOptionController alloc]init];
    moreOptionCtrller.isNightMode=self.isNightMode;
    moreOptionCtrller.lightValue=self.lightValue;
    moreOptionCtrller.fontSizeSegmentedSelectedIndex=self.fontSizeSegmentedSelectedIndex;
    [self addChildViewController:moreOptionCtrller];
    [self.view addSubview:moreOptionCtrller.view];
    [moreOptionCtrller release];
}

/*
 *处理手势
 */
- (void)handleGesture:(UISwipeGestureRecognizer*)gestureRecognizer{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:OPTIONAL_NOTIFICATION object:nil];
    
    UIView *bgView=[self.view viewWithTag:TAG_FRONTBACKGROUNDVIEW];
    [bgView removeFromSuperview];
    for (UIViewController *subCtrllers in self.childViewControllers) {
        if ([subCtrllers.class isSubclassOfClass:[MoreOptionController class]]) {
            [subCtrllers removeFromParentViewController];
            [subCtrllers.view removeFromSuperview];
        }
    }
}

- (void)handleNotificationForBlogDetail:(NSNotification*)notification{
    NSDictionary *params=(NSDictionary*)[notification object];
    optionalType currentOptionalType=[[params objectForKey:@"optionalType"] intValue];
    switch (currentOptionalType) {
        case nightMode:
        {
            BOOL isOn=[[params objectForKey:@"value"] boolValue];
            if (isOn) {
                [self.webView stringByEvaluatingJavaScriptFromString:
                 @"FEB.changeToNightMode();"];
            }else {
                [self.webView stringByEvaluatingJavaScriptFromString:
                 @"FEB.changeToWhiteDayMode();"];
            }
            self.isNightMode=isOn;
        }
            break;
            
        case lightSetting:
        {
            float value=[[params objectForKey:@"value"] floatValue];
            [[UIScreen mainScreen] setBrightness:value];
            self.lightValue=value;
        }
            break;
            
        case fontSizeSetting:
        {
            int selectedIndex=[[params objectForKey:@"value"] intValue];
            self.fontSizeSegmentedSelectedIndex=selectedIndex;
            switch (selectedIndex) {
                case 0:
                    [self.webView stringByEvaluatingJavaScriptFromString:
                     @"FEB.fontSizeSmall();"];
                    break;
                    
                case 1:
                    [self.webView stringByEvaluatingJavaScriptFromString:
                     @"FEB.fontSizeMiddle();"];
                    break;
                    
                case 2:
                    [self.webView stringByEvaluatingJavaScriptFromString:
                     @"FEB.fontSizeLarge();"];
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - rAndCDelegate -
/*
 *评论或转发成功
 */
- (void)rAndCSuccessfully{
    [self loadCommentList];
}

@end
