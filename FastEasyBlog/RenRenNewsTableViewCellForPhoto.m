//
//  RenRenNewsTableViewCellForPhoto.m
//  FastEasyBlog
//
//  Created by svp on 08.07.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "RenRenNewsTableViewCellForPhoto.h"
#import "Global.h"

Class object_getClass(id object);

@interface RenRenNewsTableViewCellForPhoto () 

//@property (nonatomic,retain) TTStyledTextLabel *descLbl;
@property (nonatomic,retain) UILabel *albumNameLbl;
@property (nonatomic,retain) UILabel *comeFromLbl;

@end


@implementation RenRenNewsTableViewCellForPhoto

@synthesize desc,
			photoImg,
            albumNameLbl,
            comeFromLbl,
			photoImgView,
            comeFrom,
            albumName,
            imgUrl,
            showImgDelegate;

-(void)dealloc{
	[desc release],desc=nil;
    [albumNameLbl release],albumNameLbl=nil;
    [comeFromLbl release],comeFromLbl=nil;
	[photoImg release],photoImg=nil;
	[photoImgView release],photoImgView=nil;
    [imgUrl release],imgUrl=nil;
	[super dealloc];
}

-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier{
	self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle=UITableViewCellSelectionStyleNone;
		
		//图片描述区域
//		TTStyledTextLabel *tmpDescLbl=[[TTStyledTextLabel alloc]initWithFrame:CGRectMake(50+CELL_CONTENT_MARGIN, 50+CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH-(CELL_CONTENT_MARGIN*2), 0)];
//		[tmpDescLbl setFont:RENRENPHOTODESCFONT];
//		self.descLbl=tmpDescLbl;
//		self.descLbl.tag=8889;
//		[self addSubview:self.descLbl];
//		[tmpDescLbl release];
		
		//图片区域
		UIImageView *tmpPhotoView=[[UIImageView alloc]initWithFrame:CGRectZero];
        tmpPhotoView.userInteractionEnabled=YES;
        [tmpPhotoView addGestureRecognizer:[[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)]autorelease]];
		self.photoImgView=tmpPhotoView;
		[self addSubview:self.photoImgView];
        [tmpPhotoView release];
        
        //相册名称
        UILabel *tmpAlbumNameLbl=[[UILabel alloc]initWithFrame:CGRectZero];
        [tmpAlbumNameLbl setNumberOfLines:0];
        [tmpAlbumNameLbl setTextColor:RGBCOLOR(205,205,205)];
        [tmpAlbumNameLbl setLineBreakMode:UILineBreakModeWordWrap];
        [tmpAlbumNameLbl setFont:RENRENALBUMNAMEFONT];
        self.albumNameLbl=tmpAlbumNameLbl;
        self.albumNameLbl.tag=8890;
        [self addSubview:self.albumNameLbl];
        [tmpAlbumNameLbl release];
        
        //来自
        UILabel *tmpComeFromLbl=[[UILabel alloc]initWithFrame:CGRectZero];
        [tmpComeFromLbl setNumberOfLines:0];
        [tmpComeFromLbl setLineBreakMode:UILineBreakModeWordWrap];
        [tmpComeFromLbl setFont:RENRENPHOTOCOMEFROMFONT];
        self.comeFromLbl=tmpComeFromLbl;
        self.comeFromLbl.tag=8891;
        [self.footerView addSubview:self.comeFromLbl];
        [tmpComeFromLbl release];
	}
	
	return self;
}

//#pragma mark - override setters -
//-(void)setDesc:(NSString*)_desc{
//	if(!desc||[desc isNotEqualToString:_desc]){
//		[desc release];
//		desc=[_desc retain];
//	}
//    if (!desc) {
//        desc=@"";
//    }
//    self.descLbl.text=[TTStyledText textFromXHTML:desc lineBreaks:YES URLs:YES];
//    [self.descLbl sizeToFit];
//}

-(void)setPhotoImg:(UIImage *)_photoImg{
    if (photoImg!=_photoImg) {
        [photoImg release];
        photoImg=[_photoImg retain];
    }
    self.photoImgView.image=photoImg;
}

- (void)setAlbumName:(NSString *)_albumName{
    if (!albumName||[albumName isNotEqualToString:_albumName]) {
        [albumName release];
        albumName=[_albumName retain];
    }
    if (albumName) {
        self.albumNameLbl.text=[NSString stringWithFormat:@"[%@]",albumName];
    }
}

-(void)setComeFrom:(NSString *)_comeFrom{
    if (!comeFrom||[comeFrom isNotEqualToString:_comeFrom]) {
        [comeFrom release];
        comeFrom=[_comeFrom retain];
    }
    self.comeFromLbl.text=comeFrom;
}

#pragma mark - override super class's public method -
-(void)resizeViewFrames{
    [super resizeViewFrames];

//    //照片简介
//    self.descLbl.frame=CGRectMake(50+CELL_CONTENT_MARGIN, 50+CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH-(CELL_CONTENT_MARGIN*2), self.descLbl.frame.size.height);
//    
//    //照片
//    self.photoImgView.frame=CGRectMake(50+CELL_CONTENT_MARGIN, 50+CELL_CONTENT_MARGIN+self.descLbl.frame.size.height, SMALL_PHOTO_WIDTH, SMALL_PHOTO_HEIGHT);
//    
//    //相册名称
//    CGFloat albumNameHeight=[GlobalInstance getHeightWithFontText:self.albumName font:RENRENALBUMNAMEFONT constraint:DEFAULT_CONSTRAINT_SIZE minHeight:20];
//    self.albumNameLbl.frame=CGRectMake(50+CELL_CONTENT_MARGIN, 50+CELL_CONTENT_MARGIN+self.descLbl.frame.size.height+SMALL_PHOTO_HEIGHT, CELL_CONTENT_WIDTH, albumNameHeight);
//    
//    //来自
//    self.comeFromLbl.frame=CGRectMake(50+CELL_CONTENT_MARGIN, 0, 200, 20);
//    
//    self.footerView.frame=CGRectMake(0, CELL_CONTENT_MARGIN+50.0f+self.descLbl.frame.size.height+SMALL_PHOTO_HEIGHT+albumNameHeight, self.frame.size.width, TABLE_FOOTER_HEIGHT);
}

#pragma mark -override setter-
- (void)setShowImgDelegate:(id<WeiboImageDelegate>)_showImgDelegate{
    if (showImgDelegate!=_showImgDelegate) {
        showImgDelegate=_showImgDelegate;
        _originalShowImgClass=object_getClass(_showImgDelegate);
    }
}

- (void)imgClick:(id)sender{
    Class currentDelegate=object_getClass(self.showImgDelegate);
    if (currentDelegate==_originalShowImgClass) {
        if ([self.showImgDelegate respondsToSelector:@selector(showWeiboImage:)]) {
            UITapGestureRecognizer *recognizer=(UITapGestureRecognizer*)sender;
            [self.showImgDelegate showWeiboImage:recognizer.view];
        }
    }
}

@end

