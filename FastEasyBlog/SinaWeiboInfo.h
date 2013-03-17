//
//  SinaWeiboInfo.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-3.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SinaWeiboUser;

@interface SinaWeiboInfo : NSObject{
    NSString *idstr;                        //字符串格式的圍脖id
    NSString *created_at;                  
    long long uniquiedId;
    NSString *text;
    NSString *source;
    BOOL favorited;
    BOOL truncated;
    NSString *in_reply_to_status_id;
    NSString *in_reply_to_user_id;
    NSString *in_reply_to_screen_name;
    NSString *geo;
    NSString *mid;
    NSString *bmiddle_pic;                      //中等圖片地址
    NSString *original_pic;                     //原始圖片地址
    NSString *thumbnail_pic;                    //縮略圖片地址
    int reposts_count;
    int comments_count;
    NSArray *annotations;
    SinaWeiboUser *user;
    SinaWeiboInfo *retweeted_status;
    
    //圖片顯示相關
    UIImage *headImg;
    UIImage *weiboImg;
    UIImage *sourceImg;
}

@property (nonatomic,retain) NSString *idstr;
@property (nonatomic,retain) NSString *created_at;
@property (nonatomic,assign) long long uniquiedId;
@property (nonatomic,retain) NSString *text;
@property (nonatomic,retain) NSString *source;
@property (nonatomic,assign) BOOL favorited;
@property (nonatomic,assign) BOOL truncated;
@property (nonatomic,retain) NSString *in_reply_to_status_id;
@property (nonatomic,retain) NSString *in_reply_to_user_id;
@property (nonatomic,retain) NSString *in_reply_to_screen_name;
@property (nonatomic,retain) NSString *geo;
@property (nonatomic,retain) NSString *mid;
@property (nonatomic,retain) NSString *bmiddle_pic;
@property (nonatomic,retain) NSString *original_pic;
@property (nonatomic,retain) NSString *thumbnail_pic;
@property (nonatomic,assign) int reposts_count;
@property (nonatomic,assign) int comments_count;
@property (nonatomic,retain) NSArray *annotations;
@property (nonatomic,retain) SinaWeiboUser *user;
@property (nonatomic,retain) SinaWeiboInfo *retweeted_status;

@property (nonatomic,retain) UIImage *headImg;
@property (nonatomic,retain) UIImage *weiboImg;
@property (nonatomic,retain) UIImage *sourceImg;

@end
