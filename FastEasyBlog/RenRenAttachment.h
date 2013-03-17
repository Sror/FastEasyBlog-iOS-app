//	表示新鲜事中包含的媒体内容，例如照片、视频等
//  RenRenAttachment.h
//  FastEasyBlog
//
//  Created by svp on 04.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

//注:以下字段和属性并不是每条新鲜事中都携带，它们只是所有新鲜事的一个并集
@interface RenRenAttachment : NSObject {
	NSString *href;
	NSString *media_type;
	NSString *src;
	NSString *media_id;
	NSString *owner_id;
    NSString *owner_name;
    NSString *content;
    NSString *raw_src;          //图片的原图地址（media_type:photo时存在）
}

@property (nonatomic,retain) NSString *href;
@property (nonatomic,retain) NSString *media_type;
@property (nonatomic,retain) NSString *src;
@property (nonatomic,retain) NSString *media_id;
@property (nonatomic,retain) NSString *owner_id;
@property (nonatomic,retain) NSString *owner_name;
@property (nonatomic,retain) NSString *content;
@property (nonatomic,retain) NSString *raw_src;

@end
