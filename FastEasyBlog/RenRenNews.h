//	人人新鲜事对象
//  RenRenNews.h
//  FastEasyBlog
//
//  Created by svp on 04.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RenRenLike;
@class RenRenSource;
@class RenRenPlace;

@interface RenRenNews : NSObject {
	NSString *post_id;	
	NSString *source_id;
	NSString *feed_type;
	NSString *update_time;
	NSString *actor_id;
    NSString *actor_type;
	NSString *name;
	NSString *headurl;
	NSString *prefix;
	NSString *message;
	NSString *title;
	NSString *href;
	NSString *description;
	NSMutableArray *attachment;
	NSMutableDictionary *comments;
	RenRenLike *likes;
	RenRenSource *source;
	RenRenPlace *place;
	
	UIImage *headImg;
    UIImage *photoImg;              //存储照片新鲜事中的照片
}

@property (nonatomic,retain) NSString *post_id;
@property (nonatomic,retain) NSString *source_id;
@property (nonatomic,retain) NSString *feed_type;
@property (nonatomic,retain) NSString *update_time;
@property (nonatomic,retain) NSString *actor_id;
@property (nonatomic,retain) NSString *actor_type;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *headurl;
@property (nonatomic,retain) NSString *prefix;
@property (nonatomic,retain) NSString *message;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *href;
@property (nonatomic,retain) NSString *description;

@property (nonatomic,retain) NSMutableArray *attachment;
@property (nonatomic,retain) NSMutableDictionary *comments;
@property (nonatomic,retain) RenRenLike *likes;
@property (nonatomic,retain) RenRenSource *source;
@property (nonatomic,retain) RenRenPlace *place;

@property (nonatomic,retain) UIImage *headImg;
@property (nonatomic,retain) UIImage *photoImg;

@end
