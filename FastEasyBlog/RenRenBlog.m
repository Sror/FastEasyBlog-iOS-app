//
//  RenRenBlog.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-7-25.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import "RenRenBlog.h"

@implementation RenRenBlog

@synthesize bid,uid,name,headurl,time,title,content,view_count,comment_count,share_count,visable,comments;

-(void)dealloc{
    [bid release];              bid=nil;
    [uid release];              uid=nil;
    [name release];             name=nil;
    [headurl release];          headurl=nil;
    [time release];             time=nil;
    [title release];            title=nil;
    [content release];          content=nil;
    [view_count release];       view_count=nil;
    [comment_count release];    comment_count=nil;
    [share_count release];      share_count=nil;
    [visable release];          visable=nil;
    [comments release];         comments=nil;
    [super dealloc];            
}

@end
