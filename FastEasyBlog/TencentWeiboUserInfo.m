//
//  TencentWeiboUserInfo.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/9/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "TencentWeiboUserInfo.h"

@implementation TencentWeiboUserInfo

@synthesize uniquedId,
            name,
            nick,
            head;

- (id)init{
    self=[super init];
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc{
    [uniquedId release],uniquedId=nil;
    [name release],name=nil;
	[nick release],nick=nil;
	[head release],head=nil;
    
    [super dealloc];
}

@end

