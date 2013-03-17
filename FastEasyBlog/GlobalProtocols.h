//  公用協議定義
//  GlobalProtocols.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-27.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

/*
 *操作完成的回調協議
 */
@protocol rAndCDelegate <NSObject>

@optional

//评论完成
- (void)rAndCSuccessfully;

@end

/*
 *微博图片回調協議
 */
@protocol WeiboImageDelegate <NSObject>

@optional
- (void)showWeiboImage:(id)sender;                  //显示微博图片

- (void)showSourceWeiboImage:(id)sender;            //显示原始微博图片

- (void)resizeWeiboImageInTableView:(CGFloat)_weiboImgHeight;   //重置微博图片的高度

@end

/*
 *处理“检查绑定”通知
 */
@protocol BindCheckNotificationDelegate <NSObject>

@optional
-(BOOL)checkBindInfo;

-(void)handleBindNotification:(BOOL)isBound;

@end




