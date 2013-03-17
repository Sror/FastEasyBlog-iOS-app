//
//  FastEasyBlogAppDelegate.m
//  FastEasyBlog
//
//  Created by svp on 23.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "FastEasyBlogAppDelegate.h"
#import "Global.h"
#import "FEBAppConfig.h"
#import "Reachability.h"        //检测网络状态
#import "MTStatusBarOverlay.h"
#import "HomePageController.h"
#import "CustomizedExceptionHandler.h"

@interface FastEasyBlogAppDelegate ()

//网络监测
-(void)reachabilityChanged:(NSNotification*)note;

//实例化工具栏提示组件
-(void)initMTStatusBarOverlay;

//设置某些控件的Appearance(iOS 5.0+)
-(void)configUIAppearance;

@end


@implementation FastEasyBlogAppDelegate

@synthesize window;
@synthesize homePageController;
@synthesize operationQueue=_operationQueue;

#pragma mark -
#pragma mark Application lifecycle
- (void)dealloc {
    [overlay release];
    [hostReach release];        hostReach=nil;
	[window release];
    [homePageController release],homePageController=nil;
    [_operationQueue release],_operationQueue=nil;
	[super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [CustomizedExceptionHandler setDefaultExceptionHandler];
    _operationQueue=[[NSOperationQueue alloc]init];
    [self configUIAppearance];
    [self initMTStatusBarOverlay];
    
    //起动网络状态监视
    [[NSNotificationCenter defaultCenter]addObserver:self 
                                            selector:@selector(reachabilityChanged:) 
                                                name:kReachabilityChangedNotification object:nil];
    
    hostReach=[[Reachability reachabilityWithHostName:@"http://www.baidu.com"]retain];
    [hostReach startNotifier];
	
    HomePageController *tmpController=[[HomePageController alloc]initWithNibName:@"HomePageView" bundle:nil];
    self.homePageController=tmpController;
    [tmpController release];
    self.window.rootViewController=self.homePageController;
    [self.window makeKeyAndVisible];
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
	 */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	/*
	 Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
	 */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}


- (void)applicationWillTerminate:(UIApplication *)application {
	/*
	 Called when the application is about to terminate.
	 See also applicationDidEnterBackground:.
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	/*
	 Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
	 */
}

#pragma  mark -
#pragma mark private methods
/*
 *实例化工具栏提示组件
 */
-(void)initMTStatusBarOverlay{
    overlay = [MTStatusBarOverlay sharedInstance];
    overlay.animation = MTStatusBarOverlayAnimationFallDown;  // MTStatusBarOverlayAnimationShrink
    overlay.detailViewMode = MTDetailViewModeHistory;         // enable automatic history-tracking and show in detail-view
    
}

/*
 *网络监测
 */
-(void)reachabilityChanged:(NSNotification*)note{
    Reachability* curReach=[note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status=[curReach currentReachabilityStatus];
    
    if (status==NotReachable) {
        //设置提示
        [overlay postImmediateFinishMessage:@"网络无连接!" duration:3.0 animated:YES];
        overlay.progress = 1.0;
    }
}

/*
 *设置某些控件的Appearance(iOS 5.0+)
 */
-(void)configUIAppearance{
    UIImage *toolBarBackgroundImg=[UIImage imageNamed:@"bar-background.png"];
    [[UIToolbar appearance] setBackgroundImage:toolBarBackgroundImg forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setBackgroundImage:toolBarBackgroundImg forBarMetrics:UIBarMetricsDefault];
    
}

@end
