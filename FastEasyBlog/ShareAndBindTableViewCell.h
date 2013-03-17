//
//  ShareAndBindTableViewCell.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/9/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareAndBindTableViewCell : UITableViewCell{
    UIImageView *headImgView;
    UILabel *platformNameLbl;
    UILabel *bindOrNotLbl;
}

@property (nonatomic,retain) UIImage *headImg;
@property (nonatomic,retain) NSString *platformName;
@property (nonatomic,retain) NSString *bindOrNot;

@end
