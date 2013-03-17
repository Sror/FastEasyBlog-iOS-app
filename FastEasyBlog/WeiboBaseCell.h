//
//  WeiboBaseCell.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/12/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboBaseCell : UITableViewCell{
    //容器视图
	UIView *topView;                    //顶部容器视图
	UIView *contentView;				//内容区域视图
	UIView *footerView;                 //底部容器视图
	
	UIImageView *headImgView;				//头像
	UIImage *headImage;                 
	
	UILabel *nameLabel;					//用户名称
	NSString *userName;                 
	
	UILabel *comeFromLabel;				//来自
	NSString *comeFrom;
    
    NSString *publishDate;              //发表日期
	UILabel *dateLabel;
}


@property (nonatomic,retain) UIImage *headImage;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *comeFrom;
@property (nonatomic,copy) NSString *publishDate;

@end
