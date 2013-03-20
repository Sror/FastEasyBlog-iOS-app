//
//  UIControl+BlockKits.m
//  FastEasyBlog
//
//  Created by yanghua on 3/19/13.
//  Copyright (c) 2013 yanghua_kobe. All rights reserved.
//

#import "UIControl+BlockKits.h"

//@implementation UIControl_BlockKits
//
//@end

@implementation UIButton (BlockKits)


+ (UIButton*) initButtonInstanceWithType:(UIButtonType)type
                                   frame:(CGRect)frame
                                 imgName:(NSString*)imgNameStr
                             eventTarget:(UIViewController*)targetCtrller
                             touchUpFunc:(SEL)touchUpImplMethod
                           touchDownFunc:(SEL)touchDownImplMethod{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame=frame;
	[btn setBackgroundImage:[UIImage imageNamed:imgNameStr]
                   forState:UIControlStateNormal];
    
	[btn addTarget:targetCtrller
            action:touchUpImplMethod
  forControlEvents:UIControlEventTouchUpInside];
    
	[btn addTarget:targetCtrller
            action:touchDownImplMethod
  forControlEvents:UIControlEventTouchDown];
    
    return btn;
}

+ (UIButton*) initButtonInstanceWithType:(UIButtonType)type
                                   frame:(CGRect)frame
                             eventTarget:(UIViewController*)targetCtrller
                             touchUpFunc:(SEL)touchUpImplMethod
                           touchDownFunc:(SEL)touchDownImplMethod{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame=frame;
    
	[btn addTarget:targetCtrller
            action:touchUpImplMethod
  forControlEvents:UIControlEventTouchUpInside];
    
	[btn addTarget:targetCtrller
            action:touchDownImplMethod
  forControlEvents:UIControlEventTouchDown];
    
    return btn;
    
}

@end
