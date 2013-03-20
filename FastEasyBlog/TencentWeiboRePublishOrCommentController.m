//
//  TencentWeiboRePublishOrCommentController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-8-28.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import "TencentWeiboRePublishOrCommentController.h"
#import "UIPlaceHolderTextView.h"
#import "Global.h"
#import "RenRenManager.h"
#import "MTStatusBarOverlay.h"                  		//自定义状态栏
#import "OpenApi.h"
#import "TencentWeiboManager.h"


@interface TencentWeiboRePublishOrCommentController()

//实例化工具栏提示组件
-(void)initMTStatusBarOverlay;

//實例化文本輸入框
-(void)initPlaceholderTextView;

//實例化字符長度標簽
-(void)initStrLengthLabel;

//为导航栏设置右侧的自定义按钮
-(void)setRightBarButtonForNavigationBar;

//为导航栏设置左侧的自定义返回按钮
-(void)setLeftBarButtonForNavigationBar;

//清空輸入內容
-(void)clearInputFromTextView;

@end 

@implementation TencentWeiboRePublishOrCommentController


- (void)dealloc{
    [_publishTxtView release],_publishTxtView=nil;
    [_tipbarView release],_tipbarView=nil;
    [_toolbarView release],_toolbarView=nil;
    [_strLengthLabel release],_strLengthLabel=nil;
    [_theSubjectId release],_theSubjectId=nil;
	
	[_showTitle release],_showTitle=nil;
    [_sourceContent release],_sourceContent=nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil 
				bundle:(NSBundle *)nibBundleOrNil 
				operateType:(operateType)__operateType 
				comeInParam:(NSMutableDictionary*)params
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _operateType=__operateType;
		self.showTitle=[params objectForKey:@"showTitle"];
		self.theSubjectId=[params objectForKey:@"theSubjectId"];
		self.sourceContent=[params objectForKey:@"sourceContent"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.title=self.showTitle;
    self.navigationController.navigationBar.tintColor=defaultNavigationBGColor;
	[self initPlaceholderTextView];
    [self initStrLengthLabel];
	[self setRightBarButtonForNavigationBar];           //设置右侧自定义的导航栏按钮
	[self setLeftBarButtonForNavigationBar]; 
    
    if (_operateType==republish) {
        self.publishTxtView.text=self.sourceContent;
		NSRange selectedLoc=NSMakeRange(0, 0);
		self.publishTxtView.selectedRange=selectedLoc;
        [self textViewDidChange:self.publishTxtView];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UITextViewDelegate
//显示输入剩余可输入字符个数
-(void)textViewDidChange:(UITextView *)textView{
	int avaliableStrLength=CONTENTMAXLENGTH-[self.publishTxtView.text length];
	if (avaliableStrLength<=20&&avaliableStrLength>0) {
		self.strLengthLabel.textColor=[UIColor redColor];
	}else if (avaliableStrLength<=0) {
		avaliableStrLength=0;
		self.publishTxtView.text=[self.publishTxtView.text substringToIndex:CONTENTMAXLENGTH];
	}else {
		self.strLengthLabel.textColor=[UIColor blackColor];
	}
	
	self.strLengthLabel.text=[NSString stringWithFormat:@"%d",avaliableStrLength];
    
    if ([self.strLengthLabel.text isEqualToString:[NSString stringWithFormat:@"%d",CONTENTMAXLENGTH]]) {
        delBtn.hidden=YES;
    }else{
        delBtn.hidden=NO;
    }
}

#pragma mark -
#pragma mark Private method
/*
 *实例化工具栏提示组件
 */
-(void)initMTStatusBarOverlay{
    overlay = [MTStatusBarOverlay sharedInstance];
    overlay.animation = MTStatusBarOverlayAnimationFallDown;  // MTStatusBarOverlayAnimationShrink
    overlay.detailViewMode = MTDetailViewModeHistory;         // enable automatic history-tracking and show in detail-view
}

/*
 *實例化文本輸入框
 */
-(void)initPlaceholderTextView{
    //文本输入框（带占位符）
	UIPlaceHolderTextView *txtView=[[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 130)];
	self.publishTxtView=txtView;
    [txtView release];
	self.publishTxtView.backgroundColor=[UIColor whiteColor];
	self.publishTxtView.placeholder=@"说点什么吧...";
	self.publishTxtView.delegate=self;
	[self.publishTxtView setFont:[UIFont fontWithName:@"Arial" size:DEFAULTFONTSIZE]];
	[self.view addSubview:self.publishTxtView];
	[self.publishTxtView becomeFirstResponder];
}

/*
 *實例化字符長度標簽與刪除按鈕
 */
-(void)initStrLengthLabel{
    CGFloat X_tipbarView=self.publishTxtView.frame.origin.x;
    CGFloat y_tipbarView=self.publishTxtView.frame.origin.y+self.publishTxtView.frame.size
    .height;
    UIView *tmpTipbarView=[[UIView alloc]initWithFrame:CGRectMake(X_tipbarView, y_tipbarView, self.publishTxtView.frame.size.width, 30)];
    self.tipbarView=tmpTipbarView;
    self.tipbarView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.tipbarView];
    [tmpTipbarView release];
    
    //@ 按钮
    UIButton *atBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    atBtn.frame=CGRectMake(15,0,25,25);
    [atBtn setBackgroundImage:[UIImage imageNamed:@"atBtn.png"] forState:UIControlStateNormal];
    [atBtn addTarget:self action:@selector(atBtn_touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.tipbarView addSubview:atBtn];
    
    //设置提示字符数的Label
	CGFloat x_lbl=self.tipbarView.frame.origin.x+self.tipbarView.frame.size.width-60;
	CGFloat y_lbl=0;
    
	ClickableLabel *strLabel=[[ClickableLabel alloc]initWithFrame:CGRectMake(x_lbl, y_lbl, 33, 25)];
	self.strLengthLabel=strLabel;
    [self.strLengthLabel setLblDelegate:self];       //設置其代理為當前controller
    self.strLengthLabel.textColor=RGBACOLOR(105, 105, 105, 1.0);
	self.strLengthLabel.text=[NSString stringWithFormat:@"%d",CONTENTMAXLENGTH];
	self.strLengthLabel.textAlignment=UITextAlignmentLeft;
	[self.tipbarView addSubview:self.strLengthLabel];
	[strLabel release];
    
    //設置刪除按鈕
    delBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame=CGRectMake(x_lbl+self.strLengthLabel.frame.size.width, 5, 16, 16);
    [delBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn.png"] forState:UIControlStateNormal];
    delBtn.hidden=YES;
    [delBtn addTarget:self action:@selector(doClickAtTarget:) forControlEvents:UIControlEventTouchUpInside];
    [self.tipbarView addSubview:delBtn];
}

- (void)atBtn_touchUpInside:(id)sender{
    FollowedListController *followedListCtrller=[[FollowedListController alloc]initWithNibName:@"FollowedListView" bundle:nil platform:TencentWeibo];
    followedListCtrller.delegate=self;
    
    UINavigationController *followedListNavCtrller=[[UINavigationController alloc]initWithRootViewController:followedListCtrller];
    [followedListCtrller release];
    
    [self presentModalViewController:followedListNavCtrller animated:YES];
    [followedListNavCtrller release];
}

/*
 *为导航栏设置右侧的自定义按钮
 */
-(void)setRightBarButtonForNavigationBar{
	UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame=CGRectMake(285,0,50,50);
	[btn setBackgroundImage:[UIImage imageNamed:@"publishBtn.png"] forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(send_touchUpInside) forControlEvents:UIControlEventTouchUpInside];
	[btn addTarget:self action:@selector(send_touchDown) forControlEvents:UIControlEventTouchDown];
	UIBarButtonItem *menuBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
	self.navigationItem.rightBarButtonItem=menuBtn;
	[menuBtn release];
}

/*
 *为导航栏设置左侧的自定义返回按钮
 */
-(void)setLeftBarButtonForNavigationBar{
	UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
	btn.frame=CGRectMake(0, 0, 45, 45);
	[btn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(closeButton_touchUpInside) forControlEvents:UIControlEventTouchUpInside];
	[btn addTarget:self action:@selector(closeButton_touchDown) forControlEvents:UIControlEventTouchDown];		//按下替换为高亮图片
	
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
 *清空輸入內容
 */
-(void)clearInputFromTextView{
    self.publishTxtView.text=@"";
    self.strLengthLabel.text=[NSString stringWithFormat:@"%d",CONTENTMAXLENGTH];
}

#pragma mark -
#pragma mark tencentweibo delegate
-(void)tencentWeiboRequestDidReturnResponse:(TencentWeiboList *)result{
	[self dismissViewControllerAnimated:YES completion:^{
       //刷新父页面的评论列表
        if ([self.delegate respondsToSelector:@selector(rAndCSuccessfully)]) {
            [self.delegate rAndCSuccessfully];
        }
    }];
}

-(void)tencentWeiboRequestFailWithError{
	[GlobalInstance showMessageBoxWithMessage:@"请求数据失败"];
}

#pragma mark -
#pragma mark navigationBar delegate


/*
 *发送按钮
 */
-(void)send_touchUpInside{
    UIButton *btn=(UIButton*)self.navigationItem.rightBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"publishBtn.png"] forState:UIControlStateNormal];
    
    if ([self.publishTxtView.text length]==0) {
		[GlobalInstance showMessageBoxWithMessage:@"请说点什么吧!"];
		return;
	}
    
    OpenApi *myApi=[TencentWeiboManager getOpenApi];
    myApi.delegate=self;
    
    switch (_operateType) {
        case republish:
            [myApi rePublishOrCommentWeiboWithContent:self.publishTxtView.text reId:self.theSubjectId isRePublish:YES jing:@"" wei:@"" syncflag:@"0"];
            break;
            
        case comment:
            [myApi rePublishOrCommentWeiboWithContent:self.publishTxtView.text reId:self.theSubjectId isRePublish:NO jing:@"" wei:@"" syncflag:@"0"];
            break;
            
        case reply:
            //mark:腾讯微博对于“回复评论的操作”，显示的是对于原微博的评论
            [myApi rePublishOrCommentWeiboWithContent:self.publishTxtView.text reId:self.theSubjectId isRePublish:NO jing:@"" wei:@"" syncflag:@"0"];
//            [myApi replyWeiboWithContent:self.publishTxtView.text reId:self.theSubjectId jing:@"" wei:@"" syncflag:@"0"];
            break;
            
        default:
            break;
    }
}

-(void)send_touchDown{
	UIButton *btn=(UIButton*)self.navigationItem.rightBarButtonItem.customView;
	[btn setBackgroundImage:[UIImage imageNamed:@"publishBtn_highlight.png"] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark Click Event Delegate
-(void)doClickAtTarget:(ClickableLabel *)label{
    if ([self.publishTxtView.text length]==0) {
        return;
    }
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"清空所有內容" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

#pragma mark -
#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:[self clearInputFromTextView];               //点击清除文字
            break;
                
        case 1:                                             //cancel
            break;
            
        default:
            break;
    }
}

#pragma mark - FollowedListDelegate -
- (void)didSelectedFollowed:(Followed *)aFollowed{
    NSString *sourceTxt=self.publishTxtView.text;
    int mouseLoc=self.publishTxtView.selectedRange.location;
    NSString *prevPart=[NSString stringWithFormat:@"%@ @%@ ",[sourceTxt substringToIndex:mouseLoc],aFollowed.userId];
    self.publishTxtView.text=[NSString stringWithFormat:@"%@%@",prevPart,[sourceTxt substringFromIndex:mouseLoc]];
    //重置光标
    NSRange selectedLoc=NSMakeRange(prevPart.length, 0);
    self.publishTxtView.selectedRange=selectedLoc;
}

@end
