//
//  RenRenLike.m
//  FastEasyBlog
//
//  Created by svp on 04.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "RenRenLike.h"


@implementation RenRenLike

@synthesize total_count;
@synthesize friend_count;
@synthesize user_like;
@synthesize like;

-(void)dealloc{
	total_count=nil;
	friend_count=nil;
	user_like=nil;
	like=nil;
	[super dealloc];
}

-(id)init{
		if (self=[super init]) {
			//init
		}
	
	return self;
}

@end
