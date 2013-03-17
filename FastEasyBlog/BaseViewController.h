//
//  BaseViewController.h
//  CustomTabBarNotification
//
//  Created by Peter Boctor on 3/7/11.
//
//  Copyright (c) 2011 Peter Boctor

@interface BaseViewController : UITabBarController

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage
                  highlightImage:(UIImage*)highlightImage;

@end
