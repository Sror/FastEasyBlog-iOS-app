//
//  RenRenFeedCategoryController.m
//  FastEasyBlog
//
//  Created by svp on 17.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "RenRenFeedCategoryController.h"
#import "RenRenMainController.h"
#import "RevealController.h"
#import "RenRenNewsCategoryCell.h"

#import "Global.h"

#define CELL_HEIGHT 42.0f

@interface RenRenFeedCategoryController ()

//获取类别列表
-(void)loadCategoryList;

//获取类别图片
-(void)loadCategoryImages;

@end


@implementation RenRenFeedCategoryController

@synthesize categoryTableView,categoryDictionary,categoryImages,categoryKeysArr;

-(void)dealloc{
	[categoryTableView release];	categoryTableView=nil;
	[categoryDictionary release];	categoryDictionary=nil;
    [categoryImages release];       categoryImages=nil;
    [categoryKeysArr release];      categoryKeysArr=nil;
	[super dealloc];
}

-(id)initWithNibName:(NSString *)nibNameOrNil
              bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationBar *navigationBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        navigationBar.tintColor=defaultNavigationBGColor;
        UINavigationItem *navigationItem=[[UINavigationItem alloc]initWithTitle:@"类别"];
        
        [navigationBar pushNavigationItem:navigationItem animated:YES];
        [navigationItem release];
        [self.view addSubview:navigationBar];
        [navigationBar release];
        
        isFirstShow=YES;
                                    
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.categoryTableView.delegate=self;
	self.categoryTableView.dataSource=self;

    [self initCategoryInfo];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

/*
 *实例化类别信息
 */
-(void)initCategoryInfo{
    NSArray *tmpCategoryArr=[[NSArray alloc]initWithObjects:@"全部",@"状态",@"日志",@"照片",@"分享",nil];
    self.categoryKeysArr=tmpCategoryArr;
    [tmpCategoryArr release];
    
    [self loadCategoryList];
    [self loadCategoryImages];
}

#pragma mark -
#pragma mark Methods
/*
 *获取类别列表
 */
-(void)loadCategoryList{
	NSMutableDictionary *tmpCategoryDictionary=[[NSMutableDictionary alloc]init];
    [tmpCategoryDictionary setValue:@"10,11,20,21,22,23,30,31,32,36" forKey:@"全部"];
	[tmpCategoryDictionary setValue:@"10,11" forKey:@"状态"];
	[tmpCategoryDictionary setValue:@"20,21,22,23" forKey:@"日志"];
	[tmpCategoryDictionary setValue:@"30,31,32,36" forKey:@"照片"];
    [tmpCategoryDictionary setValue:@"21,23,32,36" forKey:@"分享"];
    self.categoryDictionary=[[tmpCategoryDictionary copy]autorelease];
	[tmpCategoryDictionary release];
}

/*
 *获取类别图片
 */
-(void)loadCategoryImages{
    NSMutableDictionary *tmpCategoryImages=[[NSMutableDictionary alloc]init];
    [tmpCategoryImages setValue:@"feedIcon-large.png" forKey:@"全部"];
	[tmpCategoryImages setValue:@"statusIcon-large.png" forKey:@"状态"];
	[tmpCategoryImages setValue:@"blogIcon-large.png" forKey:@"日志"];
	[tmpCategoryImages setValue:@"photoIcon-large.png" forKey:@"照片"];
    [tmpCategoryImages setValue:@"shareIcon-large.png" forKey:@"分享"];
    self.categoryImages=[[tmpCategoryImages copy]autorelease];
	[tmpCategoryImages release];
}



#pragma mark -
#pragma mark tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [self.categoryDictionary count];
}


-(UITableViewCell*)tableView:(UITableView *)tableView
       cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifierStr=@"categoryCellIdentifier";
    RenRenNewsCategoryCell *cell=nil;
    cell=(RenRenNewsCategoryCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];
    if (!cell) {
        cell=[[[RenRenNewsCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr]autorelease];
    }
    
    cell.categoryName=[self.categoryKeysArr objectAtIndex:indexPath.row];
    cell.categoryImgView.image=[UIImage imageNamed:[self.categoryImages objectForKey:cell.categoryName]];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    isFirstShow=NO;
    RenRenNewsCategoryCell *currentCell=(RenRenNewsCategoryCell*)[tableView cellForRowAtIndexPath:indexPath];
    currentCell.isChecked=YES;
    
	RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    RenRenMainController *renrenMainController=[[RenRenMainController alloc]initWithNibName:@"RenRenMainView" bundle:nil];
    renrenMainController.currentCategories=[self.categoryDictionary objectForKey:[self.categoryKeysArr objectAtIndex:indexPath.row]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:renrenMainController];
    navigationController.navigationBar.tintColor=defaultNavigationBGColor;
    [renrenMainController release];
    [revealController setFrontViewController:navigationController animated:NO];
    [navigationController release];
}



@end
