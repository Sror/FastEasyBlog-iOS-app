//
//  RenRenUserInfo.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/9/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "RenRenUserInfo.h"

@implementation RenRenUserInfo

@synthesize uniquedId,
            name,
            sex,
            star,
            zidou,
            birthday,
            email_hash,
            tinyurl,
            headurl,
            mainurl,
            hometown_location,
            work_history,
            university_history,
            hs_history;

- (void)dealloc{
    [uniquedId release],uniquedId=nil;
	[name release],name=nil;
	[birthday release],birthday=nil;
	[email_hash release],email_hash=nil;
	[tinyurl release],tinyurl=nil;
	[headurl release],headurl=nil;
	[mainurl release],mainurl=nil;
	[hometown_location release],hometown_location=nil;
	[work_history release],work_history=nil;
	[university_history release],university_history=nil;
	[hs_history release],hs_history=nil;
	[super dealloc];
}

- (id)init{
    self=[super init];
    if (self) {
        
    }
    
    return self;
}

@end

