//
//  SwitchController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/12/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "SwitchController.h"
#import "SinaWeiboPublishController.h"
#import "TencentWeiboPublishController.h"
#import "UIControl+BlockKits.h"

@interface SwitchController ()

@property (nonatomic,retain) UIImageView *tabBarGuideImgView;
@property (nonatomic,retain) NSArray *childControllersArr;
@property (nonatomic,retain) UIView *customizedTitleView;


- (void)switchCtrllerWithIndex:(int)index;

@end

@implementation SwitchController

@synthesize delegate;

- (void)dealloc{
	[_currentCtrller release],_currentCtrller=nil;
    [_contentView release],_contentView=nil;
    [_tabBarGuideImgView release],_tabBarGuideImgView=nil;
    [_tabBarView release],_tabBarView=nil;
    [_childControllersArr release],_childControllersArr=nil;
    [_childControllerNavTitlesArr release],_childControllerNavTitlesArr=nil;
    [_navigationTitleLbl release],_navigationTitleLbl=nil;
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             platform:(AllPlatform)pt
        tabBarImgName:(NSString*)imgName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _currentPlatform=pt;
        
        //自定义标题视图
        _customizedTitleView=[[UIView alloc]initWithFrame:CGRectMake(100,13,120,20)];
        //导航标题
        _navigationTitleLbl=[[ClickableLabel alloc]initWithFrame:CGRectMake(0, 0, 95, 20)];
        _navigationTitleLbl.tag=NAVIGATIONTITLELBL_TAG;
        _navigationTitleLbl.backgroundColor=[UIColor clearColor];
        _navigationTitleLbl.textColor=[UIColor whiteColor];
        _navigationTitleLbl.font=[UIFont boldSystemFontOfSize:20.0f];
        _navigationTitleLbl.textAlignment=UITextAlignmentRight;
        [_customizedTitleView addSubview:_navigationTitleLbl];
        [_navigationTitleLbl release];
        
        //弹出视图导航图标
        _popViewGuideImgBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _popViewGuideImgBtn.frame=CGRectMake(99,8,11,5);
        _popViewGuideImgBtn.tag=POPVIEWGUIDE_TAG;
        [_popViewGuideImgBtn setBackgroundImage:[UIImage imageNamed:@"pulldown.png"] forState:UIControlStateNormal];       //pulldown
        _popViewGuideImgBtn.backgroundColor=[UIColor clearColor];
        
        [_customizedTitleView addSubview:_popViewGuideImgBtn];
        
        _contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEWCONTENTWIDTH, VIEWCONTENTHEIGHT)];
        
        _tabBarGuideImgView=[[UIImageView alloc]initWithFrame:CGRectMake(27, VIEWCONTENTHEIGHT-5, 10, 5)];
        _tabBarGuideImgView.image=[UIImage imageNamed:@"tabBarGuideBG.png"];
        
        _tabBarView=[[UIImageView alloc]initWithFrame:CGRectMake(0, VIEWCONTENTHEIGHT, VIEWCONTENTWIDTH, TABBARHEIGHT)];
        if (!imgName||[imgName isEqualToString:@""]) {
            _tabBarView.image=[UIImage imageNamed:@"tabBarBG.png"];
        }else {
            _tabBarView.image=[UIImage imageNamed:imgName];
        }
        
        _tabBarView.userInteractionEnabled=YES;     //响应点击
        [_tabBarView addGestureRecognizer:[[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]autorelease]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView=self.customizedTitleView;
	[self.view addSubview:self.contentView];
    [self.view addSubview:self.tabBarView];
    [self.view addSubview:self.tabBarGuideImgView];
    [self.view bringSubviewToFront:self.tabBarGuideImgView];
    [self setLeftBarButtonForNavigationBar];
    [self setRightBarButtonForNavigationBar];
    //init and add child view controllers
    if ([self.delegate respondsToSelector:@selector(initAndAddChildViewControllers)]) {
        self.childControllersArr=[self.delegate initAndAddChildViewControllers];
    }
    
    //init child controllers navigation titles
    if ([self.delegate respondsToSelector:@selector(initChildViewControllerNavTitles)]) {
        self.childControllerNavTitlesArr=[self.delegate initChildViewControllerNavTitles];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

/*
 *处理手势(点击)
 */
- (void)handleTap:(UIGestureRecognizer*)sender{
    if (sender.state==UIGestureRecognizerStateEnded) {
        CGPoint tapLocation=[sender locationInView:self.tabBarView];
        int x=tapLocation.x;
        [self switchCtrllerWithIndex:x/65];
    }
}

/*
 *切换视图
 */
- (void)switchCtrllerWithIndex:(int)index{
    if (index>=[self.childControllersArr count]) {
        return;
    }
    
	if(self.currentCtrller==[self.childControllersArr objectAtIndex:index]){
		return;
	}
	
	UIViewController *oldCtrller=self.currentCtrller;
	UIViewController *transitionToCtrller=[self.childControllersArr objectAtIndex:index];
	
	//set navigation item title
	if (index<[self.childControllerNavTitlesArr count]) {
        self.navigationTitleLbl.text=[self.childControllerNavTitlesArr objectAtIndex:index];
    }
    
    CGFloat tabBarGuideImgViewWidth=0.0;
    switch (index) {
        case 0:
        {
            tabBarGuideImgViewWidth=27.0;
            self.popViewGuideImgBtn.hidden=NO;
            self.popViewGuideImgBtn.userInteractionEnabled=YES;
            self.navigationTitleLbl.userInteractionEnabled=YES;
        }
            break;
            
        case 1:
        {
            tabBarGuideImgViewWidth=92;
            self.popViewGuideImgBtn.hidden=YES;
            self.popViewGuideImgBtn.userInteractionEnabled=NO;
            self.navigationTitleLbl.userInteractionEnabled=NO;
        }
            break;
            
        case 2:
        {
            tabBarGuideImgViewWidth=157;
            self.popViewGuideImgBtn.hidden=YES;
            self.popViewGuideImgBtn.userInteractionEnabled=NO;
            self.navigationTitleLbl.userInteractionEnabled=NO;
        }
            break;
            
        case 3:
        {
            tabBarGuideImgViewWidth=218;
            self.popViewGuideImgBtn.hidden=YES;
            self.popViewGuideImgBtn.userInteractionEnabled=NO;
            self.navigationTitleLbl.userInteractionEnabled=NO;
        }
            break;
            
        case 4:
        {
            tabBarGuideImgViewWidth=285;
            self.popViewGuideImgBtn.hidden=YES;
            self.popViewGuideImgBtn.userInteractionEnabled=NO;
            self.navigationTitleLbl.userInteractionEnabled=NO;
        }
            break;
            
        default:
            break;
    }
    self.tabBarGuideImgView.frame=CGRectMake(tabBarGuideImgViewWidth, self.tabBarGuideImgView.frame.origin.y, self.tabBarGuideImgView.frame.size.width, self.tabBarGuideImgView.frame.size.height);
	
	[self transitionFromViewController:self.currentCtrller toViewController:transitionToCtrller duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    self.currentCtrller=[self.childControllersArr objectAtIndex:index];
                }else{
                    self.currentCtrller=oldCtrller;
                }
            }];
	
}

#pragma mark - NavigationBar handle logic-
/*
 *为导航栏设置左侧自定义按钮
 */
-(void)setLeftBarButtonForNavigationBar{
    UIButton *btn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                   frame:CGRectMake(10,0,45,45)
                                 imgName:@"homePageBtn.png"
                             eventTarget:self
                             touchUpFunc:@selector(homePageBtn_TouchUpInside:)
                           touchDownFunc:@selector(homePageBtn_TouchDown:)];
    
	UIBarButtonItem *menuBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
	self.navigationItem.leftBarButtonItem=menuBtn;
	[menuBtn release];
}

-(void)homePageBtn_TouchDown:(id)sender{
	UIButton *btn=(UIButton*)self.navigationItem.leftBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"homePageBtn_highlight.png"] forState:UIControlStateNormal];
}

-(void)homePageBtn_TouchUpInside:(id)sender{
	UIButton *btn=(UIButton*)self.navigationItem.leftBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"homePageBtn.png"] forState:UIControlStateNormal];
    
    if ([AppConfig(@"isAudioOpen") boolValue]) {
        [GlobalInstance playTipAudio:[[NSBundle mainBundle] URLForResource:@"drip" withExtension:@"WAV"]];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

/*
 *为导航栏设置右侧自定义按钮
 */
-(void)setRightBarButtonForNavigationBar{
	UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame=CGRectMake(285,0,33,33);
	[btn setBackgroundImage:[UIImage imageNamed:@"publish_SubBtn.png"] forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(rightBtn_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	[btn addTarget:self action:@selector(rightBtn_TouchDown:) forControlEvents:UIControlEventTouchDown];
	UIBarButtonItem *menuBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
	self.navigationItem.rightBarButtonItem=menuBtn;
	[menuBtn release];
}

-(void)rightBtn_TouchDown:(id)sender{
	UIButton *btn=(UIButton*)self.navigationItem.rightBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"publish_SubBtn.png"] forState:UIControlStateNormal];
}

-(void)rightBtn_TouchUpInside:(id)sender{
	UIButton *btn=(UIButton*)self.navigationItem.rightBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"publish_SubBtn.png"] forState:UIControlStateNormal];
    
    if ([AppConfig(@"isAudioOpen") boolValue]) {
        [GlobalInstance playTipAudio:[[NSBundle mainBundle] URLForResource:@"drip" withExtension:@"WAV"]];
    }
    
    //弹出所属平台的发布视图
    switch (self.currentPlatform) {
        case RenRen:
            
            break;
            
        case SinaWeibo:
        {
            SinaWeiboPublishController *sinaWeiboPubCtrller=[[SinaWeiboPublishController alloc]initWithNibName:@"SinaWeiboPublishView" bundle:nil];
            UINavigationController *sinaWeiboNavCtrller=[[UINavigationController alloc]initWithRootViewController:sinaWeiboPubCtrller];
            [sinaWeiboPubCtrller release];
            
            [self presentModalViewController:sinaWeiboNavCtrller animated:YES];
            [sinaWeiboNavCtrller release];
        }
            
            break;
            
        case TencentWeibo:
        {
            TencentWeiboPublishController *tencentWeiboPubCtrller=[[TencentWeiboPublishController alloc]initWithNibName:@"TencentWeiboPublishView" bundle:nil];
            UINavigationController *tencentWeiboNavCtrller=[[UINavigationController alloc]initWithRootViewController:tencentWeiboPubCtrller];
            [tencentWeiboPubCtrller release];
            
            [self presentModalViewController:tencentWeiboNavCtrller animated:YES];
            [tencentWeiboNavCtrller release];
        }
            break;
            
        case Tianya:
            
            break;
            
        default:
            break;
    }
}

@end
