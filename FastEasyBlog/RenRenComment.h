//	表示评论的具体内容
//  RenRenComment.h
//  FastEasyBlog
//
//  Created by svp on 04.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RenRenComment : NSObject {
    NSString *identifier;
	NSString *uid;
	NSString *name;
	NSString *headurl;
	NSString *time;
	NSString *comment_id;
	NSString *text;
    
    UIImage *headImg;
    NSString *ownerId;          //所評論的新鮮事擁有者的用戶/公共主頁id
}

@property (nonatomic,retain) NSString *identifier;
@property (nonatomic,retain) NSString *uid;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *headurl;
@property (nonatomic,retain) NSString *time;
@property (nonatomic,retain) NSString *comment_id;
@property (nonatomic,retain) NSString *text;
@property (nonatomic,retain) UIImage *headImg;
@property (nonatomic,retain) NSString *ownerId;

@end
