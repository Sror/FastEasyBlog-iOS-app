//
//  RenRenBlog.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-7-25.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RenRenBlog : NSObject{
    NSString *bid;
    NSString *uid;
    NSString *name;
    NSString *headurl;
    NSString *time;
    NSString *title;
    NSString *content;
    NSString *view_count;
    NSString *comment_count;
    NSString *share_count;
    NSString *visable;
    NSMutableArray *comments;
}

@property (nonatomic,retain) NSString *bid;
@property (nonatomic,retain) NSString *uid;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *headurl;
@property (nonatomic,retain) NSString *time;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *content;
@property (nonatomic,retain) NSString *view_count;
@property (nonatomic,retain) NSString *comment_count;
@property (nonatomic,retain) NSString *share_count;
@property (nonatomic,retain) NSString *visable;
@property (nonatomic,retain) NSMutableArray *comments;

@end
