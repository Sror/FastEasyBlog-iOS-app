//
//  ClickableLabel.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-7-23.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickEventDelegate;

@interface ClickableLabel : UILabel{
    id<ClickEventDelegate> lblDelegate;
}

@property (nonatomic,assign) id<ClickEventDelegate> lblDelegate;

@end


//label's click delegate
@protocol ClickEventDelegate <NSObject>

@required

-(void)doClickAtTarget:(ClickableLabel*)label;

@optional

@end
