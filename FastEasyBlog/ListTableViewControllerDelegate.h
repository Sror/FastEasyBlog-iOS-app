//
//  ListTableViewControllerDelegate.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-20.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ListTableViewControllerDelegate <NSObject>

@required
- (void)firstLoad;

- (void)refresh;

- (void)loadMore;

@optional
- (void)loadImagesForOneScreenRows;

@end
