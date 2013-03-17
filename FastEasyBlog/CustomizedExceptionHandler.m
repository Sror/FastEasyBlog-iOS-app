//
//  CustomizedExceptionHandler.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 11/15/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "CustomizedExceptionHandler.h"

@implementation CustomizedExceptionHandler

+ (void)setDefaultExceptionHandler{
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler*)getExceptionHandler{
    return NSGetUncaughtExceptionHandler();
}

/*
 *handle exception (log)
 */
+ (void)HandleException:(NSException *)exception{
    NSArray *arr=[exception callStackSymbols];
    NSString *reason=[exception reason];
    NSString *name=[exception name];
    NSString *exceptionMsg=[NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
    NSString *path=[applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    [exceptionMsg writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


#pragma mark - private methods -
NSString* applicationDocumentsDirectory(){
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

void UncaughtExceptionHandler(NSException *exception){
    DebugLog(@"CRASH: %@",exception);
    DebugLog(@"Stack Trace: %@",[exception callStackSymbols]);
    
    NSArray *arr=[exception callStackSymbols];
    NSString *reason=[exception reason];
    NSString *name=[exception name];
    NSString *url=[NSString stringWithFormat:
                   @"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",
                   name,
                   reason,
                   [arr componentsJoinedByString:@"\n"]];
    NSString *path=[applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSString *urlStr=[NSString stringWithFormat:
                      @"mailto:yanghua1127@gmail.com?subject=快易博bug报告&body=很抱歉应用出现异常,感谢您的配合!发送这份邮件可协助我改善此应用<br>错误详情:<br>%@<br>-------------------------<br />%@<br />-------------------------<br>%@",
                      name,
                      reason,
                      [arr componentsJoinedByString:@"<br>"]];
    NSURL *url2=[NSURL URLWithString:[urlStr 
                                      stringByAddingPercentEscapesUsingEncoding:
                                      NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url2];
}


@end
