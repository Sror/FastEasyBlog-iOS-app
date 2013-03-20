//
//  FontSettingController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 10/6/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "FontSettingController.h"
#import "FontTableViewCell.h"

@interface FontSettingController ()

@property (nonatomic,retain) NSMutableArray *keyArr;
@property (nonatomic,retain) NSString *currentFontName;
@property (nonatomic,retain) NSIndexPath *currentIndexPath;

//加載tableview的數據源
- (void)loadTableViewDataSource;

//修改字体
- (void)modifyConfigWithNewFontName:(NSString*)newFontName;

- (void)setLeftNavigationBarItem;

@end

@implementation FontSettingController

@synthesize fontTableView;
@synthesize currentFontName;

- (void)dealloc{
    [fontTableView release],fontTableView=nil;
    [_dataSource release],_dataSource=nil;
    [_keyArr release],_keyArr=nil;
    [currentFontName release],currentFontName=nil;
    [_currentIndexPath release],_currentIndexPath=nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftNavigationBarItem];
    self.navigationItem.title=@"字体设置";
    self.fontTableView.dataSource=self;
    self.fontTableView.delegate=self;
    self.currentFontName=AppConfig(@"weibo_text_fontName");     //current font name
    [self loadTableViewDataSource];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"可选字体";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FontTableViewCell *cell=[[[FontTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease];
    
    NSString *value=[self.dataSource objectForKey:[self.keyArr objectAtIndex:indexPath.row]];
    cell.fontLabel.font=[UIFont fontWithName:value size:15.0f];
    cell.fontLabel.text=[self.keyArr objectAtIndex:indexPath.row];
    
    cell.isChecked=([self.currentFontName isEqualToString:value])?YES:NO;
    if (cell.isChecked) {
        self.currentIndexPath=indexPath;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FontTableViewCell *oldCell=(FontTableViewCell*)[tableView cellForRowAtIndexPath:self.currentIndexPath];
    oldCell.isChecked=NO;
    FontTableViewCell *newCell=(FontTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    newCell.isChecked=YES;
    NSString *value=[self.dataSource objectForKey:[self.keyArr objectAtIndex:indexPath.row]];
    [self modifyConfigWithNewFontName:value];
}

#pragma mark - private methods -
/*
 *加載tableview的數據源
 */
- (void)loadTableViewDataSource{
    _keyArr=[[NSMutableArray alloc]initWithObjects:@"系统默认字体",@"微软雅黑",@"华康少女体", nil];
    _dataSource=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"Heiti SC",@"系统默认字体",@"MicrosoftYaHei",@"微软雅黑",@"FrLtDFGirl",@"华康少女体", nil];
}

/*
 *修改字体
 */
- (void)modifyConfigWithNewFontName:(NSString*)newFontName{
    if (!newFontName||[newFontName isEqualToString:@""]) {
        return;
    }
    
    [[FEBAppConfig sharedAppConfig] setValue:newFontName 
                                      forKey:@"weibo_text_fontName"];
    [[FEBAppConfig sharedAppConfig] setValue:newFontName 
                                      forKey:@"sourceWeibo_text_fontName"];
    [[FEBAppConfig sharedAppConfig] setValue:newFontName 
                                      forKey:@"renrenStatus_text_fontName"];
    [[FEBAppConfig sharedAppConfig] setValue:newFontName 
                                      forKey:@"renrenBlog_introduction_fontName"];
    [[FEBAppConfig sharedAppConfig] setValue:newFontName 
                                      forKey:@"renrenPhoto_desc_fontName"];
    [[FEBAppConfig sharedAppConfig] setValue:newFontName 
                                      forKey:@"renrenBlog_detail_fontName"];
}

#pragma mark - private method -
- (void)setLeftNavigationBarItem{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 45, 45);
    [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back_touchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=backBarItem;
    [backBarItem release];
}

-(void)back_touchUpInside{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
