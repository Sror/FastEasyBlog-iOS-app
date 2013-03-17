//
//  PlatformTableViewCell.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/6/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "PlatformTableViewCell.h"

@implementation PlatformTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
