//
//  SinaWeiboComment.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-28.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import "SinaWeiboComment.h"

@implementation SinaWeiboComment

@synthesize created_at,
            uniquiedId,
            text,
            source,
            mid,
            user,
            status,
            reply_comment,
			headImg;

- (void)dealloc{
    [created_at release],created_at=nil;
    [text release],text=nil;
    [source release],source=nil;
    [user release],user=nil;
    [status release],status=nil;
    [reply_comment release],reply_comment=nil;
	[headImg release],headImg=nil;
    [super dealloc];
}

- (id)init{
    if (self=[super init]) {
        
    }
    return self;
}

@end
