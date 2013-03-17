//
//  SinaWeiboComment.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-28.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SinaWeiboUser;
@class SinaWeiboInfo;

@interface SinaWeiboComment : NSObject{
    NSString *created_at;                   //評論創建時間
    long long uniquiedId;                   //評論編號
    NSString *text;                         //評論內容
    NSString *source;                       //評論來源
    long long mid;                          //評論MID
    SinaWeiboUser *user;                    //評論的用戶信息
    SinaWeiboInfo *status;                  //評論的原圍脖信息
    NSMutableDictionary *reply_comment;     //回復的評論信息
	
	UIImage *headImg;
}

@property (nonatomic,retain) NSString *created_at;
@property (nonatomic,assign) long long uniquiedId;
@property (nonatomic,retain) NSString *text;
@property (nonatomic,retain) NSString *source;
@property (nonatomic,assign) long long mid;
@property (nonatomic,retain) SinaWeiboUser *user;
@property (nonatomic,retain) SinaWeiboInfo *status;
@property (nonatomic,retain) NSMutableDictionary *reply_comment;
@property (nonatomic,retain) UIImage *headImg;

@end
