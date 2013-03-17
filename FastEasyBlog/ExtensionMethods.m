//
//  Extension.m
//  FastEasyBlog
//
//  Created by yh on 12-8-23.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import "ExtensionMethods.h"

#define JavaNotFound -1

@implementation NSString (Extended)

- (BOOL)isNotEqualToString:(NSString *)aString{
    return ![self isEqualToString:aString];
}

- (BOOL)isEqualToStringWithIgnoreCase:(NSString*)aString{
	return [[self toLowerCase] isEqualToString:[aString toLowerCase]];
}


- (BOOL)isEmpty{    
    return [self isEqualToString:@""];
}

- (unichar)charAt:(int)index{
	return [self characterAtIndex:index];
}

- (int)compareTo:(NSString*)anotherString{
	return [self compare:anotherString];
}

- (int)compareToIgnoreCase:(NSString*)str{
	return [self compare:str options:NSCaseInsensitiveSearch];
}

- (BOOL)contains:(NSString*)str{
	NSRange range=[self rangeOfString:str];
	return (range.location!=NSNotFound);
}

- (BOOL)startsWith:(NSString*)prefix{
	return [self hasPrefix:prefix];
}

- (BOOL)endsWith:(NSString*)suffix{
	return [self hasSuffix:suffix];
}

- (int)indexOfChar:(unichar)ch{
	return [self indexOfChar:ch fromIndex:0];
}

- (int)indexOfChar:(unichar)ch
         fromIndex:(int)index{
	int len=self.length;
	for(int i=index;i<len;i++){
		if(ch==[self charAt:i]){
			return i;
		}
	}
	
	return JavaNotFound;
}

- (int)indexOfString:(NSString*)str{
	NSRange range=[self rangeOfString:str];
	if(range.location==NSNotFound){
		return JavaNotFound;
	}
	return range.location;
}

- (int)indexOfString:(NSString*)str
           fromIndex:(int)index{
	NSRange fromRange=NSMakeRange(index,self.length-index);
	NSRange range=[self rangeOfString:str options:NSLiteralSearch range:fromRange];
	if(range.location==NSNotFound){
		return JavaNotFound;
	}
	return range.location;
}

- (int)lastIndexOfChar:(unichar)ch{
	int len=self.length;
	for(int i=len-1;i>=0;i--){
		if([self charAt:i]==ch){
			return i;
		}
	}
	return JavaNotFound;
}

- (int)lastIndexOfChar:(unichar)ch
             fromIndex:(int)index{
	int len=self.length;
	if(index>=len){
		index=len-1;
	}
	for(int i=index;i>=0;i--){
		if([self charAt:i]==ch){
			return index;
		}
	}
	
	return JavaNotFound;
}

- (int)lastIndexOfString:(NSString*)str{
	NSRange range=[self rangeOfString:str options:NSBackwardsSearch];
	if(range.location==NSNotFound){
		return JavaNotFound;
	}
	return range.location;
}

- (int)lastIndexOfString:(NSString*)str
               fromIndex:(int)index{
	NSRange fromRange=NSMakeRange(0,index);
	NSRange range=[self rangeOfString:str options:NSBackwardsSearch range:fromRange];
	if(range.location==NSNotFound){
		return JavaNotFound;
	}
	return range.location;
}

- (NSString*)subStringFromIndex:(int)beginIndex
                        toIndex:(int)endIndex{
	if(endIndex<=beginIndex){
		return @"";
	}
	NSRange range=NSMakeRange(beginIndex,endIndex-beginIndex);
	return [self substringWithRange:range];
    
}

- (NSString*)toLowerCase{
	return [self lowercaseString];
}

- (NSString*)toUpperCase{
	return [self uppercaseString];
}

- (NSString*)trim{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString*)replaceAll:(NSString*)origin
                   with:(NSString*)replacement{
	return [self stringByReplacingOccurrencesOfString:origin withString:replacement];
}

- (NSArray*)split:(NSString*)separator{
	return [self componentsSeparatedByString:separator];
}

- (NSString*)handleForShowing{
    NSArray *expressions = expressions = [[NSArray alloc] initWithObjects:
                                          AT_IN_WEIBO_EXPRESSION,
                                          TOPIC_IN_WEIBO_EXPRESSION,
                                          URL_EXPRESSION,
                                          nil];
    
    //如果有<a></a>则先进行预处理
    NSString *aLabelExpression=@"(<[aA].*?>.+?</[aA]>)";
    if ([self stringByMatching:aLabelExpression]) {
        NSArray *matchedArr=[self componentsMatchedByRegex:ALABEL_EXPRESSION];
        for (NSString *matchedItem in matchedArr) {
            NSString *tmpHrefVal=[[matchedItem stringByMatching:HREF_PROPERTY_IN_ALABEL_EXPRESSION] stringByMatching:URL_EXPRESSION];
            if (tmpHrefVal) {
                self=[self replaceAll:matchedItem with:tmpHrefVal];
            }
        }
    }    
    
    for (NSString *expression in expressions)
	{        
        NSString *replaceStr=@"";
        if ([expression contains:@"@"]) {
            replaceStr=@"<a href=\"$1\">$1</a>";
        }else if([expression contains:@"#"]){
            replaceStr=@"<a href=\"$1\">$1</a>";
        }else{
            replaceStr=@"<a href=\"$1\">$1</a>";
        }
        self=[self stringByReplacingOccurrencesOfRegex:expression withString:replaceStr];
	}
    [expressions release];
    return self;
}

@end

@implementation UIColor (Extended)
/*
 * return a UIColor based on a HTML-style RGB string like #ff1234 
 */
+ (UIColor*)colorFromRGBHexString:(NSString*)colorString{
	if(colorString.length==7){
		const char *colorUTF8String=[colorString UTF8String];
		int r,g,b;
		sscanf(colorUTF8String,"#%2x%2x%2x",&r,&g,&b);
		return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0];
	}
	return nil;
}

@end

