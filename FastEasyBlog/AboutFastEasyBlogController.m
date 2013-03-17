//
//  AboutFastEasyBlog.m
//  FastEasyBlog
//
//  Created by yanghua_kobe.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import "AboutFastEasyBlogController.h"
#import "Global.h"
#import "FXLabel.h"

@interface AboutFastEasyBlogController()

//为导航栏设置左侧的自定义返回按钮
-(void)setLeftBarButtonForNavigationBar;

@end

@implementation AboutFastEasyBlogController

- (void)dealloc{
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //FEB image(100X100)
        UIImageView *febImageView=[[UIImageView alloc]initWithFrame:CGRectMake(110, 50, 100, 100)];
        febImageView.image=[UIImage imageNamed:@"icon100X100.png"];
        [self.view addSubview:febImageView];
        [febImageView release];
        
        //FEB Vision
        FXLabel *tmpVersionLabel=[[FXLabel alloc]initWithFrame:CGRectMake(55, 190, 250, 30)];
        tmpVersionLabel.shadowOffset = CGSizeMake(0.0f, 2.0f);
        tmpVersionLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
        tmpVersionLabel.shadowBlur = 5.0f;
        tmpVersionLabel.backgroundColor=[UIColor clearColor];
        tmpVersionLabel.font=[UIFont systemFontOfSize:18.0];
        tmpVersionLabel.text=[NSString stringWithFormat:@"软件版本: %@ for iPhone",[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"]];
        [self.view addSubview:tmpVersionLabel];
        [tmpVersionLabel release];
        
        //iOS Vision
        FXLabel *iOSVersionLabel=[[FXLabel alloc]initWithFrame:CGRectMake(55, 230, 250, 30)];
        iOSVersionLabel.shadowOffset = CGSizeMake(0.0f, 2.0f);
        iOSVersionLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
        iOSVersionLabel.shadowBlur = 5.0f;
        iOSVersionLabel.backgroundColor=[UIColor clearColor];
        iOSVersionLabel.font=[UIFont systemFontOfSize:18.0];
        iOSVersionLabel.text=@"支持的系统版本: iOS 5.0+";
        [self.view addSubview:iOSVersionLabel];
        [iOSVersionLabel release];
        
        //update
        FXLabel *updateLabel=[[FXLabel alloc]initWithFrame:CGRectMake(55, 280, 250, 50)];
        updateLabel.font=[UIFont systemFontOfSize:24.0f];
        updateLabel.gradientStartPoint = CGPointMake(0.0f, 0.0f);
        updateLabel.gradientEndPoint = CGPointMake(1.0f, 1.0f);
        updateLabel.gradientColors = [NSArray arrayWithObjects:
                                 [UIColor redColor],
                                 [UIColor yellowColor],
                                 [UIColor greenColor],
                                 [UIColor cyanColor],
                                 [UIColor blueColor],
                                 [UIColor purpleColor],
                                 [UIColor redColor],
                                 nil];
        updateLabel.backgroundColor=[UIColor clearColor];
        updateLabel.text=@"持续更新  敬请期待";
        [self.view addSubview:updateLabel];
        [updateLabel release];

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
    self.navigationItem.title=@"关于快易博";
    [self setLeftBarButtonForNavigationBar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -private method
/*
 *为导航栏设置左侧的自定义返回按钮
 */
-(void)setLeftBarButtonForNavigationBar{
	UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame=CGRectMake(0, 0, 45, 45);
	[btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(back_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *backBarItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
	self.navigationItem.leftBarButtonItem=backBarItem;
	[backBarItem release];
}

- (void)back_TouchUpInside:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
}


@end
