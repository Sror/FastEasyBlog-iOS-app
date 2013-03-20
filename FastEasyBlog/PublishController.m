//
//  PublishController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "PublishController.h"
#import "UIPlaceHolderTextView.h"
#import "RenRenManager.h"
#import "TencentWeiboManager.h"
#import "SinaWeiboManager.h"
#import "PlatformSwitch.h"              		//自定义状态栏
#import "MapKitDragAndDropViewController.h"
#import "TencentWeiboPublishOperation.h"
#import "RenRenPublishOperation.h"

@interface PublishController ()

@property (nonatomic,retain) NSArray *photoArray;
@property (nonatomic,retain) UIPlaceHolderTextView *publishTxtView;
@property (nonatomic,retain) UIView * tipbarView;
@property (nonatomic,retain) UIView *toolbarView;
@property (nonatomic,retain) UIButton *renrenToolbarItem;
@property (nonatomic,retain) UIButton *tencentToolbarItem;
@property (nonatomic,retain) UIButton *sinaToolbarItem;
@property (nonatomic,retain) UIButton *tianyaToolbarItem;
@property (nonatomic,retain) ClickableLabel *strLengthLabel;

@property (nonatomic,retain) UIButton *delBtn;
@property (nonatomic,retain) PlatformSwitch *plaformSwitch;              //平台開關對象
@property (nonatomic,retain) WBEngine *engine;
@property (nonatomic,retain) MTStatusBarOverlay *overlay;
@property (nonatomic,retain) PhotoPickerController *photoPicker_;        //获取相册图片
@property (nonatomic,assign) uint actionSheetClickByView;                 //0－清除文字；1－缩略图按钮

//實例化文本輸入框
-(void)initPlaceholderTextView;

//實例化字符長度標簽
-(void)initStrLengthLabel;

//實例化工具欄
-(void)initToolBar;

//为导航栏设置右侧的自定义按钮
-(void)setRightBarButtonForNavigationBar;

//为导航栏设置左侧的自定义返回按钮
-(void)setLeftBarButtonForNavigationBar;

//设置输入框下方自定义工具栏
-(void)setCustomToolbarItems;

//清空輸入內容
-(void)clearInputFromTextView;

//点击平台按钮的触发事件
-(void)renrenToolBar_click:(id)sender;

-(void)sinaWeiboToolBar_click:(id)sender;

-(void)tencentWeiboToolBar_click:(id)sender;

-(void)tianyaToolBar_click:(id)sender;

//點擊左側工具圖片按鈕的觸發事件
-(void)photoToolBar_click:(id)sender;

//點擊左側位置工具按鈕的觸發事件
-(void)lbsPositionToolBar_click:(id)sender;

//為照片生成縮略圖
-(void)generateSmallImgForPhoto:(UIImage*)img;

@end


@implementation PublishController


@synthesize photoPicker_;
@synthesize actionSheetClickByView;

- (void)dealloc {
    [_photoArray release],_photoArray=nil;
	[_publishTxtView release],_publishTxtView=nil;
    [_tipbarView release],_tipbarView=nil;
	[_toolbarView release],_toolbarView=nil;
    [_renrenToolbarItem release],_renrenToolbarItem=nil;
    [_tencentToolbarItem release],_tencentToolbarItem=nil;
    [_sinaToolbarItem release],_sinaToolbarItem=nil;
    [_tianyaToolbarItem release],_tianyaToolbarItem=nil;
	[_strLengthLabel release],_strLengthLabel=nil;
    [_plaformSwitch release],_plaformSwitch=nil;
    [_engine release],_engine=nil;
    [photoPicker_ release],photoPicker_=nil;
    
	[super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
              content:(NSString*)txt{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		//實例化一個平台開關對象
        _plaformSwitch=[[PlatformSwitch alloc]init];
        
        _plaformSwitch.isRenRenOpen=[RenRenManager isBoundToApplication];
        _plaformSwitch.isTencentWeiboOpen=[TencentWeiboManager isBoundToApplication];
        _plaformSwitch.isSinaWeiboOpen=[SinaWeiboManager isBoundToApplication];
                
        _plaformSwitch.isRenRenCanOpen=YES;
        _plaformSwitch.isSinaWeiboCanOpen=YES;
        _plaformSwitch.isTencentWeiboCanOpen=YES;
        _plaformSwitch.isTianyaCanOpen=YES;
	}
	return self;
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initPlaceholderTextView];
    [self initStrLengthLabel];
    
	[self initToolBar];
    [self setCustomToolbarItems];
	
	//设置右侧自定义的导航栏按钮
	[self setRightBarButtonForNavigationBar];
	
	//设置左侧自定义返回按钮
	[self setLeftBarButtonForNavigationBar];
	self.navigationItem.title=@"分享心情";
    
}


 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
     return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark UITextViewDelegate
//显示输入剩余可输入字符个数
-(void)textViewDidChange:(UITextView *)textView{
	int avaliableStrLength=STRLENGTH-[self.publishTxtView.text length];
	if (avaliableStrLength<=20&&avaliableStrLength>0) {
		self.strLengthLabel.textColor=[UIColor redColor];
	}else if (avaliableStrLength<=0) {
		avaliableStrLength=0;
		self.publishTxtView.text=[self.publishTxtView.text substringToIndex:STRLENGTH];
	}else {
		self.strLengthLabel.textColor=[UIColor blackColor];
	}
	
	self.strLengthLabel.text=[NSString stringWithFormat:@"%d",avaliableStrLength];
    
    if ([self.strLengthLabel.text isEqualToString:@"140"]) {
        self.delBtn.hidden=YES;
    }else{
        self.delBtn.hidden=NO;
    }
}

#pragma mark -
#pragma mark Private method

/*
 *實例化文本輸入框
 */
-(void)initPlaceholderTextView{
    //文本输入框（带占位符）
	UIPlaceHolderTextView *txtView=[[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 100)];
	self.publishTxtView=txtView;
    [txtView release];
	self.publishTxtView.backgroundColor=[UIColor whiteColor];
	self.publishTxtView.placeholder=@"说点什么吧...";
	self.publishTxtView.delegate=self;
	[self.publishTxtView setFont:[UIFont fontWithName:@"Arial" size:DEFAULTFONTSIZE]];
	[self.view addSubview:self.publishTxtView];
	[self.publishTxtView becomeFirstResponder];
}

//實例化字符長度標簽與刪除按鈕
-(void)initStrLengthLabel{
    CGFloat X_tipbarView=self.publishTxtView.frame.origin.x;
    CGFloat y_tipbarView=self.publishTxtView.frame.origin.y+self.publishTxtView.frame.size
    .height;
    UIView *tmpTipbarView=[[UIView alloc]initWithFrame:CGRectMake(X_tipbarView, y_tipbarView, self.publishTxtView.frame.size.width, 30)];
    self.tipbarView=tmpTipbarView;
    self.tipbarView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.tipbarView];
    [tmpTipbarView release];
    
    //设置提示字符数的Label
	CGFloat x_lbl=self.tipbarView.frame.origin.x+self.tipbarView.frame.size.width-60;
	CGFloat y_lbl=0;
    
	ClickableLabel *strLabel=[[ClickableLabel alloc]initWithFrame:CGRectMake(x_lbl, y_lbl, 33, 25)];
	self.strLengthLabel=strLabel;
    [self.strLengthLabel setLblDelegate:self];       //設置其代理為當前controller
    self.strLengthLabel.textColor=RGBACOLOR(105, 105, 105, 1.0);
	self.strLengthLabel.text=[NSString stringWithFormat:@"%d",STRLENGTH];
	self.strLengthLabel.textAlignment=UITextAlignmentLeft;
	[self.tipbarView addSubview:self.strLengthLabel];
	[strLabel release];
    
    //設置刪除按鈕
    _delBtn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                           frame:CGRectMake(x_lbl+self.strLengthLabel.frame.size.width, 5, 16, 16)
                                         imgName:@"deleteBtn.png"
                                     eventTarget:self
                                     touchUpFunc:@selector(doClickAtTarget:)
                                   touchDownFunc:nil];
    self.delBtn.hidden=YES;
    
    [self.tipbarView addSubview:self.delBtn];
}

//實例化工具欄
-(void)initToolBar{
    //设置文本框下面的工具栏
	CGFloat x_toolBarView=self.publishTxtView.frame.origin.x;
	CGFloat y_toolBarView=self.publishTxtView.frame.origin.y+self.publishTxtView.frame.size.height+self.tipbarView.frame.size.height+4;
	UIView *tempView=[[UIView	alloc]initWithFrame:CGRectMake(x_toolBarView, y_toolBarView, self.publishTxtView.frame.size.width, 34)];
	self.toolbarView=tempView;
	[self.view addSubview:self.toolbarView];
	[tempView release];
}

/*
 *为导航栏设置右侧的自定义按钮
 */
-(void)setRightBarButtonForNavigationBar{
    UIButton *btn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                 frame:CGRectMake(285,0,50,50)
                                               imgName:@"publishBtn.png"
                                           eventTarget:self
                                           touchUpFunc:@selector(publish_click)
                                         touchDownFunc:@selector(publish_touchDown)];
    
	UIBarButtonItem *menuBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
	self.navigationItem.rightBarButtonItem=menuBtn;
	[menuBtn release];
}

/*
 *为导航栏设置左侧的自定义返回按钮
 */
-(void)setLeftBarButtonForNavigationBar{
    UIButton *btn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                 frame:CGRectMake(0, 0, 45, 45)
                                               imgName:@"closeBtn.png"
                                           eventTarget:self
                                           touchUpFunc:@selector(closeButton_touchUpInside)
                                         touchDownFunc:@selector(closeButton_touchDown)];
	
	UIBarButtonItem *backBarItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
	self.navigationItem.leftBarButtonItem=backBarItem;
	[backBarItem release];
}

-(void)closeButton_touchUpInside{
    UIButton *btn=(UIButton*)self.navigationItem.leftBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
	
    [self dismissModalViewControllerAnimated:YES];
}

-(void)closeButton_touchDown{
	UIButton *btn=(UIButton*)self.navigationItem.leftBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"closeBtn_highlight.png"] forState:UIControlStateNormal];
}

/*
 *设置输入框下方自定义工具栏
 */
-(void)setCustomToolbarItems{
    //圖片
    UIButton *photoBtn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                      frame:CGRectMake(5, 0, 25, 25)
                                                    imgName:@"photoBtn.png"
                                                eventTarget:self
                                                touchUpFunc:@selector(photoToolBar_click)
                                              touchDownFunc:nil];
    [self.toolbarView addSubview:photoBtn];
    
    //拍照
    UIButton *cameraBtn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                      frame:CGRectMake(55,0,25,25)
                                                    imgName:@"cameraBtn.png"
                                                eventTarget:self
                                                touchUpFunc:@selector(cameraToolbar_click)
                                              touchDownFunc:nil];
    [self.toolbarView addSubview:cameraBtn];
    
    //地理位置
    UIButton *lbsPosition=[UIButton buttonWithType:UIButtonTypeCustom];
    lbsPosition.frame=CGRectMake(105,0,25,25);
    [lbsPosition setBackgroundImage:[UIImage imageNamed:@"positionBtn.png"] forState:UIControlStateNormal];
    [lbsPosition addTarget:self action:@selector(lbsPositionToolBar_click:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbarView addSubview:lbsPosition];
    
    //人人
    UIButton *renrenBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    renrenBtn.frame=CGRectMake(240, 2, 23, 23);
    if (self.plaformSwitch.isRenRenOpen&&self.plaformSwitch.isRenRenCanOpen) {
        [renrenBtn setBackgroundImage:[UIImage imageNamed:@"ren-highlight.png"] forState:UIControlStateNormal];
    }else{
        [renrenBtn setBackgroundImage:[UIImage imageNamed:@"ren-gray.png"] forState:UIControlStateNormal];
    }
    
    [renrenBtn addTarget:self action:@selector(renrenToolBar_click:) forControlEvents:UIControlEventTouchUpInside];
    self.renrenToolbarItem=renrenBtn;
    [self.toolbarView addSubview:self.renrenToolbarItem];
    
    //腾讯微博
    UIButton *tencentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    tencentBtn.frame=CGRectMake(270, 2, 23, 23);
    if (self.plaformSwitch.isTencentWeiboOpen&&self.plaformSwitch.isTencentWeiboCanOpen) {
        [tencentBtn setBackgroundImage:[UIImage imageNamed:@"tencent-highlight.png"] forState:UIControlStateNormal];
    }else{
        [tencentBtn setBackgroundImage:[UIImage imageNamed:@"tencent-gray.png"] forState:UIControlStateNormal];
    }
    
    [tencentBtn addTarget:self action:@selector(tencentWeiboToolBar_click:) forControlEvents:UIControlEventTouchUpInside];
    self.tencentToolbarItem=tencentBtn;
    [self.toolbarView addSubview:self.tencentToolbarItem];
    
    //新浪微博
    UIButton *sinaBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sinaBtn.frame=CGRectMake(260, 2, 23, 23);
    if (self.plaformSwitch.isSinaWeiboOpen&&self.plaformSwitch.isSinaWeiboCanOpen) {
        [sinaBtn setBackgroundImage:[UIImage imageNamed:@"sina-highlight.png"] forState:UIControlStateNormal];
    }else {
        [sinaBtn setBackgroundImage:[UIImage imageNamed:@"sina-gray.png"] forState:UIControlStateNormal];
    }
    
    [sinaBtn addTarget:self action:@selector(sinaWeiboToolBar_click:) forControlEvents:UIControlEventTouchUpInside];
    self.sinaToolbarItem=sinaBtn;
    self.sinaToolbarItem.hidden=YES;
    [self.toolbarView addSubview:self.sinaToolbarItem];
    
    //天涯
    UIButton *tianyaBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    tianyaBtn.hidden=YES;
    tianyaBtn.frame=CGRectMake(290, 2, 23, 23);
    [tianyaBtn setBackgroundImage:[UIImage imageNamed:@"tianya-highlight.png"] forState:UIControlStateNormal];
    
    [tianyaBtn addTarget:self action:@selector(tianyaToolBar_click:) forControlEvents:UIControlEventTouchUpInside];
    self.tianyaToolbarItem=tianyaBtn;
    [self.toolbarView addSubview:self.tianyaToolbarItem];
    
}

/*
 *清空輸入內容
 */
-(void)clearInputFromTextView{
    self.publishTxtView.text=@"";
    self.strLengthLabel.text=[NSString stringWithFormat:@"%d",STRLENGTH];
}

//点击平台按钮的触发事件
-(void)renrenToolBar_click:(id)sender{
    if (self.plaformSwitch.isRenRenOpen) {
        self.plaformSwitch.isRenRenOpen=NO;
        //换图片
        [self.renrenToolbarItem setBackgroundImage:[UIImage imageNamed:@"ren-gray.png"] forState:UIControlStateNormal];
    }else {
        //如果可以点亮并且已经完成了绑定
        if (self.plaformSwitch.isRenRenCanOpen&&[RenRenManager isBoundToApplication]) {
            self.plaformSwitch.isRenRenOpen=YES;
            //换图片
            [self.renrenToolbarItem setBackgroundImage:[UIImage imageNamed:@"ren-highlight.png"] forState:UIControlStateNormal];
        }
    }
}

-(void)sinaWeiboToolBar_click:(id)sender{
    if (self.plaformSwitch.isSinaWeiboOpen) {
        self.plaformSwitch.isSinaWeiboOpen=NO;
        //换图片
        [self.sinaToolbarItem setBackgroundImage:[UIImage imageNamed:@"sina-gray.png"] forState:UIControlStateNormal];
    }else {
        //如果可以点亮并且已经完成了绑定
        if (self.plaformSwitch.isSinaWeiboCanOpen&&[SinaWeiboManager isBoundToApplication]) {
            self.plaformSwitch.isSinaWeiboOpen=YES;
            //换图片
            [self.sinaToolbarItem setBackgroundImage:[UIImage imageNamed:@"sina-highlight.png"] forState:UIControlStateNormal];
        }
    }
}

-(void)tencentWeiboToolBar_click:(id)sender{
    if (self.plaformSwitch.isTencentWeiboOpen) {
        self.plaformSwitch.isTencentWeiboOpen=NO;
        //换图片
        [self.tencentToolbarItem setBackgroundImage:[UIImage imageNamed:@"tencent-gray.png"] forState:UIControlStateNormal];
    }else {
        //如果可以点亮并且已经完成了绑定
        if (self.plaformSwitch.isTencentWeiboCanOpen&&
            [TencentWeiboManager isBoundToApplication]) {
            self.plaformSwitch.isTencentWeiboOpen=YES;
            //换图片
            [self.tencentToolbarItem setBackgroundImage:[UIImage imageNamed:@"tencent-highlight.png"] forState:UIControlStateNormal];
        }
    }
}

-(void)tianyaToolBar_click:(id)sender{
    if (self.plaformSwitch.isTianyaOpen) {
        self.plaformSwitch.isTianyaOpen=NO;
        //换图片
        [self.tianyaToolbarItem setBackgroundImage:[UIImage imageNamed:@"tianya-gray.png"] forState:UIControlStateNormal];
    }else {
        //如果可以点亮并且已经完成了绑定
        if (self.plaformSwitch.isTianyaCanOpen) {
            self.plaformSwitch.isTianyaOpen=YES;
            //换图片
            [self.tianyaToolbarItem setBackgroundImage:[UIImage imageNamed:@"tianya-highlight.png"] forState:UIControlStateNormal];
        }
    }
}

//點擊左側工具按鈕的觸發事件
-(void)photoToolBar_click:(id)sender{
    if (!photoPicker_) {
        photoPicker_ = [[PhotoPickerController alloc] initWithDelegate:self];
    }
    [photoPicker_ showWithPhotoLibrary];
}

-(void)cameraToolbar_click:(id)sender{
    if (!photoPicker_) {
        photoPicker_ = [[PhotoPickerController alloc] initWithDelegate:self];
    }
    [photoPicker_ showWithCamera];
}

//點擊左側位置工具按鈕的觸發事件
-(void)lbsPositionToolBar_click:(id)sender{
    [self.navigationController pushViewController:[[[MapKitDragAndDropViewController alloc]initWithNibName:@"MapKitDragAndDropViewController" bundle:nil]autorelease] animated:YES];
}

/*
 *為照片生成縮略圖,並顯示在界面上
 */
-(void)generateSmallImgForPhoto:(UIImage*)img{
    UIButton *imgButton=[UIButton buttonWithType:UIButtonTypeCustom];
    imgButton.tag=4321;
    imgButton.frame=CGRectMake(10, 100, 30, 30);
    imgButton.backgroundColor=[UIColor redColor];
    CGSize imgSize=THUMBNAILSSIZE;
    UIGraphicsBeginImageContext(imgSize);
    CGRect imageRect=CGRectMake(0.0, 0.0, imgSize.width, imgSize.height);
    [img drawInRect:imageRect];
    [imgButton setBackgroundImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateNormal];
    UIGraphicsEndImageContext();
    [imgButton addTarget:self action:@selector(imgClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imgButton];
}

-(void)imgClick:(id)sender{
    actionSheetClickByView=1;
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"查看原图" otherButtonTitles:@"取消图片选择",nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];
}

-(void)clearTmpImages{
    if (self.plaformSwitch.isRenRenOpen) {
        if (fileExistsAtPath(PUBLISH_IMAGEPATH_RENREN)) {
            removerAtItem(PUBLISH_IMAGEPATH_RENREN);
        }
    }
    
    if (self.plaformSwitch.isTencentWeiboOpen) {
        if (fileExistsAtPath(PUBLISH_IMAGEPATH_TENCENTWEIBO)) {
            removerAtItem(PUBLISH_IMAGEPATH_TENCENTWEIBO);
        }
    }
}

-(void)saveTmpImage:(UIImage *)image{
    if (self.plaformSwitch.isTencentWeiboOpen) {
        [UIImageJPEGRepresentation(image,0.5) writeToFile:PUBLISH_IMAGEPATH_TENCENTWEIBO 
                                               atomically:YES];
    }
    
    if (self.plaformSwitch.isRenRenOpen) {
        [UIImageJPEGRepresentation(image,0.5) writeToFile:PUBLISH_IMAGEPATH_RENREN 
                                               atomically:YES];
    }
}

#pragma mark -
#pragma mark navigationBar delegate
/*
 *发送
 */
-(void)publish_click{    
	UIButton *btn=(UIButton*)self.navigationItem.rightBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"publishBtn.png"] forState:UIControlStateNormal];
    
    //播放提示音
    if ([AppConfig(@"isAudioOpen") boolValue]) {
        [GlobalInstance playTipAudio:[[NSBundle mainBundle] URLForResource:@"drip" withExtension:@"WAV"]];
    }
	
	if ([self.publishTxtView.text length]==0) {
		[GlobalInstance showMessageBoxWithMessage:@"请说点什么吧!"];
		return;
	}
    
    NSString *weiboTextContent=self.publishTxtView.text;
    
    if (self.plaformSwitch.isRenRenOpen) {
        PublishOperation *renrenOperation=[[[RenRenPublishOperation alloc]initWithOperateParams:weiboTextContent]autorelease];
        
        [((FastEasyBlogAppDelegate*)appDelegateObj).operationQueue addOperation:renrenOperation];
    }
    
    if (self.plaformSwitch.isTencentWeiboOpen) {
        PublishOperation *tencentOperation=[[[TencentWeiboPublishOperation alloc]initWithOperateParams:weiboTextContent]autorelease];
        
        [((FastEasyBlogAppDelegate*)appDelegateObj).operationQueue addOperation:tencentOperation];
    }
	
	//清空內容
    [self clearInputFromTextView];
    
    UIButton *imgBtn=(UIButton*)[self.view viewWithTag:4321];
    [imgBtn removeFromSuperview];
    
    [self dismissModalViewControllerAnimated:YES];
}


/*
 *按下替换为高亮图片
 */
-(void)publish_touchDown{
	UIButton *btn=(UIButton*)self.navigationItem.rightBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"publishBtn_highlight.png"] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark Click Event Delegate
-(void)doClickAtTarget:(ClickableLabel *)label{
    if ([self.publishTxtView.text length]==0) {
        return;
    }
    
    actionSheetClickByView=0;
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"" 
                                                          delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"清空所有內容" otherButtonTitles:nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];
}

#pragma mark -
#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:                     
            switch (actionSheetClickByView) {
                case 0:                             //点击清除文字
                    [self clearInputFromTextView];
                    break;
                    
                case 1:                             //点击缩略图按钮,同时查看原图
                {
                    NSMutableArray *photos = [[NSMutableArray alloc] init];
                    MWPhoto *photo=nil;
                    
                    if (self.plaformSwitch.isRenRenOpen) {
                        photo = [MWPhoto photoWithFilePath:PUBLISH_IMAGEPATH_RENREN];
                    }else if(self.plaformSwitch.isTencentWeiboOpen){
                        photo = [MWPhoto photoWithFilePath:PUBLISH_IMAGEPATH_TENCENTWEIBO];
                    }
                    
                    photo.caption = @"待上传图片";
                    [photos addObject:photo];
                    
                    self.photoArray=photos;
                    
                    // Create browser
                    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
                    browser.displayActionButton = YES;
                    
                    UINavigationController *navCtrller = [[UINavigationController alloc] initWithRootViewController:browser];
                    navCtrller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [self presentModalViewController:navCtrller animated:YES];
                    [navCtrller release];
                    
                    // Release
                    [browser release];
                    [photos release];
                    
                }
                    break;
                default:
                    break;
            }
            
            break;
            
        case 1:
            switch (actionSheetClickByView) {
                case 0:                             
                    break;
                    
                case 1:                   //取消图片选择
                {
                    [self clearTmpImages];
                    UIButton *imgBtn=(UIButton*)[self.view viewWithTag:4321];
                    [imgBtn removeFromSuperview];
                }
                    break;
            }
            break;
            
        case 2:                                     
            break;
    }
}

#pragma mark -
#pragma mark PhotoPickerControllerDelegate
- (void)photoPickerController:(PhotoPickerController *)controller
    didFinishPickingWithImage:(UIImage *)image
                 isFromCamera:(BOOL)isFromCamera 
{
    [self clearTmpImages];
    
    [self saveTmpImage:image];
    
    [self generateSmallImgForPhoto:image];
}

#pragma mark - MWPhotoBrowserDelegate -
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photoArray.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser
             photoAtIndex:(NSUInteger)index {
    if (index < self.photoArray.count)
        return [self.photoArray objectAtIndex:index];
    return nil;
}


@end
