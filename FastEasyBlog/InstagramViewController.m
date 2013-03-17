//
//  InstagramViewController.m
//  CustomTabBarNotification
//
//  Created by Peter Boctor on 3/7/11.
//
//  Copyright (c) 2011 Peter Boctor

#import "InstagramViewController.h"
#import "Global.h"
//#import "CustomNavigationBar.h"


@implementation InstagramViewController
@synthesize notificationView, commentCountLabel, likeCountLabel, followerCountLabel;


- (void)viewDidLoad
{
  [super viewDidLoad];

  // Set the title view to the Instagram logo
  //UIImage* titleImage = [UIImage imageNamed:@"navigationBarLogo.png"];
//  UIView* titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,titleImage.size.width, self.navigationController.navigationBar.frame.size.height)];
//  UIImageView* titleImageView = [[UIImageView alloc] initWithImage:titleImage];
//  [titleView addSubview:titleImageView];
//  titleImageView.center = titleView.center;
//  CGRect titleImageViewFrame = titleImageView.frame;
//  // Offset the logo up a bit
//  titleImageViewFrame.origin.y = titleImageViewFrame.origin.y + 3.0;
//  titleImageView.frame = titleImageViewFrame;
//  self.navigationItem.titleView = titleView;
	

  // Get our custom nav bar
  //CustomNavigationBar* customNavigationBar = (CustomNavigationBar*)self.navigationController.navigationBar;

  // Set the nav bar's background
  //[customNavigationBar setBackgroundWith:[UIImage imageNamed:@"navigationBarBackgroundRetro.png"]];
	
	//[self addCenterButtonWithImage:[UIImage imageNamed:@"cameraTabBarItem.png"] highlightImage:nil];
	
	//UIImageView *bgImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yellowbgColor.png"]];
//	bgImgView.frame=CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//	[self.tabBar insertSubview:bgImgView atIndex:0];
//	[bgImgView release];
	
	//self.navigationController.navigationBar.tintColor
	
		
	UIView *bgView=[[UIView	alloc]initWithFrame:CGRectMake(0, 0, 320, 49)];
	//bgView.backgroundColor=defalutTabBarBGColor;
	[self.tabBar insertSubview:bgView atIndex:0];
	[bgView release];

}


- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
  // A single tab item's width is the entire width of the tab bar divided by number of items
  CGFloat tabItemWidth = self.tabBar.frame.size.width / self.tabBar.items.count;
  // A half width is tabItemWidth divided by 2 minus half the width of the notification view
  CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (notificationView.frame.size.width / 2.0);
  
  // The horizontal location is the index times the width plus a half width
  return (tabIndex * tabItemWidth) + halfTabItemWidth;
}

- (void) showNotificationViewFor:(NSUInteger)tabIndex
{
  // To get the vertical location we start at the top of the tab bar (0), go up by the height of the notification view, then go up another 2 pixels so our view is slightly above the tab bar
  CGFloat verticalLocation = - notificationView.frame.size.height - 2.0;
  notificationView.frame = CGRectMake([self horizontalLocationFor:tabIndex], verticalLocation, notificationView.frame.size.width, notificationView.frame.size.height);

  if (!notificationView.superview)
    [self.tabBar addSubview:notificationView];

  notificationView.alpha = 0.0;

  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.5];
  notificationView.alpha = 1.0;
  [UIView commitAnimations];
}

- (IBAction)showNotificationView:(id)sender
{
  showButton.enabled = NO;
  hideButton.enabled = YES;
  
  // Set the values for the number of comments, likes and followers
  commentCountLabel.text = @"2";
  likeCountLabel.text = @"1";
  followerCountLabel.text = @"3";
  
  // Show the notification view over the 3rd tab bar item
  [self showNotificationViewFor:3];
}

- (IBAction)hideNotificationView:(id)sender
{
  showButton.enabled = YES;
  hideButton.enabled = NO;
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.5];
  notificationView.alpha = 0.0;
  [UIView commitAnimations];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.notificationView = nil;
  self.commentCountLabel = nil;
  self.likeCountLabel = nil;
  self.followerCountLabel = nil;
}

- (void)dealloc
{
  [notificationView release];
  [commentCountLabel release];
  [likeCountLabel release];
  [followerCountLabel release];
  [super dealloc];
}

#pragma mark -
#pragma mark UITabBarControllerDelegate
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
	UINavigationController *nv=(UINavigationController*)viewController;
	[nv popToRootViewControllerAnimated:YES];
}


@end
