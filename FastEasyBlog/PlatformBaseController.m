//
//  PlatformBaseController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/5/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "PlatformBaseController.h"
#import "ClickableLabel.h"

#define CHECKBINDNOTIFICATION @"checkBindNotificationForPlatform"


@interface PlatformBaseController ()

//设置是否绑定的通知
-(void)setBindNotification;

//收到通知后的回调处理
-(void)handleCheckBindNotification:(NSNotification*)notification;

//移除或显示“尚未绑定视图”
-(void)HiddenUnBindImageView:(BOOL)isBound;

@property (nonatomic,retain) UIImageView *unBindView;

@end

@implementation PlatformBaseController

@synthesize delegate,
            bindCheckHandleDelegate;

- (void)dealloc{
    [_hud release],_hud=nil;
    [_unBindView release],_unBindView=nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //unbind view
        _unBindView=[[UIImageView alloc]initWithFrame:CGRectMake(-WINDOWWIDTH, 0, WINDOWWIDTH, 416)];
        _unBindView.tag=8769;
        _unBindView.image=[UIImage imageNamed:@"unbind.png"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.unBindView];
    [self.view bringSubviewToFront:self.unBindView];
    [self setBindNotification];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    BOOL isBound=NO;
    if ([self.bindCheckHandleDelegate respondsToSelector:@selector(checkBindInfo)]) {
        isBound=[self.bindCheckHandleDelegate checkBindInfo];
    }
    //检测绑定状态，发送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:CHECKBINDNOTIFICATION object:[NSNumber numberWithBool:isBound]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CHECKBINDNOTIFICATION object:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


/*
 *为导航栏设置右侧的自定义按钮
 */
-(void)setRightBarButtonForNavigationBar{

}

-(void)homePageBtn_TouchDown:(id)sender{
	UIButton *btn=(UIButton*)self.navigationItem.rightBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"homePageBtn_highlight.png"] forState:UIControlStateNormal];
}

-(void)homePageBtn_TouchUpInside:(id)sender{
	UIButton *btn=(UIButton*)self.navigationItem.rightBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"homePageBtn.png"]
                   forState:UIControlStateNormal];
    
    if ([AppConfig(@"isAudioOpen") boolValue]) {
        [GlobalInstance playTipAudio:[[NSBundle mainBundle] URLForResource:@"drip" withExtension:@"WAV"]];
    }
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
        [[NSNotificationCenter defaultCenter]removeObserver:self name:CHECKBINDNOTIFICATION object:nil];
    }];
}

#pragma mark - Bind Check Notification -
/*
 *移除或显示“尚未绑定视图”
 */
-(void)HiddenUnBindImageView:(BOOL)isBound{
    if (isBound) {
        //移除“尚未绑定”视图
        UIImageView *unBindView=(UIImageView*)[self.view viewWithTag:8769];
        unBindView.frame=CGRectMake(-WINDOWWIDTH, 0, WINDOWWIDTH, 416);
    }else {
        UIImageView *unBindView=(UIImageView*)[self.view viewWithTag:8769];
        unBindView.frame=CGRectMake(0, 0, WINDOWWIDTH, 416);
    }
}

/*
 *设置是否绑定的通知
 */
-(void)setBindNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleCheckBindNotification:) name:CHECKBINDNOTIFICATION object:nil];
}

/*
 *收到通知后的回调处理
 */
-(void)handleCheckBindNotification:(NSNotification*)notification{
    BOOL isBound=[(NSNumber*)[notification object] boolValue];
    
    //各平台自行实现代理方法
    if ([self.bindCheckHandleDelegate respondsToSelector:@selector(handleBindNotification:)]) {
        [self.bindCheckHandleDelegate handleBindNotification:isBound];
    }
    
    [self HiddenUnBindImageView:isBound];
}

@end
