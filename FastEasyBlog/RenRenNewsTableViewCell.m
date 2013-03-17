//
//  RenRenNewsTableViewCell.m
//  FastEasyBlog
//
//  Created by svp on 07.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "RenRenNewsTableViewCell.h"
#import "Global.h"

@interface RenRenNewsTableViewCell () 

@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UILabel *dateLabel;
@property (nonatomic,retain) UIImageView *categoryImageView;
@property (nonatomic,retain) UIImageView *headImgView;

@end


@implementation RenRenNewsTableViewCell

@synthesize headImage;
@synthesize userName;
@synthesize publishDate;
@synthesize feedType;

@synthesize topView;
@synthesize footerView;

@synthesize headImgView;
@synthesize nameLabel;
@synthesize categoryImageView;
@synthesize dateLabel;

-(void)dealloc{
	userName=nil;
	publishDate=nil;
	feedType=nil;
	
	[headImage release];
    [categoryImageView release];
	[headImgView release];
	[nameLabel release];
	[dateLabel release];
	
	[topView release];
	[footerView release];
	
	[super dealloc];
}

-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier{
	self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle=UITableViewCellSelectionStyleNone;
		
		//顶部容器视图
		UIView *tmpTopView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
		self.topView=tmpTopView;
		[tmpTopView release];
		self.topView.tag=8888;
		[self addSubview:self.topView];
		
		//头像
		UIImageView *tmpImgView=[[UIImageView alloc]init];
		[tmpImgView setFrame:CGRectMake(10, 10, 40, 40)];
		 self.headImgView=tmpImgView;
		 [self.topView addSubview:self.headImgView];
		[tmpImgView release];
		
		//名称
		UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(53,18,100,20)];
		[lblName setFont:[UIFont systemFontOfSize:16]];
		[lblName setTextColor:defaultNavigationBGColor];
		lblName.textAlignment=UITextAlignmentLeft;
		self.nameLabel=lblName;
		[lblName release];
		[self.topView addSubview:self.nameLabel];
        
        //類別
        UIImageView *tmpCategoryImageView=[[UIImageView alloc]initWithFrame:CGRectMake(285, 18, 20, 20)];
        self.categoryImageView=tmpCategoryImageView;
        [self.topView addSubview:self.categoryImageView];
        [tmpCategoryImageView release];
		
		//底部容器视图
		UIView *tmpFooterView=[[UIView alloc]initWithFrame:CGRectZero];
		self.footerView=tmpFooterView;
		[tmpFooterView release];
		self.footerView.tag=8890;
		[self addSubview:self.footerView];
		
		//发表日期
		UILabel *lblDate=[[UILabel alloc]initWithFrame:CGRectMake(225, 0, 85, 20)];
		[lblDate setFont:[UIFont systemFontOfSize:11]];
		lblDate.textAlignment=UITextAlignmentRight;
		self.dateLabel=lblDate;
		[lblDate release];
		[self.footerView addSubview:self.dateLabel];
		
	}
	
	return self;
}

//重载系统默认产生的set方法
-(void)setHeadImage:(UIImage*)_img{
    if (headImage!=_img) {
        [headImage release];
        headImage=[_img retain];
    }
    self.headImgView.image=_img;
}

-(void)setUserName:(NSString*)_userName{
    if (!userName||[_userName isNotEqualToString:_userName]) {
        [userName release];
        userName=[_userName retain];
    }
	self.nameLabel.text=_userName;
}

-(void)setPublishDate:(NSString*)_publishDate{
    if (!publishDate||[publishDate isNotEqualToString:_publishDate]) {
        [publishDate release];
        publishDate=[_publishDate retain];
    }
	self.dateLabel.text=_publishDate;
}


-(void)setFeedType:(NSString *)_feedType{
	//状态
    if ([_feedType intValue]==10||[_feedType intValue]==11) {
        self.categoryImageView.image=[UIImage imageNamed:@"statusIcon-large.png"];
    }else if([_feedType intValue]==20||[_feedType intValue]==22){
		self.categoryImageView.image=[UIImage imageNamed:@"blogIcon-large.png"];
	}else if([_feedType intValue]==30||[_feedType intValue]==31){
        self.categoryImageView.image=[UIImage imageNamed:@"photoIcon-large.png"];
    }else if([_feedType intValue]==21||[_feedType intValue]==23||[_feedType intValue]==32||[_feedType intValue]==36){
        self.categoryImageView.image=[UIImage imageNamed:@"shareIcon-large.png"];
    }
}

/*
 *重置视图的边框(子类中override)
 */
- (void)resizeViewFrames{
    
}

@end
