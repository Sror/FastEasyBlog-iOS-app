//
//  RenRenUserInfo.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/9/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RenRenUserInfo : NSObject{
    
}

@property (nonatomic,retain) NSString *uniquedId;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,assign) uint sex; 
@property (nonatomic,assign) uint star;
@property (nonatomic,assign) uint zidou;
@property (nonatomic,retain) NSString *birthday;
@property (nonatomic,retain) NSString *email_hash;
@property (nonatomic,retain) NSString *tinyurl;
@property (nonatomic,retain) NSString *headurl;
@property (nonatomic,retain) NSString *mainurl;
@property (nonatomic,retain) NSMutableDictionary *hometown_location;
@property (nonatomic,retain) NSMutableArray *work_history;
@property (nonatomic,retain) NSMutableArray *university_history;
@property (nonatomic,retain) NSMutableArray *hs_history;

@end
