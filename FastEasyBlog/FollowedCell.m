//
//  FollowedCell.m
//  FastEasyBlog
//
//  Created by svp on 19.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "FollowedCell.h"

@interface FollowedCell ()

@property (nonatomic,retain) UILabel *nickLbl;
@property (nonatomic,retain) UIImageView *headImgView;
@property (nonatomic,retain) UILabel *descLbl;

@end

@implementation FollowedCell

@synthesize nick=_nick;
@synthesize headImg=_headImg;
@synthesize nickLbl=_nickLbl;
@synthesize headImgView=_headImgView;
@synthesize desc=_desc;
@synthesize descLbl=_descLbl;

- (void)dealloc {
	[_nick release],_nick=nil;
	[_headImg release],_headImg=nil;
	
	[_nickLbl release],_nickLbl=nil;
	[_headImgView release],_headImgView=nil;
    
    [_desc release],_desc=nil;
    [_descLbl release],_descLbl=nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
		
        _headImgView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        [self addSubview:self.headImgView];
		
		_nickLbl=[[UILabel alloc]initWithFrame:CGRectMake(47, 5, 200, 20)];
        _nickLbl.textColor=defaultNavigationBGColor;
        _nickLbl.backgroundColor=[UIColor clearColor];
        [self addSubview:self.nickLbl];
        
        _descLbl=[[UILabel alloc]initWithFrame:CGRectMake(47, 25, 200, 20)];
        _descLbl.font=[UIFont systemFontOfSize:13.0f];
        [_descLbl setTextColor:RGBCOLOR(205,205,205)];
        _descLbl.backgroundColor=[UIColor clearColor];
        [self addSubview:self.descLbl];
    }
    return self;
}


- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setNick:(NSString *)__nick{
	if (!_nick||[_nick isNotEqualToString:__nick]) {
		[_nick release];
		_nick=[__nick retain];
	}
	self.nickLbl.text=_nick;
}

- (void)setHeadImg:(UIImage*)__headImg{
	if (_headImg!=__headImg) {
		[_headImg release];
		_headImg=[__headImg retain];
	}
	self.headImgView.image=_headImg;
}

- (void)setDesc:(NSString *)__desc{
    if (!_desc||[_desc isNotEqualToString:__desc]) {
        [_desc release];
        _desc=[__desc retain];
    }
    self.descLbl.text=_desc;
}

@end
