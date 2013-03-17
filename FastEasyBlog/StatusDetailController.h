//
//  StatusDetailController.h
//  FastEasyBlog
//
//  Created by yanghua_kobe on 10/28/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "PlatformDetailController.h"
#import "MGTemplateEngine.h"

@class RenRenNews;

@interface StatusDetailController : PlatformDetailController
<
UIWebViewDelegate,
UIActionSheetDelegate,
MGTemplateEngineDelegate,
RenrenDelegate,
PlatformDetailControllerDelegate,
rAndCDelegate
>

@property (nonatomic,retain) UIWebView *webView;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
                 news:(RenRenNews*)currentNews;

@end
