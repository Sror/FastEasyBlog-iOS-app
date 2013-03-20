//
//  HomePageController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/5/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "HomePageController.h"
#import "SinaWeiboManager.h"
#import "TencentWeiboManager.h"
#import "RenRenManager.h"

#import "RenRenMainController.h"
#import "TianyaMainController.h"
#import "RenRenFeedCategoryController.h"
#import "SettingMainController.h"
#import "PublishController.h"
#import "RevealController.h"
#import "SinaWeiboSwitchController.h"
#import "TencentWeiboSwitchController.h"

#import "ImageHelper.h"
#import "ImageHelper-ImageProcessing.h"

#define CHECKBINDNOTIFICATIONINHOMEPAGE @"checkBindNotificationInHomePage"

typedef enum {
    TAG_TIPBUTTON
}TAGS;

@interface HomePageController ()

@property (nonatomic,retain) UIButton *tipBtn;
@property (nonatomic,retain) UIButton *skinBtn;

//注册绑定通知
-(void)registeBindNotification;

//处理通知
-(void)handleNotification:(NSNotification*)notification;

//实例化相关平台的主控制器
-(UINavigationController*)createSinaWeiboNavCtrller;
-(UINavigationController*)createTencentWeiboNavCtrller;
-(RevealController*)createRenRenRevealCtrller;
-(UINavigationController*)createTianyaRevealCtrller;       //天涯 待实现
-(UINavigationController*)createPublishNavCtrller;
-(UINavigationController*)createSettingNavCtrller;


@end

@implementation HomePageController


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CHECKBINDNOTIFICATIONINHOMEPAGE object:nil];
    [_backgroundImgView release];
    
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _backgroundImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WINDOWWIDTH, WINDOWHEIGHT)];
        _backgroundImgView.image=[UIImage imageNamed:@"defaultBG.png"];
        
        
        _skinBtn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                frame:CGRectMake(275, 420, 33, 30)
                                              imgName:@"skinBtn.png"
                                          eventTarget:self
                                          touchUpFunc:@selector(skinButton_touchUpInside:)
                                        touchDownFunc:nil];
        
        _sinaWeiboBtn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                     frame:CGRectMake(60, 70, 89, 89)
                                               eventTarget:self
                                               touchUpFunc:@selector(button_TouchUpInside:)
                                             touchDownFunc:nil];
        _sinaWeiboBtn.tag=1000;
        
        _tencentWeiboBtn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                     frame:CGRectMake(171, 70, 89, 89)
                                               eventTarget:self
                                               touchUpFunc:@selector(button_TouchUpInside:)
                                             touchDownFunc:nil];
        _tencentWeiboBtn.tag=1001;
        
        _renrenBtn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                        frame:CGRectMake(60, 185, 89, 89)
                                                  eventTarget:self
                                                  touchUpFunc:@selector(button_TouchUpInside:)
                                                touchDownFunc:nil];
        _renrenBtn.tag=1002;
        
        _tianyaBtn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                  frame:CGRectMake(171, 185, 89, 89)
                                            eventTarget:self
                                            touchUpFunc:@selector(button_TouchUpInside:)
                                          touchDownFunc:nil];
        _tianyaBtn.tag=1003;
        
        _shareBtn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                 frame:CGRectMake(60, 300, 89, 89)
                                               imgName:@"share_homePage.png"
                                           eventTarget:self
                                           touchUpFunc:@selector(button_TouchUpInside:)
                                         touchDownFunc:nil];
        _shareBtn.tag=1004;
        
        _settingBtn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                   frame:CGRectMake(171, 300, 89, 89)
                                                 imgName:@"setting_homePage.png"
                                             eventTarget:self
                                             touchUpFunc:@selector(button_TouchUpInside:)
                                           touchDownFunc:nil];
        _settingBtn.tag=1005;
        
        if (![AppConfig(@"homePage_tip_hasShown") boolValue]) {
//            _tipBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//            _tipBtn.frame=CGRectMake(0, 0, WINDOWWIDTH, WINDOWHEIGHT-STATUSBARHEIGHT);
//            [_tipBtn setBackgroundImage:[UIImage imageNamed:@"homePage_tip.png"] forState:UIControlStateNormal];
//            [_tipBtn addTarget:self action:@selector(tipButton_touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            
            _tipBtn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                   frame:CGRectMake(0, 0, WINDOWWIDTH, WINDOWHEIGHT-STATUSBARHEIGHT)
                                                 imgName:@"homePage_tip.png"
                                             eventTarget:self
                                             touchUpFunc:@selector(tipButton_touchUpInside:)
                                           touchDownFunc:nil];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self registeBindNotification];
    [self.view addSubview:self.backgroundImgView];
    [self.view addSubview:self.sinaWeiboBtn];
    [self.view addSubview:self.tencentWeiboBtn];
    [self.view addSubview:self.renrenBtn];
    [self.view addSubview:self.tianyaBtn];
    [self.view addSubview:self.shareBtn];
    [self.view addSubview:self.settingBtn];
    [self.view addSubview:self.skinBtn];
    
    if (self.tipBtn) {
        [self.view addSubview:self.tipBtn];
        [self.view bringSubviewToFront:self.tipBtn];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
	NSMutableDictionary *bindDctionary=[[NSMutableDictionary alloc]init];
	[bindDctionary setObject:[NSNumber numberWithBool:[SinaWeiboManager isBoundToApplication]] forKey:@"SinaWeibo"];
	[bindDctionary setObject:[NSNumber numberWithBool:[TencentWeiboManager isBoundToApplication]] forKey:@"TencentWeibo"];
	[bindDctionary setObject:[NSNumber numberWithBool:[RenRenManager isBoundToApplication]] forKey:@"RenRen"];
	[bindDctionary setObject:[NSNumber numberWithBool:NO] forKey:@"Tianya"];
    [[NSNotificationCenter defaultCenter]postNotificationName:CHECKBINDNOTIFICATIONINHOMEPAGE object:bindDctionary];
	[bindDctionary release];
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

#pragma mark - private methods -
- (void)button_TouchUpInside:(id)sender{
	UINavigationController *navCtrller=nil;
	UIButton *clickedBtn=(UIButton*)sender;
	if(clickedBtn){
		if(clickedBtn.tag==1000){					//新浪微博
			NSLog(@"新浪微博");
			navCtrller=[self createSinaWeiboNavCtrller];
			navCtrller.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;	
            [self presentModalViewController:navCtrller animated:YES];
		}else if(clickedBtn.tag==1001){				//腾讯微博
			NSLog(@"腾讯微博");
			navCtrller=[self createTencentWeiboNavCtrller];
			navCtrller.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;	
            [self presentModalViewController:navCtrller animated:YES];
		}else if(clickedBtn.tag==1002){				//人人网
			NSLog(@"人人网");
            RevealController *revealCtrller;
			revealCtrller=[self createRenRenRevealCtrller];
			revealCtrller.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
            [self presentModalViewController:revealCtrller animated:YES];
		}else if(clickedBtn.tag==1003){				//天涯社区
			NSLog(@"天涯社区");
			UINavigationController *publishMainNavCtrller=[self createTianyaRevealCtrller];
			publishMainNavCtrller.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;				//底部滑入
			[self presentModalViewController:publishMainNavCtrller animated:YES];
            return;
		}else if(clickedBtn.tag==1004){				//分享心情
			NSLog(@"分享心情");
            if ([GlobalInstance isEnableNetwork]) {
                UINavigationController *publishNavCtrller=[self createPublishNavCtrller];
                publishNavCtrller.modalTransitionStyle=UIModalTransitionStyleCoverVertical;				//底部滑入
                [self presentModalViewController:publishNavCtrller animated:YES];
            }else {
                [GlobalInstance showMessageBoxWithMessage:@"请先进入“设置－通用－网络”开启网络连接。"];
            }
            return;
		}else if(clickedBtn.tag==1005){				//设置
			NSLog(@"设置");
			UINavigationController *settingNavCtrller=[self createSettingNavCtrller];
			settingNavCtrller.modalTransitionStyle=UIModalTransitionStyleCoverVertical;	
			[self presentModalViewController:settingNavCtrller animated:YES];
            return;
		}
		
	}
}

/*
 *注册绑定通知
 */
-(void)registeBindNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotification:) name:CHECKBINDNOTIFICATIONINHOMEPAGE object:nil];
}

/*
 *处理通知
 */
-(void)handleNotification:(NSNotification*)notification{
    NSMutableDictionary *bindDictionary=(NSMutableDictionary*)[notification object];
	BOOL isBindToSinaWeibo=[(NSNumber*)[bindDictionary objectForKey:@"SinaWeibo"] boolValue];
	BOOL isBindToTencentWeibo=[(NSNumber*)[bindDictionary objectForKey:@"TencentWeibo"] boolValue];
	BOOL isBindToRenRen=[(NSNumber*)[bindDictionary objectForKey:@"RenRen"] boolValue];
	BOOL isBindToTianya=[(NSNumber*)[bindDictionary objectForKey:@"Tianya"] boolValue];
	
	//处理图片
	[self.sinaWeiboBtn setBackgroundImage:[UIImage imageNamed:(isBindToSinaWeibo?@"sinaWeibo_binding":@"sinaWeibo_unbind.png")] forState:UIControlStateNormal];
	[self.tencentWeiboBtn setBackgroundImage:[UIImage imageNamed:(isBindToTencentWeibo?@"tencentWeibo_binding":@"tencentWeibo_unbind.png")] forState:UIControlStateNormal];
	[self.renrenBtn setBackgroundImage:[UIImage imageNamed:(isBindToRenRen?@"renren_binding":@"renren_unbind.png")] forState:UIControlStateNormal];
	[self.tianyaBtn setBackgroundImage:[UIImage imageNamed:(isBindToTianya?@"tianya_binding":@"tianya_unbind.png")] forState:UIControlStateNormal];
}

/*
 *提示图片点击事件
 */
- (void)tipButton_touchUpInside:(id)sender{
    //设置alpha渐变到消失，然后移除
    [UIView animateWithDuration:1 
                     animations:^{
                                self.tipBtn.alpha=0.0;
                    }
                     completion:^(BOOL finished){
                        if (finished) {
                            [[FEBAppConfig sharedAppConfig]
                                setValue:[NSNumber numberWithBool:YES]
                                    forKey:@"homePage_tip_hasShown"];
                                    [self.tipBtn removeFromSuperview];
                        }
                    }
     ];
}

- (void)skinButton_touchUpInside:(id)sender{
    int currentIndex=[AppConfig(@"current_HomePage_BG_Index") intValue];
    currentIndex=(currentIndex==2)?0:++currentIndex;
    NSString *resourceName;
    if (currentIndex==0) {
        resourceName=@"defaultBG.png";
    }else {
        resourceName=[NSString stringWithFormat:@"IMG_00%d.JPG",currentIndex];
    }
    UIImage *changedImg=[UIImage imageNamed:resourceName];
    self.backgroundImgView.image=changedImg;
    [[FEBAppConfig sharedAppConfig] setValue:[NSNumber numberWithInt:currentIndex] forKey:@"current_HomePage_BG_Index"];
    
}

#pragma mark - init all platform main controllers -
-(UINavigationController*)createSinaWeiboNavCtrller{    
    SinaWeiboSwitchController *sinaWeiboSwitchCtrller=[[SinaWeiboSwitchController alloc]initWithNibName:@"SinaWeiboSwitchView" bundle:nil];
    
    UINavigationController *sinaWeiboNavigationController=[[[UINavigationController alloc]initWithRootViewController:sinaWeiboSwitchCtrller]autorelease];
    
    [sinaWeiboSwitchCtrller release];
    
    return sinaWeiboNavigationController;
}

-(UINavigationController*)createTencentWeiboNavCtrller{
    TencentWeiboSwitchController *tencentWeiboSwitchCtrller=[[TencentWeiboSwitchController alloc]initWithNibName:@"TencentWeiboSwitchView" bundle:nil];
    
	UINavigationController *tencentWeiboNavigationController=[[[UINavigationController alloc]initWithRootViewController:tencentWeiboSwitchCtrller]autorelease];
    
	[tencentWeiboSwitchCtrller release];
    
    return tencentWeiboNavigationController;
}

-(RevealController*)createRenRenRevealCtrller{
    RenRenMainController *frontViewController;
	RenRenFeedCategoryController *rearViewController;
    
    CGRect tableViewFrame=CGRectMake(0, 0, WINDOWWIDTH, 436);
    frontViewController=[[RenRenMainController alloc] initWithRefreshHeaderViewEnabled:YES andLoadMoreFooterViewEnabled:YES andTableViewFrame:tableViewFrame];
    
//    frontViewController = [[RenRenMainController alloc] initWithNibName:@"RenRenMainView" bundle:nil];
    rearViewController = [[RenRenFeedCategoryController alloc] initWithNibName:@"RenRenFeedCategoryView" bundle:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    navigationController.navigationItem.title=@"新鲜事";
    navigationController.navigationBar.hidden=NO;
    navigationController.navigationBar.tintColor=defaultNavigationBGColor;
	
	RevealController *revealController = [[[RevealController alloc] initWithFrontViewController:navigationController rearViewController:rearViewController]autorelease];
	
	[navigationController release];
	[frontViewController release];
	[rearViewController release];
    
    return revealController;
}

-(UINavigationController*)createTianyaRevealCtrller{    
    TianyaMainController *publishMainController=[[TianyaMainController alloc]initWithNibName:@"TianyaMainView" bundle:nil];
	UINavigationController *publichMainNavigationController=[[[UINavigationController alloc]initWithRootViewController:publishMainController]autorelease];
	[publishMainController release];
	publichMainNavigationController.navigationBar.hidden=NO;
	publichMainNavigationController.navigationBar.tintColor=defaultNavigationBGColor;
    
    return publichMainNavigationController;
}

-(UINavigationController*)createPublishNavCtrller{
    PublishController *publishCtrller=[[PublishController alloc]
                                       initWithNibName:@"PublishView"
                                                bundle:nil
                                               content:nil];
    UINavigationController *publichNavCtrller=[[[UINavigationController alloc]initWithRootViewController:publishCtrller]autorelease];
    [publishCtrller release];
    publichNavCtrller.navigationBar.hidden=NO;
    publichNavCtrller.navigationBar.tintColor=defaultNavigationBGColor;
    return publichNavCtrller;
}

-(UINavigationController*)createSettingNavCtrller{
    SettingMainController *settingMainController=[[SettingMainController alloc]initWithNibName:@"SettingMainView" bundle:nil];
	UINavigationController *settingNavigationController=[[[UINavigationController alloc]initWithRootViewController:settingMainController]autorelease];
	[settingMainController release];
	settingNavigationController.navigationBar.hidden=NO;
	settingNavigationController.navigationBar.tintColor=defaultNavigationBGColor;
    
    return settingNavigationController;
    
}


@end
