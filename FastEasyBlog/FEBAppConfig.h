//
//  FEBAppConfig.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/12/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface FEBAppConfig : NSObject

+ (FEBAppConfig *)sharedAppConfig;
- (id)objectForKey:(NSString*)key;
- (void)setValue:(id)value
          forKey:(NSString*)key;

@end
