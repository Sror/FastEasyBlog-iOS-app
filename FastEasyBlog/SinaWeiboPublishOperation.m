//
//  SinaWeiboPublishOperation.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 11/16/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "SinaWeiboPublishOperation.h"

@interface SinaWeiboPublishOperation()

@property (nonatomic,retain) WBEngine *engine;

@end

@implementation SinaWeiboPublishOperation

@synthesize engine=_engine;

- (void)dealloc{
    [_engine setDelegate:nil];
    [_engine release],_engine=nil;
    
    [super dealloc];
}

/*
 *business logic
 */
- (void)main{
    self.publishImgPath=PUBLISH_IMAGEPATH_SINAWEIBO;
    _engine = [[WBEngine alloc]initWithAppKey:kWBSDKDemoAppKey 
                                    appSecret:kWBSDKDemoAppSecret];
    _engine.delegate=self;
    [self.engine sendWeiBoWithText:self.txt 
                        image:[UIImage imageWithContentsOfFile:
                               PUBLISH_IMAGEPATH_SINAWEIBO]];
    
    [self.overlay postImmediateMessage:@"新浪微博发表中..." animated:YES];
    
    [super main];
}

#pragma mark - WBEngineDelegate Methods -
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result{
    [self clearPublishedImage];
    [GlobalInstance showOverlayMsg:@"新浪微博发表成功!" 
                       andDuration:2.0 
                        andOverlay:self.overlay];
    
     self.completed=YES;
    [NSThread sleepForTimeInterval:5];
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error{
    [self clearPublishedImage];
    [GlobalInstance showOverlayErrorMsg:@"新浪微博发表失败!" 
                            andDuration:2.0 
                             andOverlay:self.overlay];
    
    self.canceledAfterError=YES;
    [NSThread sleepForTimeInterval:5];
}


@end
