//
//  PublishOperation.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 11/16/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTStatusBarOverlay.h"

@interface PublishOperation : NSOperation
<
MTStatusBarOverlayDelegate
>

@property (nonatomic,copy) NSString* txt;
@property (nonatomic,copy) NSString *publishImgPath;
@property (atomic,assign)  BOOL completed;
@property (atomic,assign)  BOOL canceledAfterError;
@property (nonatomic,retain) MTStatusBarOverlay *overlay;

- (void)clearPublishedImage;

- (id)initWithOperateParams:(NSString*)content;

@end
