//  字体设置－tableViewCell
//  FontTableViewCell.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 10/6/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "FontTableViewCell.h"

@interface FontTableViewCell()

@property (nonatomic,retain) UIImageView *checkedImgView;


@end

@implementation FontTableViewCell

@synthesize isChecked;
@synthesize fontLabel=_fontLabel;
@synthesize checkedImgView=_checkedImgView;

- (void)dealloc{
    [_fontLabel release],_fontLabel=nil;
    [_checkedImgView release],_checkedImgView=nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        _fontLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 30)];
        _fontLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:_fontLabel];
        
        _checkedImgView=[[UIImageView alloc]initWithFrame:CGRectMake(260, 0, 40, 40)];
		_checkedImgView.image=[UIImage imageNamed:@"checked.png"];
		_checkedImgView.alpha=0.0;
        [self addSubview:self.checkedImgView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIsChecked:(BOOL)_isChecked{
	if (isChecked!=_isChecked) {
		isChecked=_isChecked;
	}
	if (isChecked) {
		self.checkedImgView.alpha=1.0;
	}else {
		self.checkedImgView.alpha=0.0;
	}
    
}

@end
