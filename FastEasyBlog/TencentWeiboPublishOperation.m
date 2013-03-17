//
//  TencentWeiboPublishOperation.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 11/16/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "TencentWeiboPublishOperation.h"
#import "TencentWeiboManager.h"
#import "OpenApi.h"

@implementation TencentWeiboPublishOperation

/*
 *business logic
 */
- (void)main{
    [self.overlay postImmediateMessage:@"腾讯微博发表中..." animated:YES];
    self.publishImgPath=PUBLISH_IMAGEPATH_TENCENTWEIBO;
    BOOL hasImage=[[NSFileManager defaultManager]fileExistsAtPath:PUBLISH_IMAGEPATH_TENCENTWEIBO];
    OpenApi *myApi=[TencentWeiboManager getOpenApi];
    myApi.delegate=self;
    if (!hasImage) {
        [myApi publishWeibo:self.txt 
                       jing:@"" 
                        wei:@"" 
                     format:@"json" 
                   clientip:@"127.0.0.1" 
                   syncflag:@"0"];
    }else{
        [myApi publishWeiboWithImageAndContent:self.txt 
                                          jing:@"" wei:@"" 
                                        format:@"json" 
                                      clientip:@"127.0.0.1" 
                                      syncflag:@"0"];
    }
    
}

#pragma mark - tencent weibo delegate -
- (void)tencentWeiboPublishedSuccessfully{
    [self clearPublishedImage];
    [GlobalInstance showOverlayMsg:@"腾讯微博发表成功!" 
                       andDuration:2.0 
                        andOverlay:self.overlay];
    
    [NSThread sleepForTimeInterval:5];
}

- (void)tencentWeiboRequestFailWithError{
    [self clearPublishedImage];
    [GlobalInstance showOverlayErrorMsg:@"腾讯微博发表失败!" 
                            andDuration:2.0 
                             andOverlay:self.overlay];
    
    [NSThread sleepForTimeInterval:5];
}

@end
