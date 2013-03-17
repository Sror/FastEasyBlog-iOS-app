//
//  RenRenNewsCategoryCell.m
//  FastEasyBlog
//
//  Created by svp on 19.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "RenRenNewsCategoryCell.h"

@interface RenRenNewsCategoryCell ()

@property (nonatomic,retain) UILabel *categoryNameLabel;
@property (nonatomic,retain) UIImageView *checkedImgView;

@end

@implementation RenRenNewsCategoryCell

@synthesize isChecked,categoryName,categoryImgView,categoryNameLabel,checkedImgView;

- (void)dealloc {
	[categoryName release];				categoryName=nil;
	[categoryImgView release];			categoryImgView=nil;
	[categoryNameLabel release];		categoryNameLabel=nil;
	[checkedImgView release];			checkedImgView=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor blackColor];
        UIImageView *tmpCategoryImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
		self.categoryImgView=tmpCategoryImgView;
        [self addSubview:self.categoryImgView];
		[tmpCategoryImgView release];
		
		UILabel *tmpCategoryNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(42, 0, 120, 40)];
		self.categoryNameLabel=tmpCategoryNameLabel;
        [self addSubview:self.categoryNameLabel];
		[tmpCategoryNameLabel release];
		
		UIImageView *tmpCheckedImgView=[[UIImageView alloc]initWithFrame:CGRectMake(200, 0, 40, 40)];
		tmpCheckedImgView.image=[UIImage imageNamed:@"checked.png"];
		tmpCheckedImgView.alpha=0.0;
		self.checkedImgView=tmpCheckedImgView;
        [self addSubview:self.checkedImgView];
		[tmpCheckedImgView release];
											  
    }
    return self;
}


- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    if (!selected) {
        self.checkedImgView.alpha=0.0;
    }
}

- (void)setCategoryName:(NSString *)_categoryName{
	if (categoryName!=_categoryName) {
		[categoryName release];
		categoryName=[_categoryName retain];
	}
	self.categoryNameLabel.text=_categoryName;
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
