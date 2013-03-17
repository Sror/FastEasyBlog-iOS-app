//
//  PublishOperation.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 11/16/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "PublishOperation.h"

@implementation PublishOperation

@synthesize completed;
@synthesize canceledAfterError;
@synthesize txt=_txt;
@synthesize overlay=_overlay;
@synthesize publishImgPath=_publishImgPath;

- (void)dealloc{
    [_txt release],_txt=nil;
    [_publishImgPath release],_publishImgPath=nil;
    
    [super dealloc];
}

- (id)init{
    if (self=[super init]) {
        completed=NO;
        canceledAfterError=NO;
        [self initMTStatusBarOverlay];
    }
    
    return self;
}

- (id)initWithOperateParams:(NSString*)content{
    if (self=[self init]) {
        self.txt=content;
    }
    
    return self;
}

/*
 *实例化工具栏提示组件
 */
-(void)initMTStatusBarOverlay{
    _overlay = [MTStatusBarOverlay sharedInstance];
    _overlay.animation = MTStatusBarOverlayAnimationFallDown;  
    _overlay.detailViewMode = MTDetailViewModeHistory;         
    _overlay.delegate=self;
}

- (void)main{
    //操作既没有完成也没有因为发生错误而取消，则hold住当前run loop
    //防止返回主线程使得代理方法无法执行
    while (!(self.completed||self.canceledAfterError)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode 
                                 beforeDate:[NSDate distantFuture]];
        DebugLog(@"running!");
    }
    
}

#pragma mark - other methods -
- (void)clearPublishedImage{
    //清除緩存圖片
    if (fileExistsAtPath(self.publishImgPath)) {
        removerAtItem(self.publishImgPath);
    }
}

@end
