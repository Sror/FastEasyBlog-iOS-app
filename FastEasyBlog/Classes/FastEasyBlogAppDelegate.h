//
//  FastEasyBlogAppDelegate.h
//  FastEasyBlog
//
//  Created by svp on 23.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramViewController.h"

@class MTStatusBarOverlay;      //自定义状态栏
@class Reachability;
@class HomePageController;

@interface FastEasyBlogAppDelegate : NSObject <UIApplicationDelegate,UITabBarControllerDelegate> {
    UIWindow *window;
    HomePageController *homePageController;
    MTStatusBarOverlay *overlay;
    Reachability *hostReach;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic,retain) HomePageController *homePageController;
@property (nonatomic,retain) NSOperationQueue *operationQueue;

@end

