//
//  UIPlaceHolderTextView.m
//  RenRenTest
//
//  Created by svp on 12.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "UIPlaceHolderTextView.h"


@implementation UIPlaceHolderTextView

@synthesize placeholderLabel;
@synthesize placeholder;
@synthesize placeholderColor;

-(void)dealloc{
	[[NSNotificationCenter defaultCenter]removeObserver:self];
	[placeholderLabel release];		
	[placeholderColor release];		
	[placeholder release];			
	[super dealloc];
}

//当Nib文件被加载时，Nib会向每个对象发送一条该消息，以允许对象实现自己的处理逻辑
-(void)awakeFromNib{
	[super awakeFromNib];
	[self setPlaceholder:@""];
	[self setPlaceholderColor:[UIColor lightGrayColor]];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}
	 
 -(id)initWithFrame:(CGRect)frame{
	if (self=[super initWithFrame:frame]) {
		[self setPlaceholder:@""];
		[self setPlaceholderColor:[UIColor lightGrayColor]];
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
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
		if (self.placeholderLabel==nil) {
			UILabel *tmpLabel=[[UILabel alloc]initWithFrame:CGRectMake(8.0f, 8.0f, self.bounds.size.width,16.0f)];
			self.placeholderLabel=tmpLabel;
		  self.placeholderLabel.lineBreakMode=UILineBreakModeWordWrap;
		  self.placeholderLabel.numberOfLines=0;
		  self.placeholderLabel.font=self.font;
		  self.placeholderLabel.backgroundColor=[UIColor clearColor];
		  self.placeholderLabel.textColor=self.placeholderColor;
		  self.placeholderLabel.alpha=0;
		  self.placeholderLabel.tag=999;
		  [self addSubview:placeholderLabel];
			[tmpLabel release];
		}
								
		self.placeholderLabel.text=self.placeholder;
		[self.placeholderLabel sizeToFit];
		[self sendSubviewToBack:self.placeholderLabel];
	}

	if([self.text length]==0&&[self.placeholder length]>0){
		[[self viewWithTag:999] setAlpha:1];
	}
	[super drawRect:rect];
								
	
 }
		 
		 
@end
