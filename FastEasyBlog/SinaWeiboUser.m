//
//  SinaWeiboUser.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-3.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import "SinaWeiboUser.h"

@implementation SinaWeiboUser

@synthesize uniquedId,
            screen_name,
            name,
            province,
            city,
            location,
            description,
            url,
            profile_image_url,
            domain,
            gender,
            followers_count,
            friends_count,
            statuses_count,
            favourites_count,
            created_at,
            following,
            allow_all_msg,
            remark,
            geo_enabled,
            verified,
            allow_all_comment,
            avatar_large,
            verified_reason,
            follow_me,
            online_status,
            bi_followers_count;

- (id)init{
    self=[super init];
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc{
    [screen_name release],screen_name=nil;
    [name release],name=nil;
    [province release],province=nil;
    [city release],city=nil;
    [location release],location=nil;
    [description release],description=nil;
    [url release],url=nil;
    [profile_image_url release],profile_image_url=nil;
    [domain release],domain=nil;
    [gender release],gender=nil;
    [followers_count release],followers_count=nil;
    [friends_count release],friends_count=nil;
    [statuses_count release],statuses_count=nil;
    [favourites_count release],favourites_count=nil;
    [created_at release],created_at=nil;
    [remark release],remark=nil;
    [avatar_large release],avatar_large=nil;
    [verified_reason release],verified_reason=nil;
    [online_status release],online_status=nil;
    [bi_followers_count release],bi_followers_count=nil;
    
    [super dealloc];
}

@end
