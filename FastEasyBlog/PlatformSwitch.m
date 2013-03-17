//
//  PlatformSwitch.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-7-26.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import "PlatformSwitch.h"

@implementation PlatformSwitch

@synthesize isRenRenOpen,isSinaWeiboOpen,isTencentWeiboOpen,isTianyaOpen;
@synthesize isRenRenCanOpen,isSinaWeiboCanOpen,isTencentWeiboCanOpen,isTianyaCanOpen;

-(id)init{
    self=[super init];
    if (self) {
        isRenRenOpen=NO;
        isSinaWeiboOpen=NO;
        isTencentWeiboOpen=NO;
        isTianyaOpen=NO;
        
        isRenRenCanOpen=NO;
        isSinaWeiboCanOpen=NO;
        isTencentWeiboCanOpen=NO;
        isTianyaCanOpen=NO;
    }
    
    return self;
}

-(void)dealloc{
    [super dealloc];
}

@end
