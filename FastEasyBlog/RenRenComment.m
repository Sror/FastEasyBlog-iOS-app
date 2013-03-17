//
//  RenRenComment.m
//  FastEasyBlog
//
//  Created by svp on 04.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "RenRenComment.h"


@implementation RenRenComment

@synthesize identifier,uid,name,headurl,time,comment_id,text,headImg,ownerId;

-(void)dealloc{
    [identifier release],identifier=nil;
	[uid release],uid=nil;
	[name release],name=nil;
	[headurl release],headurl=nil;
	[time release],time=nil;
	[comment_id release],comment_id=nil;
	[text release],text=nil;
    [headImg release],headImg=nil;
    [ownerId release],ownerId=nil;
	[super dealloc];
}

-(id)init{
		if (self=[super init]) {
			//init 
		}
	return self;
}

@end
