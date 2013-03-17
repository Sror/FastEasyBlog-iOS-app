//
//  RenRenAttachment.m
//  FastEasyBlog
//
//  Created by svp on 04.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "RenRenAttachment.h"


@implementation RenRenAttachment

@synthesize href;
@synthesize media_type;
@synthesize src;
@synthesize media_id;
@synthesize owner_id;
@synthesize owner_name;
@synthesize content;
@synthesize raw_src;

-(void)dealloc{
	[href release],href=nil;
	[media_type release],media_type=nil;
	[src release],src=nil;
	[media_id release],media_id=nil;
	[owner_id release],owner_id=nil;
    [owner_name release],owner_name=nil;
    [content release],content=nil;
    [raw_src release],raw_src=nil;
	[super dealloc];
}

-(id)init{
	self=[super init];
	if (self) {
		//init 
	}
	return self;
}

@end
