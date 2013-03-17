//
//  Followed.m
//  FastEasyBlog
//
//  Created by svp on 04.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "Followed.h"

@implementation Followed

@synthesize headImg;
@synthesize headImgUrl;
@synthesize nick;
@synthesize userId;
@synthesize desc;

-(void)dealloc{
	[headImg release],headImg=nil;
	[headImgUrl release],headImgUrl=nil;
	[nick release],nick=nil;
	[userId release],userId=nil;
    [desc release],desc=nil;
	
	[super dealloc];
}

-(id)init{
    if (self=[super init]) {
        //init
    }
	
	return self;
}

@end
