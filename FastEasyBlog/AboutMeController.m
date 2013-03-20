//
//  AboutMeControllerForTemp.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 11/10/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "AboutMeController.h"
#import "ICUTemplateMatcher.h"
#import "MyHomePageController.h"

#define TEMPLATE_PATH [[NSBundle mainBundle] pathForResource:@"aboutMe" ofType:@"html"] 

@interface AboutMeController ()

@property (nonatomic,retain) UIWebView *webView;
@property (nonatomic,retain) MGTemplateEngine *engine;

@end

@implementation AboutMeController

@synthesize webView=_webView;
@synthesize engine=_engine;

- (void)dealloc{
    [_webView release],_webView=nil;
    [_engine release],_engine=nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init{
    if (self=[super init]) {
        // Set up template engine with your chosen matcher.
        _engine = [[MGTemplateEngine templateEngine] retain];
        [self.engine setDelegate:self];
        [self.engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:self.engine]];
        
        _webView = [[UIWebView alloc] initWithFrame:
                    CGRectMake(0, 0, VIEWCONTENTWIDTH, VIEWCONTENTHEIGHT+44)];
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [GlobalInstance clearWebViewBackground:self.webView];
        self.webView.delegate = self;
    }
    
    return self;
}

- (void)loadView{
    UIView *tmpView=[[[UIView alloc]init]autorelease];
    self.view=tmpView;
    [self.view addSubview:self.webView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    super.bindCheckHandleDelegate=self;
    
	self.navigationItem.title=@"关于我";
    [self setLeftBarButtonForNavigationBar];
    
    [self initTemplate];
    [GlobalInstance showHUD:@"加载中,请稍后..." andView:self.view andHUD:self.hud];
	NSString *htmlStr = [self.engine processTemplateInFileAtPath:TEMPLATE_PATH withVariables:nil];
    [self.webView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle]bundleURL]];
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

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [self.webView stopLoading];
}

#pragma mark - private methods -
- (void)initTemplate{
    NSString *aboutMeBGImgPathStr=[[NSBundle mainBundle] pathForResource:@"aboutMe_bg"
                                                         ofType:@"png"];
    NSString *headImgPathStr=[[NSBundle mainBundle] pathForResource:@"me" 
                                                             ofType:@"png"];
    
    NSURL *headImgUrl=[[[NSURL alloc]initFileURLWithPath:
                        headImgPathStr]autorelease];
    NSURL *aboutMeUrl=[[[NSURL alloc]initFileURLWithPath:
                        aboutMeBGImgPathStr]autorelease];
    
    [self.engine setObject:[aboutMeUrl absoluteString] forKey:@"bgUrl"];
    [self.engine setObject:[headImgUrl absoluteString] forKey:@"headImgUrl"];
    [self.engine setObject:AppConfig(@"introduce_text") 
                    forKey:@"introduce"];
    
    [self.engine setObject:@"yanghua1127@gmail.com" forKey:@"email"];
    [self.engine setObject:@"@yanghua_kobe" forKey:@"weiboNick"];
    [self.engine setObject:@"http://blog.csdn.net/yanghua_kobe" 
                    forKey:@"homePage"];
}

/*
 *为导航栏设置左侧的自定义返回按钮
 */
-(void)setLeftBarButtonForNavigationBar{
//	UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//	btn.frame=CGRectMake(0, 0, 45, 45);
//	[btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//	[btn addTarget:self action:@selector(back_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                 frame:CGRectMake(0, 0, 45, 45)
                                               imgName:@"back.png"
                                           eventTarget:self
                                           touchUpFunc:@selector(back_TouchUpInside:)
                                         touchDownFunc:nil];
	
	UIBarButtonItem *backBarItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
	self.navigationItem.leftBarButtonItem=backBarItem;
	[backBarItem release];
}

- (void)back_TouchUpInside:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - click actions -
- (void)sendEmail{
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
    mailer.mailComposeDelegate=self;
    [mailer setToRecipients:[[[NSArray alloc]initWithObjects:@"yanghua1127@gmail.com", nil]autorelease]];
    [mailer setSubject:@"建议与反馈"];
    [mailer setMessageBody:AppConfig(@"email_text") isHTML:NO];
    [self presentModalViewController:mailer animated:YES];
    [mailer release];
}

- (void)weiboAtMe{
    //TODO: @yanghua_kobe in sina weibo and tencent weibo
}

- (void)homePage{
    MyHomePageController *myHomePageCtrller=[[MyHomePageController alloc]initWithNibName:@"MyHomePageView" bundle:nil];
    UINavigationController *myHomePageNavCtrller=[[UINavigationController alloc]initWithRootViewController:myHomePageCtrller];
    [myHomePageCtrller release];
    myHomePageNavCtrller.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:myHomePageNavCtrller animated:YES];
    [myHomePageNavCtrller release];
}

#pragma mark - UIWebView Delegate -
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [GlobalInstance hideHUD:self.hud];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:[@"FEB" lowercaseString]]) {
        
        NSString *cmdName=(NSString *)[components objectAtIndex:1];
        if([cmdName isEqualToString:@"sendEmail"]) {
            [self sendEmail];
        }else if([cmdName isEqualToString:@"weiboAtMe"]){
            [self weiboAtMe];
        }else if([cmdName isEqualToString:@"homePage"]){
            [self homePage];
        }
        return NO;
    }
    return YES;
}

#pragma mark - others -
-(BOOL)checkBindInfo{
    return true;
}

#pragma mark - mail delegate methods -
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
