//
//  RenRenNews.m
//  FastEasyBlog
//
//  Created by svp on 04.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "RenRenNews.h"


@implementation RenRenNews

@synthesize post_id;
@synthesize source_id;
@synthesize feed_type;
@synthesize update_time;
@synthesize actor_id;
@synthesize actor_type;
@synthesize name;
@synthesize headurl;
@synthesize prefix;
@synthesize message;
@synthesize title;
@synthesize href;
@synthesize description;

@synthesize attachment;
@synthesize comments;
@synthesize likes;
@synthesize source;
@synthesize place;

@synthesize headImg;
@synthesize photoImg;

-(void)dealloc{
    post_id=nil;
	source_id=nil;
	feed_type=nil;
	update_time=nil;
	actor_id=nil;
    actor_type=nil;
	name=nil;
	headurl=nil;
	prefix=nil;
	message=nil;
	title=nil;
	href=nil;
	description=nil;
	
	[attachment release];
	[comments release];
	[likes release];
	[source release];
	[place release];
	[headImg release];
    [photoImg release],photoImg=nil;
	
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
