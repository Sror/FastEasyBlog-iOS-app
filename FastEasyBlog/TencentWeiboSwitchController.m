//
//  TencentWeiboSwitchController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/22/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "TencentWeiboSwitchController.h"
#import "TencentWeiboMainController.h"
#import "TencentWeiboAtMeController.h"
#import "TencentWeiboHotRepublishController.h"
#import "TencentWeiboMyFavoritesController.h"
#import "TencentWeiboPublishedByMeController.h"

@interface TencentWeiboSwitchController ()

@end

@implementation TencentWeiboSwitchController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil platform:TencentWeibo tabBarImgName:@"tencentWeibo_tabBarBG.png"];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    super.delegate=self;
    [super viewDidLoad];    
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

#pragma mark - switch controller delegate -
- (NSArray*)initAndAddChildViewControllers{
    CGRect tableViewFrame=CGRectMake(0,
                                     0,
                                     WINDOWWIDTH,
                                     436-64);
    
    //main controller
    TencentWeiboMainController *mainCtrller=
    [[TencentWeiboMainController alloc]
        initWithRefreshHeaderViewEnabled:YES
            andLoadMoreFooterViewEnabled:YES
                       andTableViewFrame:tableViewFrame];
    
    [self addChildViewController:mainCtrller];
    self.currentCtrller=mainCtrller;
    self.navigationTitleLbl.text=@"腾讯微博";
    [self.navigationTitleLbl setLblDelegate:mainCtrller];
    [self.popViewGuideImgBtn addTarget:mainCtrller action:@selector(doClickAtTarget:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:mainCtrller.view];
    [mainCtrller release];
    
    //@me controller
    TencentWeiboAtMeController *atMeCtrller=[[TencentWeiboAtMeController alloc] initWithRefreshHeaderViewEnabled:YES
            andLoadMoreFooterViewEnabled:YES
                    andTableViewFrame:tableViewFrame];
    
    [self addChildViewController:atMeCtrller];
    [atMeCtrller release];
    
    //转发热榜
    TencentWeiboHotRepublishController *hotRepublishCtrller=[[TencentWeiboHotRepublishController alloc] initWithRefreshHeaderViewEnabled:YES
            andLoadMoreFooterViewEnabled:YES
                       andTableViewFrame:tableViewFrame];
    
    [self addChildViewController:hotRepublishCtrller];
    [hotRepublishCtrller release];
    
    //我的收藏
    TencentWeiboMyFavoritesController *myFavoritesCtrller=[[TencentWeiboMyFavoritesController alloc] initWithRefreshHeaderViewEnabled:YES
            andLoadMoreFooterViewEnabled:YES
                       andTableViewFrame:tableViewFrame];
    [self addChildViewController:myFavoritesCtrller];
    [myFavoritesCtrller release];
    
    //我发表的
    TencentWeiboPublishedByMeController *publishedByMeCtrller=[[TencentWeiboPublishedByMeController alloc] initWithRefreshHeaderViewEnabled:YES
            andLoadMoreFooterViewEnabled:YES
                       andTableViewFrame:tableViewFrame];
    [self addChildViewController:publishedByMeCtrller];
    [publishedByMeCtrller release];
    
    return [self.childViewControllers retain];
}

- (NSMutableArray*)initChildViewControllerNavTitles{
    return [[[NSMutableArray alloc] initWithObjects:
                                                    @"腾讯微博",
                                                    @"提及我的",
                                                    @"转发热榜",
                                                    @"我的收藏",
                                                    @"我发表的",
                                                    nil] autorelease];
}

@end
