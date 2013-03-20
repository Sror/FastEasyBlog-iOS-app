//
//  MyHomePageController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/8/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "MyHomePageController.h"
#import "Global.h"
#import "ExtensionMethods.h"

#define MYHOMEPAGEURL @"http://blog.csdn.net/yanghua_kobe"

@interface MyHomePageController ()

//为导航栏设置左侧的自定义返回按钮
-(void)setLeftBarButtonForNavigationBar;

@end

@implementation MyHomePageController

@synthesize myHomePageView;

- (void)dealloc{
    [myHomePageView release],myHomePageView=nil;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myHomePageView.delegate=self;
    self.myHomePageView.scalesPageToFit=YES;
	[self setLeftBarButtonForNavigationBar];
	self.navigationItem.title=@"我的主页";
    self.navigationController.navigationBar.tintColor=defaultNavigationBGColor;
    NSURLRequest *myHomePageUrl=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:MYHOMEPAGEURL]];
    [self.myHomePageView loadRequest:myHomePageUrl];
    [myHomePageUrl release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.myHomePageView=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -UIWebViewDelegate-
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [GlobalInstance showMessageBoxWithMessage:@"网页加载失败"];
}

#pragma mark -private methods-
/*
 *为导航栏设置左侧的自定义返回按钮
 */
-(void)setLeftBarButtonForNavigationBar{
    UIButton *btn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                 frame:CGRectMake(0, 0, 45, 45)
                                               imgName:@"closeBtn.png"
                                           eventTarget:self
                                           touchUpFunc:@selector(closeButton_touchUpInside)
                                         touchDownFunc:@selector(closeButton_touchDown)];
	
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
