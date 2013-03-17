//
//  CustomizedExceptionHandler.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 11/15/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomizedExceptionHandler : NSObject

+ (void)setDefaultExceptionHandler;

+ (NSUncaughtExceptionHandler*)getExceptionHandler;

+ (void)HandleException:(NSException *)exception;

@end
