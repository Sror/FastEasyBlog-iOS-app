//
//  PhotoDetailController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 10/28/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "PhotoDetailController.h"
#import "RenRenNews.h"
#import "RenRenManager.h"
#import "RenRenAttachment.h"
#import "RenRenSource.h"
#import "ICUTemplateMatcher.h"
#import "RenRenRePublishOrCommentController.h"

#define TEMPLATE_PATH [[NSBundle mainBundle] pathForResource:@"photoDetail" ofType:@"html"]

@interface PhotoDetailController ()

@property (nonatomic,retain) MGTemplateEngine *engine;

@property (nonatomic,retain) RenRenNews *news;
@property (nonatomic,retain) NSMutableArray *commentList;
@property (nonatomic,retain) NSDictionary *selectedItem;
@property (nonatomic,assign) BOOL isPublishedPhoto;
@property (nonatomic,assign) BOOL isSharedPhoto;

@end

@implementation PhotoDetailController

@synthesize engine=_engine;
@synthesize webView=_webView;
@synthesize news=_news;
@synthesize commentList;
@synthesize selectedItem;
@synthesize isPublishedPhoto;
@synthesize isSharedPhoto;

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
        
        isPublishedPhoto=([self.news.feed_type intValue]==30||[self.news.feed_type intValue]==31);
        isSharedPhoto=([self.news.feed_type intValue]==32||[self.news.feed_type intValue]==36);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:super.toolbar];
    [self.view addSubview:self.webView];
    
	if(isPublishedPhoto){
        self.navigationItem.title=[NSString stringWithFormat:@"%@上传的照片",self.news.name];
    }else if(isSharedPhoto){
        self.navigationItem.title=[NSString stringWithFormat:@"%@分享的照片",self.news.name];
    }
    
    [GlobalInstance showHUD:@"照片/图片加载中,请稍后..." andView:self.view andHUD:self.hud];
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
    [self.engine setObject:((RenRenAttachment*)[self.news.attachment objectAtIndex:0]).raw_src forKey:@"imgUrl"];
    [self.engine setObject:[RenRenManager resolveRenRenDate:self.news.update_time] forKey:@"pubDate"];
    NSString *comeFrom=(self.news.source.text||[self.news.source.text isNotEqualToString:@""])?self.news.source.text:@"网页";
    [self.engine setObject:comeFrom forKey:@"pubBy"];
    [self.engine setObject:self.news.title forKey:@"albumName"];
    
    //others
    [self.engine setObject:[[NSBundle mainBundle] URLForResource:@"rePublishGuide" withExtension:@"png"] forKey:@"default_guide_imgUrl"];
}


#pragma mark - private methods -
/*
 *加载评论列表
 */
- (void)loadCommentList{
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithCapacity:10];
	[params setObject:@"photos.getComments" forKey:@"method"];
    if (isPublishedPhoto) {
        [params setObject:self.news.actor_id forKey:@"uid"];
    }else if(isSharedPhoto){
        [params setObject:((RenRenAttachment*)[self.news.attachment objectAtIndex:0]).owner_id forKey:@"uid"];
    }
    
    [params setObject:((RenRenAttachment*)[self.news.attachment objectAtIndex:0]).media_id forKey:@"pid"];
    
    [params setObject:@"JSON" forKey:@"format"];
    [params setObject:@"1" forKey:@"page"];
    [params setObject:@"1000" forKey:@"count"];
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
	self.commentList=[RenRenManager resolvePhotoCommentsForJSON:response];
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
    [commentParams setObject:@"" forKey:@"rid"];
    
    switch (_operateType) {
        case republish:
            if(isPublishedPhoto){       //分享照片
                [commentParams setObject:[NSString stringWithFormat:@"分享%@的照片",self.news.name] forKey:@"showTitle"];
                [commentParams setObject:@"0" forKey:@"commentType"];			
                [commentParams setObject:@"" forKey:@"sourceContent"];
                [commentParams setObject:((RenRenAttachment*)[self.news.attachment objectAtIndex:0]).media_id forKey:@"theSubjectId"];
                [commentParams setObject:self.news.actor_id forKey:@"ownerId"];
            }else if(isSharedPhoto){
                [commentParams setObject:[NSString stringWithFormat:@"分享%@的照片",self.news.name] forKey:@"showTitle"];
                [commentParams setObject:@"0" forKey:@"commentType"];			
                [commentParams setObject:@"" forKey:@"sourceContent"];
                [commentParams setObject:self.news.actor_id forKey:@"ownerId"];
                [commentParams setObject:self.news.source_id forKey:@"theSubjectId"];

            }
            break;
            
        case comment:
            [commentParams setObject:[NSString stringWithFormat:@"评论给%@",self.news.name] forKey:@"showTitle"];
            [commentParams setObject:@"0" forKey:@"commentType"];					
            [commentParams setObject:@"" forKey:@"sourceContent"];
            [commentParams setObject:((RenRenAttachment*)[self.news.attachment objectAtIndex:0]).media_id forKey:@"theSubjectId"];
            
            if(isPublishedPhoto){
                [commentParams setObject:self.news.actor_id forKey:@"ownerId"];
            }else if(isSharedPhoto){
                [commentParams setObject:((RenRenAttachment*)[self.news.attachment objectAtIndex:0]).owner_id forKey:@"ownerId"];
            }
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
	//传递参数
	NSMutableDictionary *commentParams=[[NSMutableDictionary alloc]init];
	[commentParams setObject:self.news.feed_type forKey:@"feedType"];
	[commentParams setObject:[NSString stringWithFormat:@"评论给%@",[self.selectedItem objectForKey:@"name"]] forKey:@"showTitle"];
	[commentParams setObject:((RenRenAttachment*)[self.news.attachment objectAtIndex:0]).media_id forKey:@"theSubjectId"];
	[commentParams setObject:self.news.actor_id forKey:@"ownerId"];
	[commentParams setObject:[self.selectedItem objectForKey:@"uniqueId"] forKey:@"rid"];
	[commentParams setObject:@"0" forKey:@"commentType"];	//暂时全部置为公开
	[commentParams setObject:@"" forKey:@"sourceContent"];  //回复不需要原文
	
	
	RenRenRePublishOrCommentController *rePublishOrCommentController=[[RenRenRePublishOrCommentController alloc]initWithNibName:@"RenRenRePublishOrCommentView" bundle:nil operateType:comment comeInParam:commentParams];
    rePublishOrCommentController.delegate=self;
	[commentParams release];
    
    UINavigationController *rePublishOrCommentNavigationController=[[UINavigationController alloc]initWithRootViewController:rePublishOrCommentController];
    [rePublishOrCommentController release];
    rePublishOrCommentNavigationController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;                         //底部滑入
    
	
	//弹出模式视图
    [self presentModalViewController:rePublishOrCommentNavigationController animated:YES];
    [rePublishOrCommentNavigationController release];    
}

@end
