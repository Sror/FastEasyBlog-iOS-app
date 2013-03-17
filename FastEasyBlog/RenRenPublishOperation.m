//
//  RenRenPublishOperation.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 11/16/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "RenRenPublishOperation.h"

@implementation RenRenPublishOperation

/*
 *business logic
 */
- (void)main{
    self.publishImgPath=PUBLISH_IMAGEPATH_RENREN;
    BOOL hasImage=[[NSFileManager defaultManager]fileExistsAtPath:PUBLISH_IMAGEPATH_RENREN];
    if (hasImage) {
        ROPublishPhotoRequestParam *photoParams=[[[ROPublishPhotoRequestParam alloc]init]autorelease];
        photoParams.imageFile=[UIImage imageWithContentsOfFile:PUBLISH_IMAGEPATH_RENREN];
        photoParams.caption=self.txt;
        [[Renren sharedRenren] publishPhoto:photoParams andDelegate:self];
        [self.overlay postImmediateMessage:@"人人图片上传中..." animated:YES];
    }else {
        NSMutableDictionary *params=[NSMutableDictionary dictionaryWithCapacity:10];
        [params setObject:@"status.set" forKey:@"method"];
        [params setObject:self.txt
                   forKey:@"status"];
        [[Renren sharedRenren]requestWithParams:params andDelegate:self];
        [self.overlay postImmediateMessage:@"人人状态发表中..." animated:YES];
    }
    
    [super main];
}

#pragma mark - RenrenDelegate (ren ren) -
-(void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse *)response{
    [self clearPublishedImage];
    [GlobalInstance showOverlayMsg:@"人人新鲜事发表成功!" 
                       andDuration:2.0 
                        andOverlay:self.overlay];
    self.completed=YES;
    [NSThread sleepForTimeInterval:5];
}

-(void)renren:(Renren *)renren requestFailWithError:(ROError *)error{
    [self clearPublishedImage];
    NSString *errorMsg=@"";
    if ([error code]==300) {
        errorMsg=@"图片的宽高比必须大于1/3";
    }
    [GlobalInstance showOverlayErrorMsg:[NSString stringWithFormat:@"人人新鲜事发表失败!%@",errorMsg] 
                            andDuration:2.0 
                             andOverlay:self.overlay];
    
    self.canceledAfterError=YES;
    [NSThread sleepForTimeInterval:5];
}

@end
