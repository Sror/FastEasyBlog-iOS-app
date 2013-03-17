//
//  TencentWeiboController.h
//  FastEasyBlog
//
//  Created by svp on 24.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TencentWeiboBaseController.h"
#import "PopListView.h"

#define WEIBO_IMAGE_BIG 460

@interface TencentWeiboMainController : TencentWeiboBaseController
<
UINavigationControllerDelegate,
TencentWeiboDelegate,
ClickEventDelegate,
PopListViewDelegate,
BindCheckNotificationDelegate
> {
        
//    //关于API请求
//    long firstItemTimeStamp;                      //本页第一条记录的时间戳
//    long lastItemTimeStamp;                       //本页最后一条记录的时间戳
}


@end
