//
//  RenRenNewsTableViewCellForStatus.m
//  FastEasyBlog
//
//  Created by svp on 08.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "RenRenNewsTableViewCellForStatus.h"
#import "Global.h"

@interface RenRenNewsTableViewCellForStatus () 

@property (nonatomic,retain) UILabel *statusLabel;

@end


@implementation RenRenNewsTableViewCellForStatus

@synthesize statusContent;
@synthesize statusLabel;

-(void)dealloc{
	[statusContent release],statusContent=nil;
	[statusLabel release],statusLabel=nil;
	[super dealloc];
}

-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier{
	self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle=UITableViewCellSelectionStyleNone;
		UILabel *lblStatus=[[UILabel alloc]initWithFrame:CGRectZero];
		[lblStatus setMinimumFontSize:15];
		[lblStatus setNumberOfLines:0];
		[lblStatus setLineBreakMode:UILineBreakModeWordWrap];
		[lblStatus setFont:RENRENSTATUSFONT];
		self.statusLabel=lblStatus;
		self.statusLabel.tag=8889;
		[self addSubview:self.statusLabel];
		[lblStatus release];
	}
	
	return self;
}

-(void)setStatusContent:(NSString*)_statusContent{
    if (!statusContent||[statusContent isNotEqualToString:_statusContent]) {
        [statusContent release];
        statusContent=[_statusContent retain];
    }
	self.statusLabel.text=_statusContent;
}

#pragma mark - override super class's public method -
-(void)resizeViewFrames{
    [super resizeViewFrames];
    CGFloat statusHeight=[GlobalInstance getHeightWithFontText:self.statusContent 
                                                          font:RENRENSTATUSFONT 
                                                    constraint:DEFAULT_CONSTRAINT_SIZE 
                                                     minHeight:MIN_CONTENT_HEIGHT];
    
    //状态
	self.statusLabel.frame=CGRectMake(
                                      50+CELL_CONTENT_MARGIN, 
                                      50+CELL_CONTENT_MARGIN, 
                                      CELL_CONTENT_WIDTH-(CELL_CONTENT_MARGIN*2), 
                                      statusHeight);
	
	//底部视图
	self.footerView.frame=CGRectMake(
                                     0, 
                                     CELL_CONTENT_MARGIN+50.0f+self.statusLabel.frame.size.height+5.0f, 
                                     self.frame.size.width, 
                                     TABLE_FOOTER_HEIGHT);
}

@end

