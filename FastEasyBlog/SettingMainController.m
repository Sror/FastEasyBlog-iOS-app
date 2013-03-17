//
//  SettingMainController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-10.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import "SettingMainController.h"
#import "AboutFastEasyBlogController.h"
#import "AboutMeController.h"
#import "ShareAndBindTableViewCell.h"
#import "TencentWeiboManager.h"
#import "TencentWeiboLoginController.h"
#import "TencentWeiboUserInfo.h"
#import "RenRenManager.h"
#import "RenRenUserInfo.h"
#import "SinaWeiboManager.h"
#import "SinaWeiboUser.h"
#import "OpenApi.h"
#import "FontSettingController.h"

#define RENRENHEADIMGKEY @"renren_headImg_key"
#define SINAWEIBOHEADIMGKEY @"sina_headImg_key"
#define TENCENTWEIBOHEADIMGKEY @"tencent_headImg_key"

@interface SettingMainController()

//加載tableview的數據源
- (void)loadTableViewDataSource;

//设置导航栏左侧刷新按钮
-(void)setLeftBarButtonForNavigationBar;

//获取当前绑定用户的头像(人人)
-(void)loadCurrentAuthorizedUserHeadImgUrlForRenRen;

//获取当前绑定用户的头像(新浪)
-(void)loadCurrentAuthorizedUserHeadImgUrlForSinaWeibo;

//获取当前绑定用户的头像(腾讯)
-(void)loadCurrentAuthorizedUserHeadImgUrlForTencentWeibo;

//下载头像
- (void)startIconDownload:(NSString*)headurl
                   forKey:(NSString*)key;

@end

@implementation SettingMainController

@synthesize settingTableView,
			dataSource,
			platformArray,
			platformWithlogoDictionary,
			weiBoEngine,
			sinaWeiboCell,
			tencentWeiboCell,
			renrenCell,
			renrenUserInfo,
			sinaweiboUserInfo,
			tencentweiboUserInfo,
			downLoaderForRenRen,
			downLoaderForSinaWeibo,
			downLoaderForTencentWeibo;

- (void)dealloc{
    [settingTableView release],settingTableView=nil;
    [dataSource release],dataSource=nil;
    [platformArray release],platformArray=nil;
    [platformWithlogoDictionary release],platformWithlogoDictionary=nil;
    [weiBoEngine release],weiBoEngine=nil;
    [sinaWeiboCell release],sinaWeiboCell=nil;
    [tencentWeiboCell release],tencentWeiboCell=nil;
    [renrenCell release],renrenCell=nil;
	[renrenUserInfo release],renrenUserInfo=nil;
	[sinaweiboUserInfo release],sinaweiboUserInfo=nil;
	[tencentweiboUserInfo release],tencentweiboUserInfo=nil;
	[downLoaderForRenRen release],downLoaderForRenRen=nil;
    [downLoaderForSinaWeibo release],downLoaderForSinaWeibo=nil;
	[downLoaderForTencentWeibo release],downLoaderForTencentWeibo=nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.weiBoEngine=[SinaWeiboManager initWBEngine];
        [self.weiBoEngine setRootViewController:self];
        [self.weiBoEngine setDelegate:self];
        [self.weiBoEngine setRedirectURI:@"http://"];
        [self.weiBoEngine setIsUserExclusive:NO];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"设置";
    self.settingTableView.dataSource=self;
    self.settingTableView.delegate=self;
    
    [self setLeftBarButtonForNavigationBar];
    
    [self loadTableViewDataSource];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.settingTableView=nil;
    self.dataSource=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - table view delegate and datasource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"分享与绑定(点击单元格完成操作)";
            
        case 1:
            return @"字体与颜色";
            
        case 2:
            return @"按键与音效";
            
        default:
            return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [self.platformArray count];
        case 1:
            return 1;
        case 2:
            return 1;
        case 3:
            return [self.dataSource count];
        default:
            return 0;
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{    
    switch (indexPath.section) {
        case 0:                     //bind and share
        {
            static NSString *platformTbViewCellIdentifier=@"platformTbViewCellIdentifier";
            ShareAndBindTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:platformTbViewCellIdentifier];
            if (!cell) {
                cell=[[[ShareAndBindTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:platformTbViewCellIdentifier]autorelease];
            }
            
            cell.platformName=[self.platformArray objectAtIndex:indexPath.row];
            if ([cell.platformName isEqualToString:@"新浪微博"]) {
                cell.bindOrNot=[SinaWeiboManager isBoundToApplication]?@"已绑定":@"未绑定";
                cell.headImg=fileExistsAtPath(SINAWEIBOUSERHEADIMGPATH)?[UIImage imageWithData:[NSData dataWithContentsOfFile:SINAWEIBOUSERHEADIMGPATH]]:[UIImage imageNamed:[self.platformWithlogoDictionary objectForKey:cell.platformName]];
            }else if([cell.platformName isEqualToString:@"腾讯微博"]){
                cell.bindOrNot=[TencentWeiboManager isBoundToApplication]?@"已绑定":@"未绑定";
                cell.headImg=fileExistsAtPath(TENCENTWEIBOUSERHEADIMGPATH)?[UIImage imageWithData:[NSData dataWithContentsOfFile:TENCENTWEIBOUSERHEADIMGPATH]]:[UIImage imageNamed:[self.platformWithlogoDictionary objectForKey:cell.platformName]];
            }else if([cell.platformName isEqualToString:@"人人网"]){
                cell.bindOrNot=[RenRenManager isBoundToApplication]?@"已绑定":@"未绑定";
                cell.headImg=fileExistsAtPath(RENRENUSERHEADIMGPATH)?[UIImage imageWithData:[NSData dataWithContentsOfFile:RENRENUSERHEADIMGPATH]]:[UIImage imageNamed:[self.platformWithlogoDictionary objectForKey:cell.platformName]];
            }
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            
            break;
            
        case 1:                 //fonts and colors
        {
            static NSString *fontsAndColorsCellIdentifier=@"fontsAndColorsCellIdentifier";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:fontsAndColorsCellIdentifier];
            if (!cell) {
                cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fontsAndColorsCellIdentifier]autorelease];
            }
            cell.textLabel.text=@"字体设置";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
            break;
            
        case 2:                 //audio
        {
            static NSString *fontsAndColorsCellIdentifier=@"audioCellIdentifier";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:fontsAndColorsCellIdentifier];
            if (!cell) {
                cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fontsAndColorsCellIdentifier]autorelease];
            }
            cell.textLabel.text=@"音效开关";
            UISwitch *switchView=[[[UISwitch alloc]init]autorelease];
            [switchView addTarget:self action:@selector(UISwitch_ValueChanged:) forControlEvents:UIControlEventValueChanged];
            [switchView setOn:[AppConfig(@"isAudioOpen") boolValue]];
            cell.accessoryView=switchView;
            return cell;
        }
            break;
            
        case 3:                 //others
        {
            static NSString *settingTableViewCellIdentifier=@"settingTableViewCellIdentifier";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:settingTableViewCellIdentifier];
            if (!cell) {
                cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingTableViewCellIdentifier]autorelease];
            }
            cell.textLabel.text=[self.dataSource objectAtIndex:indexPath.row];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:                 //绑定－平台
        {
            ShareAndBindTableViewCell *selectedCell=(ShareAndBindTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            NSString *item=[self.platformArray objectAtIndex:indexPath.row];
            if ([item isEqualToString:@"新浪微博"]) {
                self.sinaWeiboCell=selectedCell;
                BOOL isBound=[SinaWeiboManager isBoundToApplication];
                if (isBound) {
                    [self.weiBoEngine logOut];
                }else {
                    [self.weiBoEngine logIn];
                }
            }else if([item isEqualToString:@"腾讯微博"]){
                self.tencentWeiboCell=selectedCell;
                BOOL isBound=[TencentWeiboManager isBoundToApplication];
                if (isBound) {
                    [TencentWeiboManager logOut];
                    //删除头像
                    if (fileExistsAtPath(IMAGEDIRECTORYPATH)&&fileExistsAtPath([IMAGEDIRECTORYPATH stringByAppendingPathComponent:TENCENTWEIBO_USER_HEADIMAGE])) {
                        removerAtItem(TENCENTWEIBOUSERHEADIMGPATH);
                    }
					self.tencentWeiboCell.headImg=[UIImage imageNamed:@"tencent_logo_64X64.png"];
					self.tencentWeiboCell.bindOrNot=@"未绑定";
                }else {
					TencentWeiboLoginController *tencentWeiboLoginCtrller=[[TencentWeiboLoginController alloc]initWithNibName:@"TencentWeiboLoginView" bundle:nil];
					tencentWeiboLoginCtrller.delegate=self;
					UINavigationController *navCtrller=[[UINavigationController alloc]initWithRootViewController:tencentWeiboLoginCtrller];
					[tencentWeiboLoginCtrller release];
					navCtrller.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
					[self presentModalViewController:navCtrller animated:YES];
					[navCtrller release];
                }
            }else if([item isEqualToString:@"人人网"]){
                self.renrenCell=selectedCell;
                BOOL isBound=[RenRenManager isBoundToApplication];
                if (isBound) {		//如原来已绑定则解除绑定
                    [[Renren sharedRenren]logout:self];
                }else {
                    NSArray *permissionArray=[RenRenManager getAuthorizedPermissionList];
                    [[Renren sharedRenren]authorizationWithPermisson:permissionArray andDelegate:self];
                }
                
            }
        }
            
            break;
            
        case 1:
        {
            UIViewController *subController=nil;
            subController=[[FontSettingController alloc]initWithNibName:@"FontSettingView" bundle:nil];
            [self.navigationController pushViewController:subController animated:YES];
            [subController release];
        }
            break;
            
        case 3:
        {
            NSString *item=[self.dataSource objectAtIndex:indexPath.row];
            UIViewController *subController=nil;
            if (item==@"关于快易博") {
                subController=[[AboutFastEasyBlogController alloc]initWithNibName:@"AboutFEBView" bundle:nil];
            }else if(item==@"关于我"){
                subController=[[AboutMeController alloc]init];
            }else if(item==@"帮忙评个分吧"){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=554504019"]];
                return;
            }
            else {
                subController=[[UIViewController alloc]init];
            }
            [self.navigationController pushViewController:subController animated:YES];
            [subController release];
        }
            
            break;
            
        default:
            break;
    }
    
    [self.settingTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - private method -
/*
 *为导航栏设置右侧的自定义按钮
 */
-(void)setLeftBarButtonForNavigationBar{
	UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame=CGRectMake(10,0,45,45);
	[btn setBackgroundImage:[UIImage imageNamed:@"homePageBtn.png"] forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(homePageBtn_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	[btn addTarget:self action:@selector(homePageBtn_TouchDown:) forControlEvents:UIControlEventTouchDown];
	UIBarButtonItem *menuBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
	self.navigationItem.leftBarButtonItem=menuBtn;
	[menuBtn release];
}

-(void)homePageBtn_TouchDown:(id)sender{
	UIButton *btn=(UIButton*)self.navigationItem.rightBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"homePageBtn_highlight.png"] forState:UIControlStateNormal];
}

-(void)homePageBtn_TouchUpInside:(id)sender{
    //移除高亮效果
	UIButton *btn=(UIButton*)self.navigationItem.rightBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"homePageBtn.png"] forState:UIControlStateNormal];
    
    [self dismissModalViewControllerAnimated:YES];
    
}


/*
 *加載tableview的數據源
 */
- (void)loadTableViewDataSource{
    NSArray *tmpArray=[[NSArray alloc]initWithObjects:@"关于快易博",@"关于我",@"帮忙评个分吧",nil];
    self.dataSource=tmpArray;
    [tmpArray release];
    //平台
    NSArray *tmpPlatformArray=[[NSArray alloc]initWithObjects:@"新浪微博",@"腾讯微博",@"人人网", nil];
    self.platformArray=tmpPlatformArray;
    [tmpPlatformArray release];
    NSArray *tmpPlatformLogoArray=[[NSArray alloc]initWithObjects:
                                   @"sina_logo_64X64.png",
                                   @"tencent_logo_64X64.png",
                                   @"renren_logo_64X64.png",nil];
    
    //平台与logo
    NSDictionary *tmpPlatformWithlogoDictionary=[[NSDictionary alloc]initWithObjects:tmpPlatformLogoArray forKeys:self.platformArray];
    [tmpPlatformLogoArray release];
    self.platformWithlogoDictionary=tmpPlatformWithlogoDictionary;
    [tmpPlatformWithlogoDictionary release];
}

//获取当前绑定用户的头像
- (void)loadCurrentAuthorizedUserHeadImgUrlForRenRen{
	NSMutableDictionary *params=[NSMutableDictionary dictionaryWithCapacity:10];
	[params setObject:@"users.getInfo" forKey:@"method"];
	[params setObject:@"JSON" forKey:@"format"];
	[[Renren sharedRenren]requestWithParams:params andDelegate:self];
}

//获取当前绑定用户的头像
-(void)loadCurrentAuthorizedUserHeadImgUrlForSinaWeibo{
	NSString *uid=self.weiBoEngine.userID;
	
	NSDictionary *requestParam=[[NSDictionary alloc]initWithObjectsAndKeys:uid,@"uid", nil];
	
	[self.weiBoEngine loadRequestWithMethodName:@"users/show.json"
                           httpMethod:@"GET"
                               params:requestParam
                         postDataType:kWBRequestPostDataTypeNone
                     httpHeaderFields:nil];
					 
	[requestParam release];
}

/*
 *获取当前绑定用户的头像(腾讯)
 */
-(void)loadCurrentAuthorizedUserHeadImgUrlForTencentWeibo{
	OpenApi *myApi=[TencentWeiboManager getOpenApi];
    myApi.delegate=self;
    [myApi loadCurrentAuthorizedUserInfo];
}

-(void)UISwitch_ValueChanged:(id)sender{
    UISwitch *s=(UISwitch*)sender;
    BOOL isOpen=s.on;
    [[FEBAppConfig sharedAppConfig] setValue:[NSNumber numberWithBool:isOpen] 
                                      forKey:@"isAudioOpen"];
}

#pragma mark - about head image -
- (void)startIconDownload:(NSString*)headurl
                   forKey:(NSString*)key{
    IconDownloader *tmpDownLoader=[[IconDownloader alloc]init];
	tmpDownLoader.imgKey=key;
    tmpDownLoader.imgUrl=headurl;
    tmpDownLoader.imgHeight=32.0f;
    tmpDownLoader.imgWidth=32.0f;
    tmpDownLoader.indexPathInTableView=nil;
    tmpDownLoader.delegate=self;
    [tmpDownLoader startDownload];
	if([key isEqualToString:RENRENHEADIMGKEY]){
		self.downLoaderForRenRen=tmpDownLoader;
	}else if([key isEqualToString:SINAWEIBOHEADIMGKEY]){
		self.downLoaderForSinaWeibo=tmpDownLoader;
	}else if([key isEqualToString:TENCENTWEIBOHEADIMGKEY]){
		self.downLoaderForTencentWeibo=tmpDownLoader;
	}
	
    
    [tmpDownLoader release];
}

/*
 *下载完成之后的回调方法(头像下载成功后保存至文件系统)
 */
-(void)appImageDidLoad:(NSIndexPath *)indexPath
                forKey:(NSString*)imgKey{
    if (!fileExistsAtPath(IMAGEDIRECTORYPATH)) {     //目录存在，直接保存
        [[NSFileManager defaultManager] createDirectoryAtPath:IMAGEDIRECTORYPATH withIntermediateDirectories:YES attributes:nil error:nil];
    }
	if([imgKey isEqualToString:RENRENHEADIMGKEY]){				//人人
		if(self.renrenCell&&self.downLoaderForRenRen){
			self.renrenCell.headImg=self.downLoaderForRenRen.appIcon;
            [UIImagePNGRepresentation(self.downLoaderForRenRen.appIcon) writeToFile:RENRENUSERHEADIMGPATH atomically:YES];
		}
	}else if([imgKey isEqualToString:SINAWEIBOHEADIMGKEY]){		//新浪
		if(self.sinaWeiboCell&&self.downLoaderForSinaWeibo){
			self.sinaWeiboCell.headImg=self.downLoaderForSinaWeibo.appIcon;
            [UIImagePNGRepresentation(self.downLoaderForSinaWeibo.appIcon) writeToFile:SINAWEIBOUSERHEADIMGPATH atomically:YES];
		}
	}else if([imgKey isEqualToString:TENCENTWEIBOHEADIMGKEY]){
		if(self.tencentWeiboCell&&self.downLoaderForTencentWeibo){
			self.tencentWeiboCell.headImg=self.downLoaderForTencentWeibo.appIcon;
            [UIImagePNGRepresentation(self.downLoaderForTencentWeibo.appIcon) writeToFile:TENCENTWEIBOUSERHEADIMGPATH atomically:YES];
		}
	}
}

#pragma mark -
#pragma mark implement delegates (RenRen)
-(void)renrenDidLogin:(Renren *)renren{
    if (self.renrenCell) {
        self.renrenCell.bindOrNot=@"已绑定";
    }

    //请求用户头像的url
	[self loadCurrentAuthorizedUserHeadImgUrlForRenRen];
}

-(void)renrenDidLogout:(Renren *)renren{
    if (fileExistsAtPath(IMAGEDIRECTORYPATH)&&fileExistsAtPath([IMAGEDIRECTORYPATH stringByAppendingPathComponent:RENREN_USER_HEADIMAGE])) {
        removerAtItem(RENRENUSERHEADIMGPATH);
    }
    
    if (self.renrenCell) {
        self.renrenCell.headImg=[UIImage imageNamed:@"renren_logo_64X64.png"];
        self.renrenCell.bindOrNot=@"未绑定";
    }
}

-(void)renren:(Renren *)renren loginFailWithError:(ROError *)errof{
	[GlobalInstance showMessageBoxWithMessage:@"登陆失败"];
}

//获取数据相关
-(void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse *)response{
    //解析对象
	self.renrenUserInfo=[RenRenManager resolveRenRenUserInfoToObject:response];
	NSString *headUrl=self.renrenUserInfo.tinyurl;
	//下载头像
	[self startIconDownload:headUrl forKey:RENRENHEADIMGKEY];
}

-(void)renren:(Renren *)renren requestFailWithError:(ROError *)error{
    
}

#pragma mark -
#pragma mark implement delegates (Sina)
/*
 *登陸成功
 */
- (void)engineDidLogIn:(WBEngine *)engine
{
    if (self.sinaWeiboCell) {
        self.sinaWeiboCell.bindOrNot=@"已绑定";
    }
	
	//请求用户头像的url
	[self loadCurrentAuthorizedUserHeadImgUrlForSinaWeibo];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    [GlobalInstance showMessageBoxWithMessage:@"登陆失败"];
}

//登出
- (void)engineDidLogOut:(WBEngine *)engine
{
    if (fileExistsAtPath(IMAGEDIRECTORYPATH)&&fileExistsAtPath([IMAGEDIRECTORYPATH stringByAppendingPathComponent:SINAWEIBO_USER_HEADIMAGE])) {
        removerAtItem(SINAWEIBOUSERHEADIMGPATH);
    }
    
    //换回新浪微博的logo
    if (self.sinaWeiboCell) {
        self.sinaWeiboCell.headImg=[UIImage imageNamed:@"sina_logo_64X64.png"];
        self.sinaWeiboCell.bindOrNot=@"未绑定";
    }
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    [GlobalInstance showMessageBoxWithMessage:@"授权失败"];
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    [GlobalInstance showMessageBoxWithMessage:@"授权过期，请重新登陆"];
}

/*
 *获取数据相关delegate
 */
-(void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result{
    //解析请求对象
	if ([result isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)result;
		self.sinaweiboUserInfo=[SinaWeiboManager resolveSinaWeiboUserInfo:dict];
	}
	
	//下载头像
	[self startIconDownload:self.sinaweiboUserInfo.profile_image_url forKey:SINAWEIBOHEADIMGKEY];
}

-(void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error{
    
}

#pragma mark - TencentWeiboLoginControllerDelegate -
/*
 *授权视图控制器关闭后的处理逻辑(父界面，请求用户信息，下载头像等)
 */
-(void)tencentWeiboLoginControllerDismissed{
	if(self.tencentWeiboCell){
		self.tencentWeiboCell.bindOrNot=@"已绑定";
	}
	//请求用户信息
	[self loadCurrentAuthorizedUserHeadImgUrlForTencentWeibo];
}

#pragma mark - TencentWeiboDelegate -
-(void)tencentWeiboRequestDidReturnResponseForOthers:(id)result{
    //解析用户对象
	self.tencentweiboUserInfo=(TencentWeiboUserInfo *)result;
	//下载头像
	[self startIconDownload:self.tencentweiboUserInfo.head forKey:TENCENTWEIBOHEADIMGKEY];
}

@end
