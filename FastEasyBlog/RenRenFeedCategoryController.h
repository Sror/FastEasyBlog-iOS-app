//	人人新鲜事类型controller
//  RenRenFeedCategoryController.h
//  FastEasyBlog
//
//  Created by yanghua on 17.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenRenFeedCategoryController : UIViewController
<
UITableViewDelegate,
UITableViewDataSource
> {
    IBOutlet UITableView *categoryTableView;
	NSMutableDictionary *categoryDictionary;
    NSMutableDictionary *categoryImages;
    NSArray *categoryKeysArr;
    
    BOOL isFirstShow;
}

@property (nonatomic,retain) IBOutlet UITableView *categoryTableView;
@property (nonatomic,retain) NSMutableDictionary *categoryDictionary;
@property (nonatomic,retain) NSMutableDictionary *categoryImages;
@property (nonatomic,retain) NSArray *categoryKeysArr;

//实例化类别信息
-(void)initCategoryInfo;


@end
