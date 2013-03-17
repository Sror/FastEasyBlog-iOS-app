//
//  SinaWeiboInfo.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-3.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import "SinaWeiboInfo.h"

@implementation SinaWeiboInfo

@synthesize idstr,
            created_at,
            uniquiedId,
            text,
            source,
            favorited,
            truncated,
            in_reply_to_status_id,
            in_reply_to_user_id,
            in_reply_to_screen_name,
            geo,
            mid,
            bmiddle_pic,
            original_pic,
            thumbnail_pic,
            reposts_count,
            comments_count,
            annotations,
            user,
            retweeted_status,
            headImg,
            weiboImg,
            sourceImg;

- (void)dealloc{
    [idstr release],idstr=nil;
    [created_at release],created_at=nil;
    [text release],text=nil;
    [source release],source=nil;
    [in_reply_to_user_id release],in_reply_to_user_id=nil;
    [in_reply_to_status_id release],in_reply_to_status_id=nil;
    [in_reply_to_screen_name release],in_reply_to_screen_name=nil;
    [geo release],geo=nil;
    [mid release],mid=nil;
    [bmiddle_pic release],bmiddle_pic=nil;
    [original_pic release],original_pic=nil;
    [thumbnail_pic release],thumbnail_pic=nil;
    [annotations release],annotations=nil;
    [user release],user=nil;
    [retweeted_status release],retweeted_status=nil;
    
    [headImg release],headImg=nil;
    [weiboImg release],weiboImg=nil;
    [sourceImg release],sourceImg=nil;
    [super dealloc];
}

@end
