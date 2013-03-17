//	带有圆角的UITextView
//  UITextViewWithCorner.h
//  RenRenTest
//
//  Created by svp on 17.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITextViewWithCorner : UITextView {
	CGFloat UITextViewLayCornerRadius;
}

@property (nonatomic,assign) CGFloat UITextViewLayCornerRadius;

@end
