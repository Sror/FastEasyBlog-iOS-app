//  擴展方法
//  Extension.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-23.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extended)

- (BOOL)isNotEqualToString:(NSString *)aString;

- (BOOL)isEqualToStringWithIgnoreCase:(NSString*)aString;

- (BOOL)isEmpty;

- (unichar)charAt:(int)index;

- (int)compareTo:(NSString*)anotherString;

- (int)compareToIgnoreCase:(NSString*)str;

- (BOOL)contains:(NSString*)str;

- (BOOL)startsWith:(NSString*)prefix;

- (BOOL)endsWith:(NSString*)suffix;

- (int)indexOfChar:(unichar)ch;

- (int)indexOfChar:(unichar)ch
         fromIndex:(int)index;

- (int)indexOfString:(NSString*)str;

- (int)indexOfString:(NSString*)str
           fromIndex:(int)index;

- (int)lastIndexOfChar:(unichar)ch;

- (int)lastIndexOfChar:(unichar)ch
             fromIndex:(int)index;

- (int)lastIndexOfString:(NSString*)str;

- (int)lastIndexOfString:(NSString*)str
               fromIndex:(int)index;

- (NSString*)subStringFromIndex:(int)beginIndex
                        toIndex:(int)endIndex;

- (NSString*)toLowerCase;

- (NSString*)toUpperCase;

- (NSString*)trim;

- (NSString*)replaceAll:(NSString*)origin
                   with:(NSString*)replacement;

- (NSArray*)split:(NSString*)separator;

- (NSString*)handleForShowing;

@end

@interface UIColor (Extended)
/*
 * return a UIColor based on a HTML-style RGB string like #ff1234 
 */
+ (UIColor*)colorFromRGBHexString:(NSString*)colorString;

@end
