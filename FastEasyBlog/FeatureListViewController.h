//
//  FeatureListViewController.h
//  MSFTest
//
//  Created by Ruifan Yuan on 6/14/11.
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OpenSdkOauth.h"
#import "OpenApi.h"

@interface FeatureListViewController : UITableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIWebViewDelegate> {
    
    IBOutlet UIWebView *_webView;
    NSIndexPath *_lastIndexPath;
    UILabel *_titleLabel;
    
	NSArray* featureList;
    NSMutableDictionary *_publishParams;
    
    OpenSdkOauth *_OpenSdkOauth;
    OpenApi *_OpenApi;
}

@property(nonatomic, copy)NSIndexPath *lastIndexPath;

@end
