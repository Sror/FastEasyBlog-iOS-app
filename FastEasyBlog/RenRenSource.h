//	表示照片来源
//  RenRenSource.h
//  FastEasyBlog
//
//  Created by svp on 04.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RenRenSource : NSObject {
	NSString *text;
	NSString *href;
}

@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *href;

@end
