//  Note:微博精选推荐
//  SinaWeiboRecommendController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 10/4/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "SinaWeiboBaseController.h"

@interface SinaWeiboHotFavoritesController : SinaWeiboBaseController
<
UINavigationControllerDelegate,
WBEngineDelegate,
WeiboImageDelegate,
BindCheckNotificationDelegate
>

@end
