//
//  FEBAppConfig.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/12/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "FEBAppConfig.h"

static FEBAppConfig *sharedInstance;

@interface FEBAppConfig()

@property (nonatomic,retain) NSDictionary *config;

//从文件系统获取配置
- (NSMutableDictionary*)getAppConfigFromFileSystem;
@end

@implementation FEBAppConfig

@synthesize config;

- (void)dealloc{
	[config release],config=nil;
	[super dealloc];
}

- (id)init{
	if(self=[super init]){
        if(!fileExistsAtPath(AppConfigPathInSandBox)){
            NSString *configPath=[[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"];
            NSData *data=[NSData dataWithContentsOfFile:configPath];
            NSPropertyListFormat format;
            NSString *errorDescription;
            NSDictionary *configObject=[NSPropertyListSerialization propertyListFromData:data 
                                                                        mutabilityOption:NSPropertyListImmutable 
                                                                                  format:&format 
                                                                        errorDescription:&errorDescription];
            
            if(configObject){
                self.config=configObject;
                //写入应用程序沙盒，使其可修改
                [self.config writeToFile:AppConfigPathInSandBox atomically:YES];
            }else{
                NSLog(@"Error reading config plist (%@): %@",configPath,errorDescription);
            }
        }
	}
	return self;
}

+ (FEBAppConfig*)sharedAppConfig{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken,^{
		sharedInstance=[[FEBAppConfig alloc]init];
	});
    
    return sharedInstance;
}

/*
 *从文件系统获取配置
 */
- (NSMutableDictionary*)getAppConfigFromFileSystem{
    if(fileExistsAtPath(AppConfigPathInSandBox)){
        return [[[NSMutableDictionary alloc]initWithContentsOfFile:AppConfigPathInSandBox]autorelease];
    }
    return nil;
}

- (id)objectForKey:(NSString*)key{
	id result=[[self getAppConfigFromFileSystem] objectForKey:key];
	if(!result){
		[NSException raise:NSGenericException format:@"No value found for config key: %@",key];
	}
	return result;
}

- (void)setValue:(id)value
          forKey:(NSString*)key{
    if (!key||[key isEqualToString:@""]) {
        return;
    }
    NSMutableDictionary *configDictionary=[self getAppConfigFromFileSystem];
    [configDictionary setValue:value forKey:key];
    [configDictionary writeToFile:AppConfigPathInSandBox atomically:YES];
}

@end
