//
//  TencentWeiboAtMeController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/24/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TencentWeiboBaseController.h"

#define WEIBO_IMAGE_BIG 460

@interface TencentWeiboAtMeController : TencentWeiboBaseController
<
BindCheckNotificationDelegate,
TencentWeiboDelegate
>



@end
