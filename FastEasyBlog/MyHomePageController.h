//
//  MyHomePageController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/8/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHomePageController : UIViewController
<
UIWebViewDelegate
>
{
    IBOutlet UIWebView *myHomePageView;
}

@property (nonatomic,retain) IBOutlet UIWebView *myHomePageView;

@end
