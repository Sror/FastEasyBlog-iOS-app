//
//  RenRenNewsTableViewCellForStatus.h
//  FastEasyBlog
//
//  Created by svp on 08.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenRenNewsTableViewCell.h"



@interface RenRenNewsTableViewCellForStatus : RenRenNewsTableViewCell {
	NSString *statusContent;	
	UILabel *statusLabel;
}

@property (nonatomic,copy) NSString *statusContent;

@end
