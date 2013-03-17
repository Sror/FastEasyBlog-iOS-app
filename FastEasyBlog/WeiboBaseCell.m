//
//  WeiboBaseCell.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/12/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "WeiboBaseCell.h"

@interface WeiboBaseCell ()

@property (nonatomic,retain) UIImageView *headImgView;

@end

@implementation WeiboBaseCell

@synthesize headImgView,
			headImage,
			userName,
			comeFrom,
			publishDate;

-(void)dealloc{
	//properties
	[headImage release],headImage=nil;
	[userName release],userName=nil;
	[comeFrom release],comeFrom=nil;
    
    //fields
	[topView release],topView=nil;
	[contentView release],contentView=nil;
	[footerView release],footerView=nil;
	[headImgView release],headImgView=nil;
	[nameLabel release],nameLabel=nil;
	[comeFromLabel release],comeFromLabel=nil;
    [dateLabel release],dateLabel=nil;
	
	[super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        // top view(容器)
        topView=[[UIView alloc]initWithFrame:CGRectMake(0,0,320,50)];
        [self addSubview:topView];
        
        //头像
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(10,10,40,40)];
		self.headImgView=imgView;
		[imgView release];
        [topView addSubview:self.headImgView];
        
        //用户名称
        nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(53,18,165,20)];
        [nameLabel setFont:[UIFont systemFontOfSize:16]];
        [nameLabel setTextColor:defaultNavigationBGColor];
        nameLabel.textAlignment=UITextAlignmentLeft;
        [topView addSubview:nameLabel];
        
        //发表时间
        dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(230, 18, 80, 20)];
        [dateLabel setFont:[UIFont systemFontOfSize:11]];
        dateLabel.textAlignment=UITextAlignmentRight;
        [topView addSubview:dateLabel];
        
        //content view(容器)
        contentView=[[UIView alloc]initWithFrame:CGRectZero];		//高度不定
        contentView.tag=7000;
        [self addSubview:contentView];
        
        //footer view(容器)
        footerView=[[UIView alloc]initWithFrame:CGRectZero];		//高度不定(随内容视图高度而定)
        footerView.tag=7001;
        [self addSubview:footerView];
        comeFromLabel=[[UILabel alloc]initWithFrame:CGRectMake(125,0,180,20)];
        comeFromLabel.textAlignment=UITextAlignmentRight;
        comeFromLabel.font=[UIFont systemFontOfSize:13.0f];
        
        [footerView addSubview:comeFromLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//重载系统默认产生的set方法
-(void)setHeadImage:(UIImage*)_img{
	if(_img!=headImage){
		[headImage release];
		headImage=[_img retain];
	}
	headImgView.image=_img;
}

-(void)setUserName:(NSString*)_userName{
	if(_userName!=userName){
		[userName release];
		userName=[_userName retain];
	}
	nameLabel.text=_userName;
}

-(void)setComeFrom:(NSString*)_comeFrom{
	if(_comeFrom!=comeFrom){
		[comeFrom release];
		comeFrom=[_comeFrom retain];
	}
	comeFromLabel.text=[NSString stringWithFormat:@"来自:%@",_comeFrom];
}

-(void)setPublishDate:(NSString*)_publishDate{
	if(_publishDate!=publishDate){
		[publishDate release];
		publishDate=[_publishDate retain];
	}
	dateLabel.text=_publishDate;
}


@end
