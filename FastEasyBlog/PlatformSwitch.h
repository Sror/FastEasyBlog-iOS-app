//  發送開關
//  PlatformSwitch.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-7-26.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//



@interface PlatformSwitch : NSObject


@property (nonatomic,assign) BOOL isRenRenOpen;
@property (nonatomic,assign) BOOL isSinaWeiboOpen;
@property (nonatomic,assign) BOOL isTencentWeiboOpen;
@property (nonatomic,assign) BOOL isTianyaOpen;

@property (nonatomic,assign) BOOL isRenRenCanOpen;
@property (nonatomic,assign) BOOL isSinaWeiboCanOpen;
@property (nonatomic,assign) BOOL isTencentWeiboCanOpen;
@property (nonatomic,assign) BOOL isTianyaCanOpen;

@end
