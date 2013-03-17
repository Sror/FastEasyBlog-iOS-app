//
//  SinaWeiboUser.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-3.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SinaWeiboUser : NSObject{
    long uniquedId;
    NSString *screen_name;
    NSString *name;
    NSString *province;
    NSString *city;
    NSString *location;
    NSString *description;
    NSString *url;
    NSString *profile_image_url;
    NSString *domain;
    NSString *gender;
    NSString *followers_count;
    NSString *friends_count;
    NSString *statuses_count;
    NSString *favourites_count;
    NSString *created_at;
    BOOL *following;
    BOOL *allow_all_msg;
    NSString *remark;
    BOOL *geo_enabled;
    BOOL *verified;
    BOOL *allow_all_comment;
    NSString *avatar_large;
    NSString *verified_reason;
    BOOL *follow_me;
    NSString *online_status;
    NSString *bi_followers_count;
}

@property (nonatomic,assign) long uniquedId;
@property (nonatomic,retain) NSString *screen_name;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *province;
@property (nonatomic,retain) NSString *city;
@property (nonatomic,retain) NSString *location;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSString *url;
@property (nonatomic,retain) NSString *profile_image_url;
@property (nonatomic,retain) NSString *domain;
@property (nonatomic,retain) NSString *gender;
@property (nonatomic,retain) NSString *followers_count;
@property (nonatomic,retain) NSString *friends_count;
@property (nonatomic,retain) NSString *statuses_count;
@property (nonatomic,retain) NSString *favourites_count;
@property (nonatomic,retain) NSString *created_at;
@property (nonatomic,assign) BOOL *following;
@property (nonatomic,assign) BOOL *allow_all_msg;
@property (nonatomic,retain) NSString *remark;
@property (nonatomic,assign) BOOL *geo_enabled;
@property (nonatomic,assign) BOOL *verified;
@property (nonatomic,assign) BOOL *allow_all_comment;
@property (nonatomic,retain) NSString *avatar_large;
@property (nonatomic,retain) NSString *verified_reason;
@property (nonatomic,assign) BOOL *follow_me;
@property (nonatomic,retain) NSString *online_status;
@property (nonatomic,retain) NSString *bi_followers_count;

@end
