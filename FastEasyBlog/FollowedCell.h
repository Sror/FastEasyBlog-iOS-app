//
//  RenRenNewsCategoryCell.h
//  FastEasyBlog
//
//  Created by svp on 19.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FollowedCell : UITableViewCell {
	NSString *nick;
	UIImage *headImg;
    NSString *desc;
}

@property (nonatomic,retain) NSString *nick;
@property (nonatomic,retain) UIImage *headImg;
@property (nonatomic,retain) NSString *desc;

@end
