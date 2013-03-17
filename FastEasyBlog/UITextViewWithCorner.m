//
//  UITextViewWithCorner.m
//  RenRenTest
//
//  Created by svp on 17.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "UITextViewWithCorner.h"
#import <QuartzCore/QuartzCore.h>

@implementation UITextViewWithCorner
@synthesize UITextViewLayCornerRadius;

- (void)dealloc {
    [super dealloc];
}

-(void)awakeFromNib{
	[super awakeFromNib];
	self.layer.cornerRadius=10;
	self.layer.masksToBounds=YES;
}

-(id)initWithFrame:(CGRect)frame
        withCorner:(CGFloat)_cornerRadius{
	self=[super initWithFrame:frame];
	if (self) {
		self.UITextViewLayCornerRadius=_cornerRadius;
		self.layer.masksToBounds=YES;
	}
	
	return self;
}

@end
