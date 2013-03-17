//
//  TencentWeibBoInfo.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-2.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TencentWeiboInfo : NSObject{
    NSString *text;
    NSString *origtext;
    int count;
    int mcount;
    NSString *from;
    NSString *fromurl;
    NSString *uniqueId;
    NSArray *image;
    NSMutableDictionary *video;
    NSMutableDictionary *music;
    NSString *name;
    NSString *openid;
    NSString *nick;
    BOOL *isSelf;
    long timestamp;
    int type;
    NSString *head;
    NSString *location;
    NSString *country_code;
    NSString *province_code;
    NSString *city_code;
    BOOL *isvip;
    NSString *geo;
    NSInteger *status;
    NSString *emotionurl;
    NSString *emotiontype;
    TencentWeiboInfo *source;
    
    //追加屬性
    UIImage *headImg;       //头像
    UIImage *weiboImg;      //微博图片
    UIImage *sourceImg;     //原始微博图片
}

@property (nonatomic,retain) NSString *text;
@property (nonatomic,retain) NSString *origtext;
@property (nonatomic,assign) int count;
@property (nonatomic,assign) int mcount;
@property (nonatomic,retain) NSString *from;
@property (nonatomic,retain) NSString *fromurl;
@property (nonatomic,retain) NSString *uniqueId;
@property (nonatomic,retain) NSArray *image;
@property (nonatomic,retain) NSMutableDictionary *video;
@property (nonatomic,retain) NSMutableDictionary *music;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *openid;
@property (nonatomic,retain) NSString *nick;
@property (nonatomic,assign) BOOL *isSelf;
@property (nonatomic,assign) long timestamp;
@property (nonatomic,assign) int type;
@property (nonatomic,retain) NSString *head;
@property (nonatomic,retain) NSString *location;
@property (nonatomic,retain) NSString *country_code;
@property (nonatomic,retain) NSString *province_code;
@property (nonatomic,retain) NSString *city_code;
@property (nonatomic,assign) BOOL *isvip;
@property (nonatomic,retain) NSString *geo;
@property (nonatomic,assign) NSInteger *status;
@property (nonatomic,retain) NSString *emotionurl;
@property (nonatomic,retain) NSString *emotiontype;
@property (nonatomic,retain) TencentWeiboInfo *source;

@property (nonatomic,retain) UIImage *headImg;
@property (nonatomic,retain) UIImage *weiboImg;
@property (nonatomic,retain) UIImage *sourceImg;

@end
