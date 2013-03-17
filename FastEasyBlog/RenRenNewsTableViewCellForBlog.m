//
//  RenRenNewsTableViewCellForBlog.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-7-13.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import "RenRenNewsTableViewCellForBlog.h"

@interface RenRenNewsTableViewCellForBlog () 

@property (nonatomic,retain) UIView *blogView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *introductionLabel;

@end


@implementation RenRenNewsTableViewCellForBlog

@synthesize title;
@synthesize introduction;
@synthesize blogView;
@synthesize titleLabel;
@synthesize introductionLabel;

- (void)dealloc{
    title=nil;
    introduction=nil;
    [blogView release];
    [titleLabel release];
    [introductionLabel release];
	[super dealloc];
	
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
		//日志整个区域
		UIView *tmpBlogView=[[UIView alloc]initWithFrame:CGRectZero];
		tmpBlogView.tag=8891;
		self.blogView=tmpBlogView;
		[self addSubview:self.blogView];
        [tmpBlogView release];
		
		//日志的标题
		UILabel *tmpTitleLabel=[[UILabel alloc]initWithFrame:CGRectZero];
		tmpTitleLabel.tag=8892;
		[tmpTitleLabel setMinimumFontSize:15];
		[tmpTitleLabel setNumberOfLines:0];
		[tmpTitleLabel setLineBreakMode:UILineBreakModeWordWrap];
		[tmpTitleLabel setFont:[UIFont boldSystemFontOfSize:15]];
		self.titleLabel=tmpTitleLabel;
		[self.blogView addSubview:self.titleLabel];
		[tmpTitleLabel release];
		
		
		//日志内容简介
		UILabel *tmpIntroductionLabel=[[UILabel alloc]initWithFrame:CGRectZero];
		tmpIntroductionLabel.tag=8893;
		tmpIntroductionLabel.backgroundColor=RGBCOLOR(235,235,235);
		[tmpIntroductionLabel setMinimumFontSize:15];
		[tmpIntroductionLabel setNumberOfLines:0];
		[tmpIntroductionLabel setLineBreakMode:UILineBreakModeWordWrap];
		[tmpIntroductionLabel setFont:RENRENBLOGINTRODUCTIONFONT];
		self.introductionLabel=tmpIntroductionLabel;
		[self.blogView addSubview:self.introductionLabel];
		[tmpIntroductionLabel release];
		
	}

	return self;
}

/*
 *重写系统自带的set方法
 */
- (void)setTitle:(NSString *)_title{
	if(!title||[title isNotEqualToString:_title]){
		[title release];
		title=[_title retain];
	}
	self.titleLabel.text=title;
}

- (void)setIntroduction:(NSString *)_introduction{
	if(!introduction||[introduction isNotEqualToString:_introduction]){
		[introduction release];
		introduction=[_introduction retain];
	}
	self.introductionLabel.text=introduction;
}

#pragma mark - override super class's public method -
-(void)resizeViewFrames{
    [super resizeViewFrames];
	CGFloat titleHeight=[GlobalInstance getHeightWithText:self.title fontSize:15 constraint:DEFAULT_CONSTRAINT_SIZE minHeight:MIN_CONTENT_HEIGHT];
	CGFloat introductionHeight=[GlobalInstance getHeightWithFontText:self.introduction font:RENRENBLOGINTRODUCTIONFONT constraint:DEFAULT_CONSTRAINT_SIZE minHeight:MIN_CONTENT_HEIGHT];
	
	//日志区域(super view)
	[self.blogView setFrame:CGRectMake(50+CELL_CONTENT_MARGIN, 50+CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH-(CELL_CONTENT_MARGIN*2), titleHeight+introductionHeight)];
	CGFloat contentViewHeight=self.blogView.frame.size.height;
	
	//日志标题(sub view)
	[self.titleLabel setFrame:CGRectMake(0, 0, CELL_CONTENT_WIDTH-(CELL_CONTENT_MARGIN*2), titleHeight)];
	
	//日志描述(sub view)
	[self.introductionLabel setFrame:CGRectMake(3, titleHeight+CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH-(CELL_CONTENT_MARGIN*2)-3, introductionHeight)];
	
	//底部容器(super view)
	[self.footerView setFrame:CGRectMake(0, CELL_CONTENT_MARGIN+50.0f+contentViewHeight+5.0f, self.frame.size.width, TABLE_FOOTER_HEIGHT)];
}

@end
