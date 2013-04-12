//
//  WeiboCell.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/12/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboBaseCell.h"
#import "GlobalProtocols.h"
#import "UIImageView+WebCache.h"

#define TABLE_HEADER_HEIGHT 50.0f
#define TABLE_FOOTER_HEIGHT 20.0f
#define CELL_CONTENT_WIDTH 245.0f
#define CELL_CONTENT_MARGIN 0.0f
#define MIN_CONTENT_HEIGHT 20.0f
#define CELL_CONTENT_SOURCE_MARGIN 3.0f
#define DEFAULT_CONSTRAINT_SIZE CGSizeMake(CELL_CONTENT_WIDTH-(CELL_CONTENT_MARGIN*2),20000.f)

#define WEIBO_IMAGE_HEIGHT 120.0f
#define WEIBO_IMAGE_MIDDLE_HEIGHT 160.0f
#define IMAGE_MARGIN 3.0f

@interface WeiboCell : WeiboBaseCell{
    Class _originalShowImgClass;
}

@property (nonatomic,assign) id<WeiboImageDelegate> showWeiboImgDelegate;
@property (nonatomic,retain) NSString *txtWeibo;         	//文本微博
@property (nonatomic,retain) NSString *txtSourceWeibo;   	//原文（如果是转发，则会有原文）
@property (nonatomic,retain) UIImage *weiboImg;
@property (nonatomic,retain) UIImage *sourceImg;
@property (nonatomic,retain) NSString *imgUrl;
@property (nonatomic,retain) UIImageView *weiboImgView;      	//微博图片
@property (nonatomic,retain) UIImageView *sourceImgView;     	//原微博图片

@property (nonatomic,assign) BOOL hasWeiboImg;				//微博是否携带图片
@property (nonatomic,assign) BOOL hasSourceWeiboImg;		//源微博是否携带图片

//重置视图的边框/区域
- (void)resizeViewFrames;

@end
