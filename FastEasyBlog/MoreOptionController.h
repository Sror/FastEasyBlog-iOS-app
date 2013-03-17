//
//  MoreOptionController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 11/3/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OPTIONAL_NOTIFICATION @"OPTIONAL_NOTIFICATION"

typedef enum{
    nightMode=0,
    lightSetting,
    fontSizeSetting
}optionalType;

@interface MoreOptionController : UIViewController

@property (nonatomic,assign) BOOL isNightMode;
@property (nonatomic,assign) float lightValue;
@property (nonatomic,assign) int fontSizeSegmentedSelectedIndex;

@end
