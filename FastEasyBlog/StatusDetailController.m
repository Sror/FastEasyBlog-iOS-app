//
//  StatusDetailController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 10/28/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "StatusDetailController.h"
#import "RenRenNews.h"
#import "RenRenManager.h"
#import "ICUTemplateMatcher.h"
#import "RenRenRePublishOrCommentController.h"

#define TEMPLATE_PATH [[NSBundle mainBundle] pathForResource:@"statusDetail" ofType:@"html"]

@interface StatusDetailController ()

@property (nonatomic,retain) MGTemplateEngine *engine;

@property (nonatomic,retain) RenRenNews *news;
@property (nonatomic,retain) NSMutableArray *commentList;
@property (nonatomic,retain) NSDictionary *selectedItem;


@end

@implementation StatusDetailController

@synthesize engine=_engine;
@synthesize webView=_webView;
@synthesize news=_news;
@synthesize commentList;
@synthesize selectedItem;

- (void)dealloc{
    [_engine release],_engine=nil;
    _webView.delegate=nil;
    [_webView release],_webView=nil;
    [_news release],_news=nil;
    [commentList release],commentList=nil;
    [selectedItem release],selectedItem=nil;
    
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
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
                 news:(RenRenNews*)currentNews{
    if (self=[self initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _news=[currentNews retain];
        super.delegate=self;
    }
    
    return self;
}
    
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:super.toolbar];
    [self.view addSubview:self.webView];
	self.navigationItem.title=[NSString stringWithFormat:@"%@的状态",self.news.name];
    [GlobalInstance showHUD:@"状态详情加载中,请稍后..." andView:self.view andHUD:self.hud];
    [self initHTMLTmplate];
    // Process the template and display the results.
	NSString *htmlStr = [self.engine processTemplateInFileAtPath:TEMPLATE_PATH withVariables:nil];
	DebugLog(@"Processed template:\r%@", htmlStr);
    [self.webView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle]bundleURL]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
- (void)initHTMLTmplate{
    [self.engine setObject:self.news.headurl forKey:@"headImgUrl"];
    [self.engine setObject:self.news.name forKey:@"name"];
    [self.engine setObject:self.news.message forKey:@"text"];
    [self.engine setObject:[RenRenManager resolveRenRenDate:self.news.update_time] forKey:@"pubDate"];
    
    //others
    [self.engine setObject:[[NSBundle mainBundle] URLForResource:@"rePublishGuide" withExtension:@"png"] forKey:@"default_guide_imgUrl"];
}


#pragma mark - private methods -
/*
 *加载评论列表
 */
- (void)loadCommentList{
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithCapacity:10];
	[params setObject:@"status.getComment" forKey:@"method"];
    [params setObject:self.news.source_id forKey:@"status_id"];                 
    [params setObject:self.news.actor_id forKey:@"owner_id"];
    
    [params setObject:@"JSON" forKey:@"format"];
    [params setObject:@"1" forKey:@"page"];
    [params setObject:@"1000" forKey:@"count"];
    [params setObject:@"0" forKey:@"order"];        //升序排序
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
        }
    }
    
    return YES;
}


#pragma mark - RenrenDelegate -
-(void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse *)response{
	self.commentList=[RenRenManager resolveStatusCommentsForJSON:response];
    [self callWebViewJavaScriptForCommentList];
}

-(void)renren:(Renren *)renren requestFailWithError:(ROError *)error{
	[GlobalInstance showMessageBoxWithMessage:@"API调用失败"];
}

#pragma mark - WeiboDetailForRAndCDelegate -
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
            [commentParams setObject:[NSString stringWithFormat:@"转发%@的状态",self.news.name] forKey:@"showTitle"];
            [commentParams setObject:@"0" forKey:@"commentType"];				
            [commentParams setObject:[NSString stringWithFormat:@"转自%@:%@",self.news.name,self.news.message] forKey:@"sourceContent"];
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
	[commentParams release];
    
    UINavigationController *randcNavCtrller=[[UINavigationController alloc]initWithRootViewController:RandCCtrller];
    [RandCCtrller release];
    randcNavCtrller.modalTransitionStyle=UIModalTransitionStyleCoverVertical;    
	
	//弹出模式视图
    [self presentModalViewController:randcNavCtrller animated:YES];
    [randcNavCtrller release];
}

#pragma mark - rAndCDelegate -
/*
 *评论或转发成功
 */
- (void)rAndCSuccessfully{
    [self loadCommentList];
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
	NSMutableDictionary *commentParams=[[NSMutableDictionary alloc]init];
	[commentParams setObject:self.news.feed_type forKey:@"feedType"];
	[commentParams setObject:[NSString stringWithFormat:@"评论给%@",[self.selectedItem objectForKey:@"name"]] forKey:@"showTitle"];
	[commentParams setObject:self.news.source_id forKey:@"theSubjectId"];
	[commentParams setObject:self.news.actor_id forKey:@"ownerId"];
	[commentParams setObject:[self.selectedItem objectForKey:@"uniqueId"] forKey:@"rid"];
	[commentParams setObject:@"0" forKey:@"commentType"];					//暂时全部置为公开
	[commentParams setObject:@"" forKey:@"sourceContent"];					//回复不需要原文
	
	
	RenRenRePublishOrCommentController *rePublishOrCommentController=[[RenRenRePublishOrCommentController alloc]initWithNibName:@"RenRenRePublishOrCommentView" bundle:nil operateType:comment comeInParam:commentParams];
    rePublishOrCommentController.delegate=self;
	[commentParams release];
    
    UINavigationController *rePublishOrCommentNavigationController=[[UINavigationController alloc]initWithRootViewController:rePublishOrCommentController];
    [rePublishOrCommentController release];
    rePublishOrCommentNavigationController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;                          //底部滑入
    
	
	//弹出模式视图
    [self presentModalViewController:rePublishOrCommentNavigationController animated:YES];
    [rePublishOrCommentNavigationController release];

}


@end
