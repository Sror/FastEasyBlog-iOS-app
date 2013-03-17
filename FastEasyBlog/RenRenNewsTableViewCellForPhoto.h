//
//  RenRenNewsTableViewCellForStatus.h
//  FastEasyBlog
//
//  Created by svp on 08.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenRenNewsTableViewCell.h"
#import "UIImageView+WebCache.h"        //SDImageView

#define SMALL_PHOTO_WIDTH 100.0f
#define SMALL_PHOTO_HEIGHT 100.0f

@interface RenRenNewsTableViewCellForPhoto : RenRenNewsTableViewCell {
	NSString *desc;				//照片描述
    NSString *albumName;        //相册名称
    NSString *comeFrom;         //来源
	UIImage *photoImg;
    NSString *imgUrl;           //当前图片地址(用于显示大图)
	
    UILabel *albumNameLbl;
    UILabel *comeFromLbl;
	UIImageView *photoImgView;
    
    id<WeiboImageDelegate> showImgDelegate;
    
    Class _originalShowImgClass;
}

@property (nonatomic,assign) id<WeiboImageDelegate> showImgDelegate;
@property (nonatomic,retain) UIImage *photoImg;
@property (nonatomic,retain) NSString *desc;
@property (nonatomic,retain) NSString *albumName;
@property (nonatomic,retain) NSString *comeFrom;
@property (nonatomic,retain) UIImageView *photoImgView;
@property (nonatomic,retain) NSString *imgUrl;

@end
