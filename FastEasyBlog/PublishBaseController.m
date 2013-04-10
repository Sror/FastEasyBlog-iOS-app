//
//  PublishBaseController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/28/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "PublishBaseController.h"

typedef enum{
    TAG_TOOLBAR_PHOTO,
	TAG_TOOLBAR_CAMERA,
	TAG_TOOLBAR_LBSPOSITION,
	TAG_TOOLBAR_AT,
	TAG_TOOLBAR_TOPIC
}TAGS;

typedef enum{
    ACTION_TYPE_PUBLISHINGCONTENT,
    ACTION_TYPE_PHOTO
}ACTION_TYPE;


@interface PublishBaseController ()

@property (nonatomic,retain) UIView * tipbarView;
@property (nonatomic,retain) UIView *toolbarView;
@property (nonatomic,retain) ClickableLabel *strLengthLabel;
@property (nonatomic,retain) UIButton *delBtn;

@property (nonatomic,assign) ACTION_TYPE currentActionType;

@end

@implementation PublishBaseController


@synthesize delegate;
@synthesize currentActionType;

- (void)dealloc{
    [_photoArray release],_photoArray=nil;
    [_hud release],_hud=nil;
    [_strLengthLabel release];
    [_publishTxtView release];
    [_tipbarView release];
    [_toolbarView release];
    [_followedList release],_followedList=nil;
    [publishingContent release],publishingContent=nil;
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             platform:(AllPlatform)pt
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _currentPlatform=pt;
        
        //文本输入框（带占位符）
		_publishTxtView=[[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(0   , 0, VIEWCONTENTWIDTH, 100)];
		_publishTxtView.backgroundColor=[UIColor whiteColor];
		_publishTxtView.placeholder=@"说点什么吧...";
		_publishTxtView.delegate=self;
		[_publishTxtView setFont:[UIFont fontWithName:@"Arial" size:DEFAULTFONTSIZE]];
		
		CGFloat X_tipbarView=_publishTxtView.frame.origin.x;
		CGFloat y_tipbarView=_publishTxtView.frame.origin.y+_publishTxtView.frame.size.height;
        
		_tipbarView=[[UIView alloc]initWithFrame:CGRectMake(X_tipbarView, y_tipbarView, _publishTxtView.frame.size.width, 30)];
		_tipbarView.backgroundColor=[UIColor whiteColor];
		
		//设置提示字符数的Label
		CGFloat x_lbl=_tipbarView.frame.origin.x+_tipbarView.frame.size.width-60;
		CGFloat y_lbl=0;
        
        //输入字符提示
		_strLengthLabel=[[ClickableLabel alloc]initWithFrame:CGRectMake(x_lbl, y_lbl, 33, 25)];
		[_strLengthLabel setLblDelegate:self];
		_strLengthLabel.textColor=RGBACOLOR(105, 105, 105, 1.0);
		_strLengthLabel.text=[NSString stringWithFormat:@"%d",STRLENGTH];
		_strLengthLabel.textAlignment=UITextAlignmentLeft;
        
        //删除按钮图片
        _delBtn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom frame:CGRectMake(x_lbl+self.strLengthLabel.frame.size.width, 5, 16, 16) imgName:@"deleteBtn.png" eventTarget:self touchUpFunc:@selector(doClickAtTarget:) touchDownFunc:nil];
        
        _delBtn.hidden=YES;
		
		CGFloat x_toolBarView=_publishTxtView.frame.origin.x;
		CGFloat y_toolBarView=_publishTxtView.frame.origin.y+_publishTxtView.frame.size.height+_tipbarView.frame.size.height+4;
		_toolbarView=[[UIView alloc]initWithFrame:CGRectMake(x_toolBarView, y_toolBarView, _publishTxtView.frame.size.width, 34)];
		
		
		//----------------------toolBar items------------------
        //圖片
        _photoBtn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                 frame:CGRectMake(5, 0, 25, 25)
                                               imgName:@"photoBtn.png"
                                           eventTarget:self
                                           touchUpFunc:@selector(toolBarBotton_touchUpInside:)
                                         touchDownFunc:nil];
        _photoBtn.tag=TAG_TOOLBAR_PHOTO;
        
        [self.toolbarView addSubview:self.photoBtn];
		
		//拍照
        _cameraBtn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                  frame:CGRectMake(45,0,25,25)
                                                imgName:@"cameraBtn.png"
                                            eventTarget:self
                                            touchUpFunc:@selector(toolBarBotton_touchUpInside:)
                                          touchDownFunc:nil];
        _cameraBtn.tag=TAG_TOOLBAR_CAMERA;
		
		//地理位置
        _lbsPositionBtn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                       frame:CGRectMake(85,0,25,25)
                                                     imgName:@"positionBtn.png"
                                                 eventTarget:self
                                                 touchUpFunc:@selector(toolBarBotton_touchUpInside:)
                                               touchDownFunc:nil];
        _lbsPositionBtn.tag=TAG_TOOLBAR_LBSPOSITION;
		
		//@ 按钮
        _atBtn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                              frame:CGRectMake(125,0,25,25)
                                            imgName:@"atBtn.png"
                                        eventTarget:self
                                        touchUpFunc:@selector(toolBarBotton_touchUpInside:)
                                      touchDownFunc:nil];
        _atBtn.tag=TAG_TOOLBAR_AT;
		
		//话题
        _topicBtn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                 frame:CGRectMake(165,0,25,25)
                                               imgName:@"topicBtn.png"
                                           eventTarget:self
                                           touchUpFunc:@selector(toolBarBotton_touchUpInside:)
                                         touchDownFunc:nil];
        _topicBtn.tag=TAG_TOOLBAR_TOPIC;
		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view addSubview:self.publishTxtView];
	[self.publishTxtView becomeFirstResponder];
	[self.view addSubview:self.tipbarView];
	[self.tipbarView addSubview:self.strLengthLabel];
	[self.tipbarView addSubview:self.delBtn];
	[self.view addSubview:self.toolbarView];
    [self.toolbarView addSubview:self.photoBtn];
	[self.toolbarView addSubview:self.cameraBtn];
	[self.toolbarView addSubview:self.lbsPositionBtn];
	[self.toolbarView addSubview:self.atBtn];
	[self.toolbarView addSubview:self.topicBtn];
	
    [self setLeftBarButtonForNavigationBar];
    [self setRightBarButtonForNavigationBar];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)toolBarBotton_touchUpInside:(id)sender{
	UIButton *clickedBtn=(UIButton*)sender;
	switch(clickedBtn.tag){
        case TAG_TOOLBAR_PHOTO:
        {
            if ([self.delegate respondsToSelector:@selector(photoBtn_handle:)]) {
                [self.delegate photoBtn_handle:sender];
            }
        }
            break;
            
		case TAG_TOOLBAR_CAMERA:
		{
			if([self.delegate respondsToSelector:@selector(cameraBtn_handle:)]){
				[self.delegate cameraBtn_handle:sender];
			}
            
		}
			break;
			
		case TAG_TOOLBAR_LBSPOSITION:
		{
			if([self.delegate respondsToSelector:@selector(lbsPositionBtn_handle:)]){
				[self.delegate lbsPositionBtn_handle:sender];
			}
		}
			break;
			
		case TAG_TOOLBAR_AT:
		{
			if([self.delegate respondsToSelector:@selector(atBtn_handle:)]){
				[self.delegate atBtn_handle:sender];
			}
            
		}
			break;
			
		case TAG_TOOLBAR_TOPIC:
		{
			if([self.delegate respondsToSelector:@selector(topicBtn_handle:)]){
				[self.delegate topicBtn_handle:sender];
			}
		}
			break;
	}
}


#pragma mark - UITextViewDelegate -
/*
 *显示输入剩余可输入字符个数
 */
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
#pragma mark Click Event Delegate
-(void)doClickAtTarget:(ClickableLabel *)label{
    if ([self.publishTxtView.text length]==0) {
        return;
    }
    
    currentActionType=ACTION_TYPE_PUBLISHINGCONTENT;
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"清空所有內容" otherButtonTitles:nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];
}

#pragma mark -
#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            switch (self.currentActionType) {
                case ACTION_TYPE_PUBLISHINGCONTENT:    //点击清除文字
                    [self clearInputFromTextView];
                    break;
                    
                case ACTION_TYPE_PHOTO:                //点击缩略图按钮,同时查看原图
                {
                    NSMutableArray *photos = [[NSMutableArray alloc] init];
                    MWPhoto *photo;
                    
                    NSString *imagePath=nil;
                    switch (self.currentPlatform) {
                        case SinaWeibo:
                            imagePath=PUBLISH_IMAGEPATH_SINAWEIBO;
                            break;
                            
                        case TencentWeibo:
                            imagePath=PUBLISH_IMAGEPATH_TENCENTWEIBO;
                            break;
                            
                        case RenRen:
                            imagePath=PUBLISH_IMAGEPATH_RENREN;
                            break;
                            
                        default:
                            break;
                    }
                    
                    photo = [MWPhoto photoWithFilePath:imagePath];
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
            switch (self.currentActionType) {
                case ACTION_TYPE_PUBLISHINGCONTENT:
                    break;
                    
                case ACTION_TYPE_PHOTO:                             //取消图片选择
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

#pragma mark - about navigationItem Button -
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
    
    if ([AppConfig(@"isAudioOpen") boolValue]) {
        [GlobalInstance playTipAudio:[[NSBundle mainBundle] URLForResource:@"drip" withExtension:@"WAV"]];
    }
	
    [self dismissModalViewControllerAnimated:YES];
}

-(void)closeButton_touchDown{
	UIButton *btn=(UIButton*)self.navigationItem.leftBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"closeBtn_highlight.png"] forState:UIControlStateNormal];
}


/*
 *为导航栏设置右侧的自定义按钮
 */
-(void)setRightBarButtonForNavigationBar{
    UIButton *btn=[UIButton initButtonInstanceWithType:UIButtonTypeCustom
                                                 frame:CGRectMake(285,0,50,50)
                                               imgName:@"publishBtn.png"
                                           eventTarget:self
                                           touchUpFunc:@selector(publish_touchUpInside:)
                                         touchDownFunc:@selector(publish_touchDown:)];
    
	UIBarButtonItem *menuBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
	self.navigationItem.rightBarButtonItem=menuBtn;
	[menuBtn release];
}

-(void)publish_touchUpInside:(id)sender{
    UIButton *btn=(UIButton*)self.navigationItem.rightBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"publishBtn.png"] forState:UIControlStateNormal];
    
    //播放提示音
    if ([AppConfig(@"isAudioOpen") boolValue]) {
        [GlobalInstance playTipAudio:[[NSBundle mainBundle] URLForResource:@"drip" withExtension:@"WAV"]];
    }
    
    if (![self.delegate respondsToSelector:@selector(publishBtn_handle:)]) {
        return;
    }
    
    if ((!self.publishTxtView)||[self.publishTxtView.text isEqualToString:@""]) {
        [GlobalInstance showMessageBoxWithMessage:@"发表内容不能为空!"];
        return;
    }
    
    [self.delegate publishBtn_handle:sender];
}


-(void)publish_touchDown:(id)sender{
	UIButton *btn=(UIButton*)self.navigationItem.rightBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"publishBtn_highlight.png"] forState:UIControlStateNormal];
}

#pragma mark - other methods -
/*
 *清空輸入內容
 */
-(void)clearInputFromTextView{
    self.publishTxtView.text=@"";
    self.strLengthLabel.text=[NSString stringWithFormat:@"%d",STRLENGTH];
}

#pragma mark - about photo -
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

#pragma mark - PhotoPickerControllerDelegate -
- (void)photoPickerController:(PhotoPickerController *)controller
    didFinishPickingWithImage:(UIImage *)image
                 isFromCamera:(BOOL)isFromCamera
{
    //如果有，先清空文件
    [self clearTmpImages];
    
    //保存
    [self saveTmpImage:image];
    
    //顯示縮略圖
    [self generateSmallImgForPhoto:image];
}

-(void)clearTmpImages{
    switch (self.currentPlatform) {
        case SinaWeibo:
            if (fileExistsAtPath(PUBLISH_IMAGEPATH_SINAWEIBO)) {
                removerAtItem(PUBLISH_IMAGEPATH_SINAWEIBO);
            }
            break;
            
        case TencentWeibo:
            if (fileExistsAtPath(PUBLISH_IMAGEPATH_TENCENTWEIBO)) {
                removerAtItem(PUBLISH_IMAGEPATH_TENCENTWEIBO);
            }
            break;
            
        case RenRen:
            if (fileExistsAtPath(PUBLISH_IMAGEPATH_RENREN)) {
                removerAtItem(PUBLISH_IMAGEPATH_RENREN);
            }
            break;
            
        default:
            break;
    }
}

- (void)saveTmpImage:(UIImage*)image{
    switch (self.currentPlatform) {
        case SinaWeibo:
        {
            NSData *imgData=UIImageJPEGRepresentation(image,0.5);
            [imgData writeToFile:PUBLISH_IMAGEPATH_SINAWEIBO
                      atomically:YES];
        }
            break;
            
        case TencentWeibo:
            [UIImageJPEGRepresentation(image,0.5) writeToFile:PUBLISH_IMAGEPATH_TENCENTWEIBO
                                                   atomically:YES];
            break;
            
        case RenRen:
            [UIImageJPEGRepresentation(image,0.5) writeToFile:PUBLISH_IMAGEPATH_RENREN
                                                   atomically:YES];
            break;
            
        default:
            break;
    }
}

-(void)imgClick:(id)sender{
    self.currentActionType=ACTION_TYPE_PHOTO;
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@""
                                                          delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"查看原图" otherButtonTitles:@"取消图片选择",nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];
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
