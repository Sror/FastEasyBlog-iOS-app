//
//  PlatformDetailController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/7/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "PlatformDetailController.h"
#import "Global.h"

#define TOOLBARVIEWHEIGHT 44.0f
#define TOOLBARVIEWWIDTH WINDOWWIDTH

@interface PlatformDetailController ()

- (void)setNavigationBarItem;

@end

@implementation PlatformDetailController

@synthesize delegate;

- (void)dealloc{
    [_hud release],_hud=nil;
	[_toolbar release],_toolbar=nil;
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		_toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0,WINDOWHEIGHT-STATUSBARHEIGHT-TOOLBARVIEWHEIGHT, 
                                                             TOOLBARVIEWWIDTH, TOOLBARVIEWHEIGHT)];
		_toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		UIBarButtonItem *commentItem = [[UIBarButtonItem alloc] 
                                        initWithImage:[UIImage imageNamed:@"comment_toolBarIcon.png"] 
                                        style:UIBarButtonItemStylePlain 
                                        target:self 
                                        action:@selector(commentAction)];
        
		UIBarButtonItem *rePublishItem = [[UIBarButtonItem alloc] 
                                          initWithImage:[UIImage imageNamed:@"rePublish_toolBarIcon.png"] 
                                          style:UIBarButtonItemStylePlain 
                                          target:self 
                                          action:@selector(rePublishAction)];
        
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] 
                                                initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                target:self 
                                                action:nil];
        
        UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] 
                                     initWithImage:[UIImage imageNamed:@"more_toolBarIcon.png"] 
                                     style:UIBarButtonItemStylePlain 
                                     target:self 
                                     action:@selector(moreAction:)];
        
        UIView *tmpView=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 44)]autorelease];
        UIBarButtonItem *branding = [[UIBarButtonItem alloc] initWithCustomView:tmpView];
        
		_toolbar.items = [NSArray arrayWithObjects:commentItem,branding, rePublishItem, branding,moreItem, nil];
        
        [commentItem release];
        [rePublishItem release];
        [moreItem release];
        [spaceItem release];
        [branding release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self setNavigationBarItem];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }

#pragma mark -ToolBar Buttom action implement-
/*
 *评论
 */
- (void)commentAction{
	if([self.delegate respondsToSelector:@selector(operate:)]){
		[self.delegate operate:comment];
	}
}

/*
 *转发（人人网：分享）
 */
- (void)rePublishAction{
	if([self.delegate respondsToSelector:@selector(operate:)]){
		[self.delegate operate:republish];
	}
}

- (void)moreAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(moreToolBar_TouchUpInside:)]) {
        [self.delegate moreToolBar_TouchUpInside:sender];
    }
}

#pragma mark - private method -
- (void)setNavigationBarItem{
    UIButton *btn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                       frame:CGRectMake(0, 0, 45, 45)
                                     imgName:@"back.png"
                                 eventTarget:self
                                 touchUpFunc:@selector(back_click)
                               touchDownFunc:nil];
    
    UIBarButtonItem *backBarItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=backBarItem;
    [backBarItem release];
}

-(void)back_click{
	[self.navigationController popViewControllerAnimated:YES];
}


@end
