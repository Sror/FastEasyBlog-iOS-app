//
//  ShareAndBindTableViewCell.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/9/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "ShareAndBindTableViewCell.h"
#import "ExtensionMethods.h"

@implementation ShareAndBindTableViewCell

@synthesize headImg=_headImg;
@synthesize platformName=_platformName;
@synthesize bindOrNot=_bindOrNot;

- (void)dealloc{
    [headImgView release],headImgView=nil;
    [platformNameLbl release],platformNameLbl=nil;
    [bindOrNotLbl release],bindOrNotLbl=nil;
    
    [_headImg release],_headImg=nil;
    [_platformName release],_platformName=nil;
    [_bindOrNot release],_bindOrNot=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        //head image view
        headImgView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 32, 32)];
        headImgView.backgroundColor=[UIColor clearColor];
        [self addSubview:headImgView];
        
        //platform label
        platformNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 100, 30)];
        platformNameLbl.backgroundColor=[UIColor clearColor];
        [self addSubview:platformNameLbl];
        
        //bindOrNot label
        bindOrNotLbl=[[UILabel alloc]initWithFrame:CGRectMake(235, 10, 60, 30)];
        [bindOrNotLbl setBackgroundColor:[UIColor clearColor]];
        [self addSubview:bindOrNotLbl];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -override setter-
- (void)setHeadImg:(UIImage *)headImg{
    if (_headImg!=headImg) {
        [_headImg release];
        _headImg=[headImg retain];
    }
    headImgView.image=headImg;
}

- (void)setPlatformName:(NSString *)platformName{
    if ((!_platformName)||[_platformName isNotEqualToString:platformName]) {
        [_platformName release];
        _platformName=[platformName retain];
    }
    platformNameLbl.text=platformName;
}

- (void)setBindOrNot:(NSString *)bindOrNot{
    if ((!_bindOrNot)||[_bindOrNot isNotEqualToString:bindOrNot]) {
        [_bindOrNot release];
        _bindOrNot=[bindOrNot retain];
    }
    bindOrNotLbl.text=_bindOrNot;
}

@end
