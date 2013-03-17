//
//  FontSettingController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 10/6/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontSettingController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate
>
{
    
}

@property (nonatomic,retain) IBOutlet UITableView *fontTableView;
@property (nonatomic,retain) NSMutableDictionary *dataSource;

@end
