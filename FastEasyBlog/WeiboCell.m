//
//  WeiboCell.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 9/12/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "WeiboCell.h"

Class object_getClass(id object);

@implementation WeiboCell

@synthesize txtWeibo,
			txtSourceWeibo,
			weiboImg,
			sourceImg,
			showWeiboImgDelegate,
			weiboImgView,
			sourceImgView,
			imgUrl,
			hasWeiboImg,
			hasSourceWeiboImg;

-(void)dealloc{
    [txtWeibo release],txtWeibo=nil;
    [txtWeiboLabel release],txtWeiboLabel=nil;
    [txtSourceWeibo release],txtSourceWeibo=nil;
    [txtSourceWeiboLabel release],txtSourceWeiboLabel=nil;
    [sourceView release],sourceView=nil;
    [weiboImg release],weiboImg=nil;
    [sourceImg release],sourceImg=nil;
	[imgUrl release],imgUrl=nil;
    [weiboImgView release],weiboImgView=nil;
    [sourceImgView release],sourceImgView=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *_contentView=(UIView*)[self viewWithTag:7000];
        
        txtWeiboLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        [txtWeiboLabel setMinimumFontSize:15];
		[txtWeiboLabel setNumberOfLines:0];
		[txtWeiboLabel setLineBreakMode:UILineBreakModeWordWrap];
        [txtWeiboLabel setFont:WEIBOTEXTFONT];
        [_contentView addSubview:txtWeiboLabel];
        
        //微博图片
        UIImageView *tmpWeiboImgView=[[UIImageView alloc]initWithFrame:CGRectZero];
        tmpWeiboImgView.userInteractionEnabled=YES;
        [tmpWeiboImgView addGestureRecognizer:[[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weiboImgClick:)]autorelease]];
        self.weiboImgView=tmpWeiboImgView;
        [tmpWeiboImgView release];
        [_contentView addSubview:self.weiboImgView];
        
        //原始微博
        sourceView=[[UIView alloc]initWithFrame:CGRectZero];
        sourceView.backgroundColor=RGBCOLOR(235,235,235);
        sourceView.tag=70000;
        [_contentView addSubview:sourceView];
        
        txtSourceWeiboLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        txtSourceWeiboLabel.tag=700001;
        txtSourceWeiboLabel.backgroundColor=RGBCOLOR(235,235,235);
		[txtSourceWeiboLabel setMinimumFontSize:14];
		[txtSourceWeiboLabel setNumberOfLines:0];
		[txtSourceWeiboLabel setLineBreakMode:UILineBreakModeWordWrap];
        [txtSourceWeiboLabel setFont:SOURCEWEIBOTEXTFONT];
        [sourceView addSubview:txtSourceWeiboLabel];
        
        //原始图片        
        UIImageView *tmpSourceWeiboImgView=[[UIImageView alloc]initWithFrame:CGRectZero];
        tmpSourceWeiboImgView.userInteractionEnabled=YES;
        [tmpSourceWeiboImgView addGestureRecognizer:[[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sourceWeiboImgClick:)]autorelease]];
        self.sourceImgView=tmpSourceWeiboImgView;
        [sourceView addSubview:self.sourceImgView];
        [tmpSourceWeiboImgView release];
        
    }
    
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
 
 #pragma mark -override setter-
/*
 *重置视图的边框/区域
 */
- (void)resizeViewFrames{
	//內容高度
    CGFloat txtHeight=[GlobalInstance getHeightWithFontText:self.txtWeibo font:WEIBOTEXTFONT constraint:DEFAULT_CONSTRAINT_SIZE minHeight:MIN_CONTENT_HEIGHT];
    CGFloat txtSourceHeight=0;					//原文內容高度
    if (self.txtSourceWeibo&&[self.txtSourceWeibo isNotEqualToString:@""]) {
        txtSourceHeight=[GlobalInstance getHeightWithFontText:self.txtSourceWeibo font:SOURCEWEIBOTEXTFONT constraint:DEFAULT_CONSTRAINT_SIZE minHeight:MIN_CONTENT_HEIGHT];
    }
        
    if (txtSourceHeight!=0) {					//有原文(当前为转发微博)
        
        if (self.hasSourceWeiboImg) {			//有图片
            [contentView setFrame:CGRectMake(50+CELL_CONTENT_MARGIN, 50+CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH-(CELL_CONTENT_MARGIN*2), txtHeight+txtSourceHeight+WEIBO_IMAGE_HEIGHT+CELL_CONTENT_SOURCE_MARGIN*2)];
            //设置内容的frame
            [txtWeiboLabel setFrame:CGRectMake(0, 0, contentView.frame.size.width, txtHeight)];
            [sourceView setFrame:CGRectMake(0, txtHeight+CELL_CONTENT_SOURCE_MARGIN, CELL_CONTENT_WIDTH-(CELL_CONTENT_MARGIN*2), txtSourceHeight+CELL_CONTENT_SOURCE_MARGIN*2+WEIBO_IMAGE_HEIGHT)];
            //设置原文的frame
            [txtSourceWeiboLabel setFrame:CGRectMake(CELL_CONTENT_SOURCE_MARGIN, CELL_CONTENT_SOURCE_MARGIN, sourceView.frame.size.width-CELL_CONTENT_SOURCE_MARGIN*2, txtSourceHeight)];
            //设置图片区域的frame
            self.sourceImgView.frame=CGRectMake(0, txtSourceHeight+CELL_CONTENT_SOURCE_MARGIN,WEIBO_IMAGE_HEIGHT, WEIBO_IMAGE_HEIGHT);
        }else {									//无图片
            [contentView setFrame:CGRectMake(50+CELL_CONTENT_MARGIN, 50+CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH-(CELL_CONTENT_MARGIN*2), txtHeight+txtSourceHeight+CELL_CONTENT_SOURCE_MARGIN*2)];
            //设置内容的frame
            [txtWeiboLabel setFrame:CGRectMake(0, 0, contentView.frame.size.width, txtHeight)];
            [sourceView setFrame:CGRectMake(0, txtHeight+CELL_CONTENT_SOURCE_MARGIN, contentView.frame.size.width, txtSourceHeight+CELL_CONTENT_SOURCE_MARGIN*2)];
            //设置原文的frame
            [txtSourceWeiboLabel setFrame:CGRectMake(CELL_CONTENT_SOURCE_MARGIN, CELL_CONTENT_SOURCE_MARGIN, sourceView.frame.size.width-CELL_CONTENT_SOURCE_MARGIN*2, txtSourceHeight)];
        }
        
    }else {										//原创微博，只需判斷原圍脖圖片
        if (self.hasWeiboImg) {                          
            [contentView setFrame:CGRectMake(50+CELL_CONTENT_MARGIN, 50+CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH-(CELL_CONTENT_MARGIN*2), txtHeight+WEIBO_IMAGE_HEIGHT+IMAGE_MARGIN)];
            //设置内容的frame
            [txtWeiboLabel setFrame:CGRectMake(0, 0, contentView.frame.size.width, txtHeight)];
            self.weiboImgView.frame=CGRectMake(0, txtHeight+IMAGE_MARGIN, WEIBO_IMAGE_HEIGHT, WEIBO_IMAGE_HEIGHT);
        }else{
            [contentView setFrame:CGRectMake(50+CELL_CONTENT_MARGIN, 50+CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH-(CELL_CONTENT_MARGIN*2), txtHeight)];
            //设置内容的frame
            [txtWeiboLabel setFrame:CGRectMake(0, 0, contentView.frame.size.width, txtHeight)];
        }
    }
    
    //设置底部区域
    [footerView setFrame:CGRectMake(0, CELL_CONTENT_MARGIN+50.0f+contentView.frame.size.height+5.0f, self.frame.size.width, TABLE_FOOTER_HEIGHT)];
}

#pragma mark -override setter-
-(void)setTxtWeibo:(NSString *)_txtWeibo{
    if (!txtWeibo||[txtWeibo isNotEqualToString:_txtWeibo]) {
        [txtWeibo release];
        txtWeibo=[_txtWeibo retain];
    }
    txtWeiboLabel.text=txtWeibo;
}

-(void)setTxtSourceWeibo:(NSString *)_txtSourceWeibo{
    if (!txtSourceWeibo||[txtSourceWeibo isNotEqualToString:_txtSourceWeibo]) {
        [txtSourceWeibo release];
        txtSourceWeibo=[_txtSourceWeibo retain];
    }
    txtSourceWeiboLabel.text=txtSourceWeibo;
}

-(void)setWeiboImg:(UIImage *)_weiboImg{
    if (_weiboImg!=weiboImg) {
        [weiboImg release];
        weiboImg=[_weiboImg retain];
    }
    self.weiboImgView.image=weiboImg;
}

-(void)setSourceImg:(UIImage*)_sourceImg{
    if (_sourceImg!=sourceImg) {
        [sourceImg release];
        sourceImg=[_sourceImg retain];
    }
    self.sourceImgView.image=sourceImg;
}

#pragma mark -override setter-
- (void)setShowWeiboImgDelegate:(id<WeiboImageDelegate>)_showWeiboImgDelegate{
    if (showWeiboImgDelegate!=_showWeiboImgDelegate) {
        showWeiboImgDelegate=_showWeiboImgDelegate;
        _originalShowImgClass=object_getClass(_showWeiboImgDelegate);
    }
}

/*
 *显示大图的点击事件(微博)
 */
- (void)weiboImgClick:(id)sender{
    Class currentDelegate=object_getClass(self.showWeiboImgDelegate);
    if (currentDelegate==_originalShowImgClass) {
        if ([self.showWeiboImgDelegate respondsToSelector:@selector(showWeiboImage:)]) {
            UITapGestureRecognizer *recognizer=(UITapGestureRecognizer*)sender;
            [self.showWeiboImgDelegate showWeiboImage:recognizer.view];
        }
    }
}

/*
 *显示大图的点击事件(原微博)
 */
- (void)sourceWeiboImgClick:(id)sender{
    Class currentDelegate=object_getClass(self.showWeiboImgDelegate);
    if (currentDelegate==_originalShowImgClass) {
        if ([self.showWeiboImgDelegate respondsToSelector:@selector(showSourceWeiboImage:)]) {
            UITapGestureRecognizer *recognizer=(UITapGestureRecognizer*)sender;
            [self.showWeiboImgDelegate showSourceWeiboImage:recognizer.view];
        }
    }
}

@end
