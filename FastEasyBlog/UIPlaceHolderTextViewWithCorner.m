//
//  UIPlaceHolderTextViewWithCorner.m
//  RenRenTest
//
//  Created by svp on 17.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "UIPlaceHolderTextViewWithCorner.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIPlaceHolderTextViewWithCorner

@synthesize placeholderLabel;
@synthesize placeholder;
@synthesize placeholderColor;
@synthesize UITextViewLayCornerRadius;

-(void)dealloc{
	[[NSNotificationCenter defaultCenter]removeObserver:self];
	[placeholderLabel release];		placeholderLabel=nil;
	[placeholderColor release];		placeholderColor=nil;
	[placeholder release];			placeholder=nil;
	[super dealloc];
}

//当Nib文件被加载时，Nib会向每个对象发送一条该消息，以允许对象实现自己的处理逻辑
-(void)awakeFromNib{
	[super awakeFromNib];
	[self setPlaceholder:@""];
	[self setPlaceholderColor:[UIColor lightGrayColor]];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
	self.layer.cornerRadius=10;
	self.layer.masksToBounds=YES;
}

-(id)initWithFrame:(CGRect)frame
        withCorner:(CGFloat)cornerRadius{
	if (self=[super initWithFrame:frame]) {
		[self setPlaceholder:@""];
		[self setPlaceholderColor:[UIColor lightGrayColor]];
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
		self.UITextViewLayCornerRadius=cornerRadius;
		self.layer.masksToBounds=YES;
	}
	
	return self;
}

-(void)textChanged:(NSNotification *)notification{
	if ([self.placeholder length]==0) {
		return;
	}
	
	if ([self.text length]==0) {
		[[self viewWithTag:999]setAlpha:1];
	}else {
		[[self viewWithTag:999]setAlpha:0];
	}
	
}

-(void)setText:(NSString *)text{
	[super setText:text];
	[self textChanged:nil];
}

-(void)drawRect:(CGRect)rect{
	if ([self.placeholder length]>0) {
		if (placeholderLabel==nil) {
			placeholderLabel=[[[UILabel alloc]initWithFrame:CGRectMake(8.0f, 8.0f, self.bounds.size.width,16.0f)]autorelease];
			placeholderLabel.lineBreakMode=UILineBreakModeWordWrap;
			placeholderLabel.numberOfLines=0;
			placeholderLabel.font=self.font;
			placeholderLabel.backgroundColor=[UIColor clearColor];
			placeholderLabel.textColor=self.placeholderColor;
			placeholderLabel.alpha=0;
			placeholderLabel.tag=999;
			[self addSubview:placeholderLabel];
		}
		
		placeholderLabel.text=self.placeholder;
		[placeholderLabel sizeToFit];
		[self sendSubviewToBack:placeholderLabel];
	}
	
	if([self.text length]==0&&[self.placeholder length]>0){
		[[self viewWithTag:999] setAlpha:1];
	}
	[super drawRect:rect];
	
}


@end
