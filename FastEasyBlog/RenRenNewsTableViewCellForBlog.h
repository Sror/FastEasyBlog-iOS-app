//
//  RenRenNewsTableViewCellForBlog.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-7-13.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenRenNewsTableViewCell.h"



@interface RenRenNewsTableViewCellForBlog : RenRenNewsTableViewCell{
    NSString *title;				//日志标题
    NSString *introduction;			//日志简介
    
    UIView *blogView;				//整个日志区域
    UILabel *titleLabel;			//标题
    UILabel *introductionLabel;		//简介
}

@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *introduction;

@end
