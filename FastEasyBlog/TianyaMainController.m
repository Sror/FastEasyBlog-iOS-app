//
//  TianyaMainController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/12/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "TianyaMainController.h"

@interface TianyaMainController ()

@end

@implementation TianyaMainController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //super.bindCheckHandleDelegate=self;
    self.navigationItem.title=@"天涯社区";
    [self setLeftBarButtonForNavigationBar];
    UIImageView *unDoView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WINDOWWIDTH, 416)];
    unDoView.image=[UIImage imageNamed:@"undo.png"];
    [self.view addSubview:unDoView];
    [self.view bringSubviewToFront:unDoView];
    [unDoView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - NavigationBar handle logic-
/*
 *为导航栏设置左侧自定义按钮
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
	UIButton *btn=(UIButton*)self.navigationItem.leftBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"homePageBtn_highlight.png"] forState:UIControlStateNormal];
}

-(void)homePageBtn_TouchUpInside:(id)sender{
    //移除高亮效果
	UIButton *btn=(UIButton*)self.navigationItem.leftBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"homePageBtn.png"] forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Bind check notification handle -
-(BOOL)checkBindInfo{
    return NO;
}

- (void)handleBindNotification:(BOOL)isBound{
    //如果已綁定并且是首次加载
    if (isBound) {
//        if (self.weiboList==nil) {
//            [self loadWeiboList];
//        }
    }else {
        
    }
}


@end
