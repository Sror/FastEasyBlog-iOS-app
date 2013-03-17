//
//  RenRenNewsTableViewCell.h
//  FastEasyBlog
//
//  Created by svp on 07.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TABLE_HEADER_HEIGHT 50.0f
#define TABLE_FOOTER_HEIGHT 20.0f

#define CELL_CONTENT_MARGIN 0.0f
#define MIN_CONTENT_HEIGHT 20.0f
#define CELL_CONTENT_WIDTH 245.0f
#define CELL_CONTENT_MARGIN 0.0f
#define MIN_CONTENT_HEIGHT 20.0f
#define DEFAULT_CONSTRAINT_SIZE CGSizeMake(CELL_CONTENT_WIDTH-(CELL_CONTENT_MARGIN*2),20000.f)

@interface RenRenNewsTableViewCell : UITableViewCell {
	UIImage *headImage;                 //头像
	NSString *userName;                 //用户名称
	NSString *publishDate;              //发表日期
    NSString *feedType;                 //新鮮事類別
	
	UIImageView *headImgView;
    UIImageView *categoryImageView;     //類別
	
	
	UILabel *nameLabel;
	UILabel *dateLabel;
	
	UIView *topView;                    //顶部容器视图
	UIView *footerView;                 //底部容器视图
}

@property (nonatomic,retain) UIView *topView;
@property (nonatomic,retain) UIView *footerView;

@property (nonatomic,retain) UIImage *headImage;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *publishDate;
@property (nonatomic,copy) NSString *feedType;

//重置视图的边框(子类中override)
- (void)resizeViewFrames;

@end
