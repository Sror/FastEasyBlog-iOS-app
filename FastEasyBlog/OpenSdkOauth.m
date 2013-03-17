//
//  OpenSdkOauth.m
//  OpenSdkTest
//
//  Created by aine sun on 3/13/12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "OpenSdkOauth.h"
#import "Global.h"


/*
 * oauth2.0授权及调用api接口请求的base url
 */
static NSString *oauthRequestBaseURL = @"https://open.t.qq.com/cgi-bin/oauth2/";
static NSString *authPrefix = @"authorize";

/*
 * oauth2.0票据的key
 */
#define oauth2TokenKey @"access_token="

@implementation OpenSdkOauth

@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize redirectURI = _redirectURI;
@synthesize accessToken = _accessToken;
@synthesize accessSecret = _accessSecret;
@synthesize expireIn = _expireIn;
@synthesize openid = _openid;
@synthesize openkey = _openkey;
@synthesize oauthType = _oauthType;

@synthesize tencentWeiboDelegate;

#pragma -
#pragma mark init members

- (id)initAppKey:appKey
       appSecret:(NSString *)appSecret
{
	if (self=[super init]) 
	{
		[_appKey release];
		_appKey = [appKey copy];
		_appSecret = [appSecret copy];
		_redirectURI = [[NSString alloc] initWithString:[OpenSdkBase getRedirectUri]];
	}
	return self;
}

#pragma -
#pragma mark authorize in safari

- (BOOL)doSafariAuthorize:(BOOL)didOpenOtherApp
{
	BOOL didOpenAnotherApp = didOpenOtherApp;
	
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
																 _appKey, @"client_id",
																 @"token", @"response_type",
																 _redirectURI, @"redirect_uri",
																 @"2", @"wap",
																 nil];
	
	NSLog(@"appkey is %@", _appKey);
	NSString *authorizeURL = [oauthRequestBaseURL stringByAppendingString:authPrefix];
	NSLog(@"authorizeurl is %@", authorizeURL);
	
	// 先尝试从safari打开网页
	UIDevice *device = [UIDevice currentDevice];
	if ([device respondsToSelector:@selector(isMultitaskingSupported)] && [device isMultitaskingSupported]) 
	{
		if(!didOpenAnotherApp)
		{
			NSString *appUrl = [OpenSdkBase generateURL:authorizeURL params:params httpMethod:@"GET"];
			didOpenAnotherApp = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
		}
	}
	return didOpenAnotherApp;
}

#pragma -
#pragma mark authorize in webView
- (void) doWebViewAuthorize:(UIWebView *)webView {
	
	_webView = webView;
	
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
																 _appKey, @"client_id",
																 @"token", @"response_type",
																 @"2", @"wap",
																 _redirectURI, @"redirect_uri",
																 @"ios", @"appfrom",
																 nil];
	NSLog(@"appkey is %@", _appKey);
	NSString *authorizeURL = [oauthRequestBaseURL stringByAppendingString:authPrefix];
	
	NSString *loadingURL = [[OpenSdkBase generateURL:authorizeURL params:params httpMethod:nil] retain];
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loadingURL]];
    [loadingURL release];
	
	[webView loadRequest:request];
}

#pragma -
#pragma mark viewController method

- (void)loadView {
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	//__conn = new CIMCommonConnection() ;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	
	//delete __conn ;
}


- (void)dealloc {
	[tencentWeiboDelegate release];
	[super dealloc];
}

- (void) oauthDidSuccess:(NSString *)accessToken
            accessSecret:(NSString *)accessSecret
                  openid:(NSString *)openid
                 openkey:(NSString *)openkey
                expireIn:(NSString *)expireIn {
	self.accessToken = accessToken;
	self.accessSecret = accessSecret;
	self.openid = openid;
	self.openkey = openkey;
	self.expireIn = expireIn;
	
	if ([self.tencentWeiboDelegate respondsToSelector:@selector(oauthDidFinished:)]) {
		[self.tencentWeiboDelegate oauthDidFinished:self];
	}
	//[OpenSdkBase showMessageBox:@"登录成功！"];
}

- (void) oauthDidFail:(uint16_t)oauthType
              success:(BOOL)success
           netNotWork:(BOOL)netNotWork {
	//NSLog(@"oauth type is %d", oauthType);
//	if (oauthType == InAuth1 && success ) {
//		[OpenSdkBase showMessageBox:@"未获取到票据，授权失败，请认真检查keyWord是否正确"];
//	}
//	else if(oauthType == InWebView) {
//		if (success) {
//			[OpenSdkBase showMessageBox:@"未获取到票据，授权失败，请认真检查keyWord是否正确"];
//		}
//		else {
//			if (netNotWork) {
//				[OpenSdkBase showMessageBox:@"无网络连接，请设置网络"];
//			}
//			else {
//				[OpenSdkBase showMessageBox:@"授权失败，请认真检查appKey是否正确"];
//			}
//		}
//	}
//	else {
//		NSLog(@"oauth type is %@", oauthType);
//	}
	
	if ([self.tencentWeiboDelegate respondsToSelector:@selector(oauthDidFailed:)]) {
		[self.tencentWeiboDelegate oauthDidFailed:self];
	}
}

- (void) refuseOauth:(NSURL *)url {
	NSRange start = [[url absoluteString] rangeOfString:oauth2TokenKey];
	
	start = [[url absoluteString] rangeOfString:@"code="];
	if (start.location != NSNotFound) {
		NSString *code = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:@"code="];
		NSString *type = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:@"checkType="];
		NSLog(@"code is %@, type is %@", code, type);
		if ([code isEqualToString:@"101"] && [type isEqualToString:@"error"]) {
			
			NSLog(@"refuse to authorize");
			[OpenSdkBase showMessageBox:@"用户拒绝webView授权"];
		}
	}
}

/*
 *登出
 *added by:yh
 *date:12-06-30
 */
- (void) logout{
	self.accessToken = nil;
	self.accessSecret = nil;
	self.openid = nil;
	self.openkey = nil;
	self.expireIn = nil;
	
	//修改配置文件，清除相关配置
	[GlobalInstance writeConfigInfoToConfigFileWithValue:self.accessToken forKey:@"accessToken" forPlatform:TencentWeibo];
	[GlobalInstance writeConfigInfoToConfigFileWithValue:self.accessSecret forKey:@"accessSecret" forPlatform:TencentWeibo];
	[GlobalInstance writeConfigInfoToConfigFileWithValue:self.openid forKey:@"openid" forPlatform:TencentWeibo];
	[GlobalInstance writeConfigInfoToConfigFileWithValue:self.openkey forKey:@"openkey" forPlatform:TencentWeibo];
	[GlobalInstance writeConfigInfoToConfigFileWithValue:self.expireIn forKey:@"expireIn" forPlatform:TencentWeibo];
	
	//执行代理方法
	if ([self.tencentWeiboDelegate respondsToSelector:@selector(tencentWeiboDidlogout)]) {
		[self.tencentWeiboDelegate tencentWeiboDidlogout];
	}
}

@end
