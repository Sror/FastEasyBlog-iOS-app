//
//   PopListView.h
//   PopListViewDemo
//
//  Created by yanghua_kobe on 2/21/12.
//  Copyright (c) 2012  . All rights reserved.
//


@protocol PopListViewDelegate;
@interface PopListView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSString *_title;
    NSArray *_options;
}

@property (nonatomic, assign) id<PopListViewDelegate> delegate;

// The options is a NSArray, contain some NSDictionaries, the NSDictionary contain 2 keys, one is "img", another is "text".
- (id)initWithTitle:(NSString *)aTitle
            options:(NSArray *)aOptions;
// If animated is YES, PopListView will be appeared with FadeIn effect.
- (void)showInView:(UIView *)aView
          animated:(BOOL)animated;
@end



@protocol PopListViewDelegate <NSObject>
- (void)PopListView:(PopListView *)popListView
   didSelectedIndex:(NSInteger)anIndex;
- (void)PopListViewDidCancel;
@end