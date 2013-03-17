//
//  TencentWeiboList.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 8/1/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "TencentWeiboList.h"

@implementation TencentWeiboList

@synthesize list,hasNext,pos;

- (id)init{
    self=[super init];
    if (self) {
        //init
    }
    
    return self;
}

- (void)dealloc{
    [list release],list=nil;
    [pos release],pos=nil;
    
    [super dealloc];
}


@end
