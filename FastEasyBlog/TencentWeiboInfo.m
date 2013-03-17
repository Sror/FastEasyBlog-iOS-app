//
//  TencentWeibBoInfo.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-2.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import "TencentWeiboInfo.h"

@implementation TencentWeiboInfo 

@synthesize text,
            origtext,
            count,
            mcount,
            from,
            fromurl,
            uniqueId,
            image,
            video,
            music,
            name,
            openid,
            nick,
            isSelf,
            timestamp,
            type,
            head,
            location,
            country_code,
            province_code,
            city_code,
            isvip,
            geo,
            status,
            emotionurl,
            emotiontype,
            source,
            headImg,
            weiboImg,
            sourceImg;

- (id)init{
    self=[super init];
    if (self) {
        //init 
    }
    
    return self;
}

- (void)dealloc{
    [text release];                 text=nil;
    [origtext release];             origtext=nil;
//    [count release];                count=nil;
//    [mcount release];               mcount=nil;
    [from release];                 from=nil;
    [fromurl release];              fromurl=nil;
    [uniqueId release];             uniqueId=Nil;
    [image release];                image=nil;
    [video release];                video=nil;
    [music release];                music=nil;
    [name release];                 name=nil;
    [openid release];               openid=Nil;
    [nick release];                 nick=nil;
//    [isSelf release];               isSelf=nil;
//    [timestamp release];            timestamp=nil;
//    [type release];                 type=nil;
    [head release];                 head=nil;
    [location release];             location=nil;
    [country_code release];         country_code=nil;
    [province_code release];        province_code=nil;
    [city_code release];            city_code=nil;
//    [isvip release];                isvip=nil;
    [geo release];                  geo=nil;
//    [status release];               status=nil;
    [emotionurl release];           emotionurl=nil;
    [emotiontype release];          emotiontype=nil;
    [source release];               source=nil;
    [headImg release],headImg=nil;
    [weiboImg release],weiboImg=nil;
    [sourceImg release],sourceImg=nil;
    [super dealloc];
}


@end
