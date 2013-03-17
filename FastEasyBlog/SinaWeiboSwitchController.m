//
//  SinaWeiboSwitchController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/22/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "SinaWeiboSwitchController.h"
#import "SinaWeiboMainController.h"
#import "SinaWeiboAtMeController.h"
#import "SinaWeiboCommentToMeController.h"
#import "SinaWeiboHotFavoritesController.h"
#import "SinaWeiboPublishedByMeController.h"

@interface SinaWeiboSwitchController ()



@end

@implementation SinaWeiboSwitchController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil platform:SinaWeibo tabBarImgName:@"sinaWeibo_tabBarBG.png"];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    super.delegate=self;
    [super viewDidLoad];
    [self.navigationTitleLbl setLblDelegate:self];
    [self.popViewGuideImgBtn addTarget:self action:@selector(doClickAtTarget:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    SinaWeiboMainController *mainCtrller=[[SinaWeiboMainController alloc] 
                                          initWithRefreshHeaderViewEnabled:YES andLoadMoreFooterViewEnabled:YES andTableViewFrame:tableViewFrame];
    [self addChildViewController:mainCtrller];
    self.currentCtrller=mainCtrller;
    self.navigationTitleLbl.text=@"新浪微博";
    [self.contentView addSubview:mainCtrller.view];
    [mainCtrller release];
    
    //@我 controller
    SinaWeiboAtMeController *atMeController=[[SinaWeiboAtMeController alloc] 
                                             initWithRefreshHeaderViewEnabled:YES andLoadMoreFooterViewEnabled:YES andTableViewFrame:tableViewFrame];
    [self addChildViewController:atMeController];
    [atMeController release];
    
    //评论箱
    SinaWeiboCommentToMeController *commentToMeCtrller=[[SinaWeiboCommentToMeController alloc] initWithRefreshHeaderViewEnabled:YES andLoadMoreFooterViewEnabled:YES andTableViewFrame:tableViewFrame];
    [self addChildViewController:commentToMeCtrller];
    [commentToMeCtrller release];
    
    //热门收藏
    SinaWeiboHotFavoritesController *hotFavoritesCtrller=[[SinaWeiboHotFavoritesController alloc] initWithRefreshHeaderViewEnabled:YES andLoadMoreFooterViewEnabled:YES andTableViewFrame:tableViewFrame];
    [self addChildViewController:hotFavoritesCtrller];
    [hotFavoritesCtrller release];
    
    //我发表的
    SinaWeiboPublishedByMeController *publishedByMeCtrller=[[SinaWeiboPublishedByMeController alloc] initWithRefreshHeaderViewEnabled:YES andLoadMoreFooterViewEnabled:YES andTableViewFrame:tableViewFrame];
    [self addChildViewController:publishedByMeCtrller];
    [publishedByMeCtrller release];
    
    
    //and so on
    
    
    return [self.childViewControllers retain];
}

- (NSMutableArray*)initChildViewControllerNavTitles{
    return [[[NSMutableArray alloc]initWithObjects:@"新浪微博",@"@我的",@"评论箱",@"热门收藏",@"我发表的", nil]autorelease];
}

#pragma mark - Click Event Delegate -
-(void)doClickAtTarget:(ClickableLabel *)label{
    UIButton *guideBtn=(UIButton*)[self.navigationItem.titleView viewWithTag:POPVIEWGUIDE_TAG];
    [guideBtn setBackgroundImage:[UIImage imageNamed:@"popup.png"] forState:UIControlStateNormal];
    if ([self.currentCtrller isKindOfClass:[SinaWeiboMainController class]]) {
        [(SinaWeiboMainController*)self.currentCtrller showListView];
    }
}

@end
