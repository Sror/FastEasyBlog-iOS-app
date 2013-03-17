//	表示新鲜事的发生地
//  RenRenPlace.h
//  FastEasyBlog
//
//  Created by svp on 04.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RenRenPlace : NSObject {
	NSString *lbs_id;
	NSString *name;
	NSString *address;
	NSString *url;
	NSString *longtitude;
	NSString *latitude;
}

@property (nonatomic,copy) NSString *lbs_id;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *longtitude;
@property (nonatomic,copy) NSString *latitude;

@end
