//
//  RenRenPlace.m
//  FastEasyBlog
//
//  Created by svp on 04.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "RenRenPlace.h"


@implementation RenRenPlace

@synthesize lbs_id;
@synthesize name;
@synthesize address;
@synthesize url;
@synthesize longtitude;
@synthesize latitude;

-(void)dealloc{
	lbs_id=nil;
	name=nil;
	address=nil;
	url=nil;
	longtitude=nil;
	latitude=nil;
	[super dealloc];
}

-(id)init{
		if (self=[super init]) {
			//init
		}
	return self;
}

@end
