//
//  UIControl+BlockKits.h
//  FastEasyBlog
//
//  Created by yanghua on 3/19/13.
//  Copyright (c) 2013 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UIButtonTouchUpFunc)(id);

typedef void (^UIButtonTouchDownFunc)(id);

@interface UIButton (BlockKits)

+ (UIButton*) initButtonInstanceWithType:(UIButtonType)type
                                   frame:(CGRect)frame
                                 imgName:(NSString*)imgNameStr
                             eventTarget:(UIViewController*)targetCtrller
                             touchUpFunc:(SEL)touchUpImplMethod
                           touchDownFunc:(SEL)touchDownImplMethod;

+ (UIButton*) initButtonInstanceWithType:(UIButtonType)type
                                   frame:(CGRect)frame
                             eventTarget:(UIViewController*)targetCtrller
                             touchUpFunc:(SEL)touchUpImplMethod
                           touchDownFunc:(SEL)touchDownImplMethod;

@end
