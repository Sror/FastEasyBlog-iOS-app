//	被关注者对象
//  Followed.h
//  FastEasyBlog
//
//  Created by yanghua on 04.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Followed : NSObject

@property (nonatomic,retain) UIImage *headImg;
@property (nonatomic,retain) NSString *headImgUrl;
@property (nonatomic,retain) NSString *nick;
@property (nonatomic,retain) NSString *userId;
@property (nonatomic,retain) NSString *desc;

@end
