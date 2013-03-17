//
//  FeatureListViewController.m
//  MSFTest
//
//  Created by Ruifan Yuan on 6/14/11.
//  Copyright 2011 . All rights reserved.
//

#import "FeatureListViewController.h"

/*
 * Todo: 请填写您需要的登录授权方式，目前支持webview和浏览器两种方式，分别为InWebView和InSafari，其中浏览器方式需要手动获取授权码，不建议使用
 */
#define oauthMode InWebView

/*
 * 获取oauth1.0票据的key
 */
#define oauth1TokenKey @"AccessToken"
#define oauth1SecretKey @"AccessTokenSecret"

/*
 * 获取oauth2.0票据的key
 */
#define oauth2TokenKey @"access_token="
#define oauth2OpenidKey @"openid="
#define oauth2OpenkeyKey @"openkey="
#define oauth2ExpireInKey @"expire_in="

@interface FeatureListViewController (TestMethods)
- (void) testLoginWithMicroblogAccount;
@end

#pragma mark -
#pragma mark Test function definitions
@implementation FeatureListViewController (TestMethods)

/*
 * 初始化titlelabel和webView
 */
- (void) webViewShow {
    
    CGFloat titleLabelFontSize = 14;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.text = @"微博登录";
    _titleLabel.backgroundColor = [UIColor lightGrayColor];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:titleLabelFontSize];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleBottomMargin;
    _titleLabel.textAlignment = UITextAlignmentCenter;
    
    [self.view addSubview:_titleLabel];
    
    [_titleLabel sizeToFit];
    CGFloat innerWidth = self.view.frame.size.width;
    _titleLabel.frame = CGRectMake(
                                   0,
                                   0,
                                   innerWidth,
                                   _titleLabel.frame.size.height+6);

    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    _webView = [[UIWebView alloc] initWithFrame:bounds];
    
    _webView.scalesPageToFit = YES;
    _webView.userInteractionEnabled = YES;
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:_webView];
}

/*
 * 采用两种不同方式进行登录授权,支持webview和浏览器两种方式
 */
- (void) testLoginWithMicroblogAccount {
    
    uint16_t authorizeType = oauthMode; 

    _OpenSdkOauth = [[OpenSdkOauth alloc] initAppKey:[OpenSdkBase getAppKey] appSecret:[OpenSdkBase getAppSecret]];
    _OpenSdkOauth.oauthType = authorizeType;
    
    BOOL didOpenOtherApp = NO;
    switch (authorizeType) {
        case InSafari:  //浏览器方式登录授权，不建议使用
        {
            didOpenOtherApp = [_OpenSdkOauth doSafariAuthorize:didOpenOtherApp];
            break;
        }
        case InWebView:  //webView方式登录授权，采用oauth2.0授权鉴权方式
        {
            if(!didOpenOtherApp){
                if (([OpenSdkBase getAppKey] == (NSString *)[NSNull null]) || ([OpenSdkBase getAppKey].length == 0)) {
                    NSLog(@"client_id is null");
                    [OpenSdkBase showMessageBox:@"client_id为空，请到OPenSdkBase中填写您应用的appkey"];
                }
                else
                {
                    [self webViewShow];
                }
                
                [_OpenSdkOauth doWebViewAuthorize:_webView];
                
                break;
            }
        }
        default:
            break;
    }
}

@end

#pragma mark -
#pragma mark Initialization
@implementation FeatureListViewController

@synthesize lastIndexPath = _lastIndexPath;

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
		featureList = [[NSArray arrayWithObjects:@"微博登录", @"发表微博", @"获取用户信息", @"发表带图片微博", @"我收听的人列表", @"我的收听列表", nil] retain];
    }
    
    return self;
}

#pragma mark -
#pragma mark View lifecycle
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return true; // supports all orientations
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return featureList.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	int section = [indexPath indexAtPosition:0];
	int row = [indexPath indexAtPosition:1];
    int oldRow = [self.lastIndexPath row];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	if(section == 0) {
		// we have only a single section
		cell.textLabel.text = [featureList objectAtIndex:row];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
        if (row == oldRow && self.lastIndexPath != nil) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
	}
    
    return cell;
}

/*
 * 设置imagePickerController为当前视图控制器
 */
- (void) insertImage {
    
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentModalViewController:imagePickerController animated:YES];
    [imagePickerController release];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	int section = [indexPath indexAtPosition:0];
	int row = [indexPath indexAtPosition:1];
    int oldRow = (self.lastIndexPath != nil)?[self.lastIndexPath row]:-1;
    
	if(0 == section) {
        if(0 != row){
            
            _OpenApi = [[OpenApi alloc] initForApi:_OpenSdkOauth.appKey appSecret:_OpenSdkOauth.appSecret accessToken:_OpenSdkOauth.accessToken accessSecret:_OpenSdkOauth.accessSecret openid:_OpenSdkOauth.openid oauthType:_OpenSdkOauth.oauthType];
            
            NSLog(@"appkey:%@,appsecret:%@,token:%@,tokenkey:%@,openid:%@", _OpenSdkOauth.appKey, _OpenSdkOauth.appSecret, _OpenSdkOauth.accessToken,_OpenSdkOauth.accessSecret, _OpenSdkOauth.openid);
        }
		switch (row) {
                
			case 0:
            { 
				[self testLoginWithMicroblogAccount]; //登录授权
				break;
            }
                
            case 1:
            {
                //Todo：请填写调用t/add发表微博接口所需要的参数值，具体请参考http://wiki.open.t.qq.com/index.php/API文档
                NSString *weiboContent = @"aaaaaaaa";  
                [_OpenApi publishWeibo:weiboContent jing:@"112.123456" wei:@"33.111252" format:@"json" clientip:@"CLIENTIP" syncflag:@"0"]; //发表微博
                break;
            }
                
            case 2:
            {
                //Todo:请填写调用user/info获取用户资料接口所需的参数值，具体请参考http://wiki.open.t.qq.com/index.php/API文档
                [_OpenApi getUserInfo:@"xml"];  //获取用户信息
                break;
            }
        
            case 3:
            {
                [self insertImage];  //发表带图片微博，先设置imagePickerController为当前视图控制器，然后在委托函数中调用发表带图片微博的接口
                break;
            }
                
            case 4:
            { 
                //Todo:请填写调用friends/idollist拉取我收听的人列表接口所需的参数值，具体请参考http://wiki.open.t.qq.com/index.php/API文档
                NSInteger pageCount = 5;  //希望拉取的页数
                [_OpenApi getMyIdollist:@"xml" reqnum:@"3" startIndex:@"2" install:@"0" pageCount:pageCount];  //拉取偶像列表
                break;
            }
            case 5:
            {
                //Todo:请填写调用friends/fanslist拉取我的听众列表接口所需的参数值，具体请参考http://wiki.open.t.qq.com/index.php/API文档
                [_OpenApi getMyFanslist:@"xml" reqnum:@"1" startIndex:@"1" mode:@"1" install:@"0"];  //拉取粉丝列表
                break;
            }
			default:
				break;
		}
	}
    if (row != oldRow) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.lastIndexPath = indexPath;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma -
#pragma mark UIImagePickerControllerDelegate methods

/*
 * 从PhotoLibrary选择要发表的图片后被调用
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissModalViewControllerAnimated:YES];
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
	NSString *filePath = [NSTemporaryDirectory() stringByAppendingFormat:@"tmp.png"];
    NSLog(@"filename is %@", filePath);

    [UIImageJPEGRepresentation(image, 0) writeToFile:filePath atomically:YES];
    
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    NSLog(@"imageData size in picker:%d", [imageData length]);
    
    _publishParams = [NSMutableDictionary dictionary];
    
    //Todo：请填写调用t/add_pic发表带图片微博接口所需的参数值，具体请参考http://wiki.open.t.qq.com/index.php/API文档
    NSString *weiboContent = @"aa";  //Todo：微博内容
    //发表带图片微博
    [_OpenApi publishWeiboWithImage:filePath weiboContent:weiboContent jing:@"112.123456" wei:@"33.111252" format:@"xml" clientip:@"CLIENTIP" syncflag:@"1"];  
}

/*
 * 取消选择的图片后被调用
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
	[picker dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
    [_webView release];
    [featureList release];
    [_lastIndexPath release];
    [_OpenApi release];
    [_OpenSdkOauth release];
    [super dealloc];
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
        NSString *openid = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenidKey];
        NSString *openkey = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenkeyKey];
		NSString *expireIn = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2ExpireInKey];
        
		NSDate *expirationDate =nil;
		if (_OpenSdkOauth.expireIn != nil) {
			int expVal = [_OpenSdkOauth.expireIn intValue];
			if (expVal == 0) {
				expirationDate = [NSDate distantFuture];
			} else {
				expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
			} 
		} 
        
        NSLog(@"token is %@, openid is %@, expireTime is %@", accessToken, openid, expirationDate);
        
        if ((accessToken == (NSString *) [NSNull null]) || (accessToken.length == 0) 
            || (openid == (NSString *) [NSNull null]) || (openkey.length == 0) 
            || (openkey == (NSString *) [NSNull null]) || (openid.length == 0)) {
            [_OpenSdkOauth oauthDidFail:InWebView success:YES netNotWork:NO];
        }
        else {
            [_OpenSdkOauth oauthDidSuccess:accessToken accessSecret:nil openid:openid openkey:openkey expireIn:expireIn];
        }
        _webView.delegate = nil;
        [_webView setHidden:YES];
        [_titleLabel setHidden:YES];
        
		return NO;
	}
	else
	{
        start = [[url absoluteString] rangeOfString:@"code="];
        if (start.location != NSNotFound) {
            [_OpenSdkOauth refuseOauth:url];
        }
	}
    return YES;
}

/*
 * 当网页视图结束加载一个请求后得到通知
 */
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    NSString *url = _webView.request.URL.absoluteString;
    NSLog(@"web view finish load URL %@", url);
}

/*
 * 页面加载失败时得到通知，可根据不同的错误类型反馈给用户不同的信息
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"no network:errcode is %d, domain is %@", error.code, error.domain);
    
    if (!([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)) {
        [_OpenSdkOauth oauthDidFail:InWebView success:NO netNotWork:YES];
        [_webView removeFromSuperview];
        [_titleLabel removeFromSuperview];
	}
}

@end

