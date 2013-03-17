//
//  TencentWeiboList.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 8/1/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TencentWeiboList : NSObject{
    NSMutableArray *list;
    BOOL hasNext;
    NSString *pos;              //转发热榜使用
}

@property (nonatomic,retain) NSMutableArray *list;
@property (nonatomic,assign) BOOL hasNext;
@property (nonatomic,retain) NSString *pos;

@end
