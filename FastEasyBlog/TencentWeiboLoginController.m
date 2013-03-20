    //
//  TencentWeiboLoginController.m
//  FastEasyBlog
//
//  Created by svp on 28.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "TencentWeiboLoginController.h"
#import "TencentWeiboUserInfo.h"
#import "Global.h"

/*
 * 获取oauth2.0票据的key
 */
#define oauth2TokenKey @"access_token="
#define oauth2OpenidKey @"openid="
#define oauth2OpenkeyKey @"openkey="
#define oauth2ExpireInKey @"expire_in="

@interface TencentWeiboLoginController()

//为导航栏设置左侧的自定义返回按钮
-(void)setLeftBarButtonForNavigationBar;

@end

@implementation TencentWeiboLoginController

@synthesize delegate;

- (void)dealloc {
	[_loginWebView release],_loginWebView=nil;
	[_openSdkOauth release];
	[super dealloc];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    [self setLeftBarButtonForNavigationBar];
	self.navigationItem.title=@"腾讯微博绑定界面";
    
	//设置当前登录页面的代理为当前的controller
	self.loginWebView.delegate=self;
	
	_openSdkOauth =[[OpenSdkOauth alloc]initAppKey:[OpenSdkBase getAppKey] appSecret:[OpenSdkBase getAppSecret]];
    _openSdkOauth.tencentWeiboDelegate=self;
    
	
	//保存(appKey/appSecret)
	[GlobalInstance writeConfigInfoToConfigFileWithValue:[OpenSdkBase getAppKey] forKey:@"appKey" forPlatform:TencentWeibo];
	[GlobalInstance writeConfigInfoToConfigFileWithValue:[OpenSdkBase getAppSecret] forKey:@"appSecret" forPlatform:TencentWeibo];
	
	[_openSdkOauth doWebViewAuthorize:self.loginWebView];
	if (([OpenSdkBase getAppKey]==(NSString *)[NSNull null])||([OpenSdkBase getAppKey].length==0)) {
		[OpenSdkBase showMessageBox:@"client_id为空，请到OpenSdkBase中填写您应用的appKey"];
	}
}


// Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
     // Return YES for supported orientations.
     return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
 * 当前网页视图被指示载入内容时得到通知，返回yes开始进行加载
 */
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	NSURL* url = request.URL;
	
	NSLog(@"response url is %@", url);
	NSRange start = [[url absoluteString] rangeOfString:oauth2TokenKey];
	
	//如果找到tokenkey,就获取其他key的value值
	if (start.location != NSNotFound)
	{
		NSString *accessToken = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2TokenKey];
		NSString *openId = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenidKey];
		NSString *openkey = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenkeyKey];
		NSString *expireIn = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2ExpireInKey];
		
		NSDate *expirationDate =nil;
		if (_openSdkOauth.expireIn != nil) {
			int expVal = [_openSdkOauth.expireIn intValue];
			if (expVal == 0) {
				expirationDate = [NSDate distantFuture];
			} else {
				expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
			} 
		} 
		
		NSLog(@"token is %@, openid is %@, expireTime is %@", accessToken, openId, expirationDate);
		
		[GlobalInstance writeConfigInfoToConfigFileWithValue:accessToken
                                                      forKey:@"accessToken"
                                                 forPlatform:TencentWeibo];
		[GlobalInstance writeConfigInfoToConfigFileWithValue:_openSdkOauth.accessSecret
                                                      forKey:@"accessSecret"
                                                 forPlatform:TencentWeibo];
		[GlobalInstance writeConfigInfoToConfigFileWithValue:openId
                                                      forKey:@"openId"
                                                 forPlatform:TencentWeibo];
		[GlobalInstance writeConfigInfoToConfigFileWithValue:openkey
                                                      forKey:@"openKey"
                                                 forPlatform:TencentWeibo];
		[GlobalInstance writeConfigInfoToConfigFileWithValue:expirationDate
                                                      forKey:@"expireIn"
                                                 forPlatform:TencentWeibo];
		
		if ((accessToken == (NSString *) [NSNull null]) || (accessToken.length == 0) 
				|| (openId == (NSString *) [NSNull null]) || (openkey.length == 0) 
				|| (openkey == (NSString *) [NSNull null]) || (openId.length == 0)) {
			[_openSdkOauth oauthDidFail:InWebView success:YES netNotWork:NO];
		}
		else {
			[_openSdkOauth oauthDidSuccess:accessToken accessSecret:nil openid:openId openkey:openkey expireIn:expireIn];
		}
		self.loginWebView.delegate = nil;
		[self.loginWebView setHidden:YES];
		
		return NO;
	}
	else
	{
		start = [[url absoluteString] rangeOfString:@"code="];
		if (start.location != NSNotFound) {
			[_openSdkOauth refuseOauth:url];
		}
	}
	return YES;
}

/*
 * 当网页视图结束加载一个请求后得到通知
 */
- (void) webViewDidFinishLoad:(UIWebView *)webView {
	NSString *url = self.loginWebView.request.URL.absoluteString;
	NSLog(@"web view finish load URL %@", url);
}

/*
 * 页面加载失败时得到通知，可根据不同的错误类型反馈给用户不同的信息
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"no network:errcode is %d, domain is %@", error.code, error.domain);
	
	if (!([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)) {
		[_openSdkOauth oauthDidFail:InWebView success:NO netNotWork:YES];
		[self.loginWebView removeFromSuperview];
	}
}


#pragma mark -
#pragma mark implement delegates (TencentWeibo)
/*
 *授权失败
 */
-(void)oauthDidFailed:(OpenSdkOauth *)_openSdkOauth{
	[GlobalInstance showMessageBoxWithMessage:@"授权失败"];
}

/*
 *授权成功
 */
-(void)oauthDidFinished:(OpenSdkOauth *)_openSdkOauth{
	[self dismissViewControllerAnimated:YES completion:^{
       //刷新父页面的评论列表
        if ([self.delegate respondsToSelector:@selector(tencentWeiboLoginControllerDismissed)]) {
            [self.delegate tencentWeiboLoginControllerDismissed];
        }
    }];
}


#pragma mark -
#pragma mark private method
/*
 *为导航栏设置左侧的自定义返回按钮
 */
-(void)setLeftBarButtonForNavigationBar{
	UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame=CGRectMake(0, 0, 45, 45);
	[btn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(closeButton_touchUpInside) forControlEvents:UIControlEventTouchUpInside];
	[btn addTarget:self action:@selector(closeButton_touchDown) forControlEvents:UIControlEventTouchDown];		//按下替换为高亮图片
	
	UIBarButtonItem *backBarItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
	self.navigationItem.leftBarButtonItem=backBarItem;
	[backBarItem release];
}

-(void)closeButton_touchUpInside{
    UIButton *btn=(UIButton*)self.navigationItem.leftBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
	
    [self dismissModalViewControllerAnimated:YES];
}

-(void)closeButton_touchDown{
	UIButton *btn=(UIButton*)self.navigationItem.leftBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"closeBtn_highlight.png"] forState:UIControlStateNormal];
}


@end
