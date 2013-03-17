//	具有水印效果的圆角文本框
//  UIPlaceHolderTextViewWithCorner.h
//  RenRenTest
//
//  Created by svp on 17.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIPlaceHolderTextViewWithCorner : UITextView {
	NSString *placeholder;
	UIColor *placeholderColor;
	CGFloat UITextViewLayCornerRadius;
	
	@private
	UILabel *placeholderLabel;
}

@property (nonatomic,retain) UILabel *placeholderLabel;
@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic,retain) UIColor *placeholderColor;
@property (nonatomic,assign) CGFloat UITextViewLayCornerRadius;

-(void)textChanged:(NSNotification *)nofification;

@end
