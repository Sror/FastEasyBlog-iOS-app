//
//  AboutMeControllerForTemp.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 11/10/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "PlatformBaseController.h"
#import "MGTemplateEngine.h"
#import <MessageUI/MessageUI.h>

@interface AboutMeController : PlatformBaseController
<
UIWebViewDelegate,
MGTemplateEngineDelegate,
BindCheckNotificationDelegate,
MFMailComposeViewControllerDelegate
>

@end
