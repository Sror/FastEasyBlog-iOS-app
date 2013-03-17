//  
//  SinaWeiboSwitchController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/22/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "SwitchController.h"

@protocol  ClickEventDelegate;

@interface SinaWeiboSwitchController : SwitchController
<
SwitchControllerDelegate,
ClickEventDelegate
>

@end
