//
//  RenRenSource.m
//  FastEasyBlog
//
//  Created by svp on 04.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "RenRenSource.h"


@implementation RenRenSource

@synthesize text;
@synthesize href;

-(void)dealloc{
	text=nil;
	href=nil;
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
