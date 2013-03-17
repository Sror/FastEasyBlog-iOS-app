//	表示赞相关的信息
//  RenRenLike.h
//  FastEasyBlog
//
//  Created by svp on 04.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RenRenLike : NSObject {
	NSString *total_count;
	NSString *friend_count;
	NSString *user_like;
	NSMutableArray *like;
}

@property (nonatomic,copy) NSString *total_count;
@property (nonatomic,copy) NSString *friend_count;
@property (nonatomic,copy) NSString *user_like;
@property (nonatomic,retain) NSMutableArray *like;

@end
