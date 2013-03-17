//
//  RenRenNewsCategoryCell.h
//  FastEasyBlog
//
//  Created by svp on 19.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RenRenNewsCategoryCell : UITableViewCell {
	NSString *categoryName;
	BOOL isChecked;
	
	UIImageView *categoryImgView;
	UILabel *categoryNameLabel;
	UIImageView *checkedImgView;
}

@property (nonatomic,assign) BOOL isChecked;
@property (nonatomic,retain) NSString *categoryName;
@property (nonatomic,retain) UIImageView *categoryImgView;

@end
