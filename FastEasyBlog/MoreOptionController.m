//
//  MoreOptionController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 11/3/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "MoreOptionController.h"

@interface MoreOptionController ()

@property (nonatomic,retain) UIView *nightModeContainer;
@property (nonatomic,retain) UIView *lightSettingContainer;
@property (nonatomic,retain) UIView *fontSizeSettingContainer;

@end

@implementation MoreOptionController


@synthesize isNightMode;
@synthesize lightValue;
@synthesize fontSizeSegmentedSelectedIndex;

- (void)dealloc{
    [_nightModeContainer release],_nightModeContainer=nil;
    [_lightSettingContainer release],_lightSettingContainer=nil;
    [_fontSizeSettingContainer release],_fontSizeSettingContainer=nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    UIView *tmpView=[[UIView alloc]initWithFrame:CGRectMake(0, 225, WINDOWWIDTH, 150)];
    tmpView.alpha=1.0;
    tmpView.backgroundColor=[UIColor whiteColor];
    self.view=tmpView;
    [tmpView release];
    
    _nightModeContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOWWIDTH, 50)];
    [self.view addSubview:self.nightModeContainer];
    
    _lightSettingContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 50, WINDOWWIDTH, 50)];
    [self.view addSubview:self.lightSettingContainer];
    
    _fontSizeSettingContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 100, WINDOWWIDTH, 50)];
    [self.view addSubview:self.fontSizeSettingContainer];
    
    [self initNightModeSubviews];
    [self initLightSettingSubviews];
    [self initFontSizeSettingSubviews];
}

- (void)initNightModeSubviews{
    UILabel *nightModeLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 40)];
    nightModeLbl.text=@"夜间模式";
    nightModeLbl.font=[UIFont systemFontOfSize:16.0f];
    [self.nightModeContainer addSubview:nightModeLbl];
    [nightModeLbl release];
    
    UISwitch *nightModeSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(225, 15, 50, 30)];
    nightModeSwitch.multipleTouchEnabled=NO;
    [nightModeSwitch setOn:self.isNightMode animated:YES];
    [nightModeSwitch addTarget:self action:@selector(UISwitch_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.nightModeContainer addSubview:nightModeSwitch];
    [nightModeSwitch release];
}

- (void)initLightSettingSubviews{
    UILabel *lightSettingLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 40)];
    lightSettingLbl.text=@"屏幕亮度";
    lightSettingLbl.font=[UIFont systemFontOfSize:16.0f];
    [self.lightSettingContainer addSubview:lightSettingLbl];
    [lightSettingLbl release];
    
    UISlider *lightSettingValueSlider=[[UISlider alloc]initWithFrame:CGRectMake(100, 15, 200, 30)];
    lightSettingLbl.multipleTouchEnabled=NO;
    lightSettingValueSlider.minimumValue=0.0f;
    lightSettingValueSlider.maximumValue=1.0f;
    lightSettingValueSlider.value=self.lightValue;
    [lightSettingValueSlider addTarget:self action:@selector(UISlider_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.lightSettingContainer addSubview:lightSettingValueSlider];
    [lightSettingValueSlider release];
}

- (void)initFontSizeSettingSubviews{
    UILabel *fontSizeLbl=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 40)];
    fontSizeLbl.text=@"字体大小";
    fontSizeLbl.font=[UIFont systemFontOfSize:16.0f];
    [self.fontSizeSettingContainer addSubview:fontSizeLbl];
    [fontSizeLbl release];
    
    UISegmentedControl *fontSegment=[[UISegmentedControl alloc]initWithFrame:CGRectMake(100, 15, 200, 30)];
    
    [fontSegment insertSegmentWithTitle:@"小" atIndex:0 animated:YES];
    [fontSegment insertSegmentWithTitle:@"中" atIndex:1 animated:YES];
    [fontSegment insertSegmentWithTitle:@"大" atIndex:2 animated:YES];
    [fontSegment setMultipleTouchEnabled:NO];
    fontSegment.segmentedControlStyle=UISegmentedControlStyleBordered;
    fontSegment.selectedSegmentIndex=self.fontSizeSegmentedSelectedIndex;
    [fontSegment addTarget:self action:@selector(UISegmentControl_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.fontSizeSettingContainer addSubview:fontSegment];
    [fontSegment release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

#pragma mark - some controls delegate action -
- (void)UISwitch_ValueChanged:(id)sender{
    UISwitch *_switch=(UISwitch*)sender;
    optionalType currentOptionalType=nightMode;
    NSDictionary *paramsDic=[[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:currentOptionalType],@"optionalType",[NSNumber numberWithBool:_switch.on],@"value", nil]autorelease];
    [[NSNotificationCenter defaultCenter]postNotificationName:OPTIONAL_NOTIFICATION object:paramsDic];
}

- (void)UISlider_ValueChanged:(id)sender{
    UISlider *_slider=(UISlider*)sender;
    optionalType currentOptionalType=lightSetting;
    NSDictionary *paramsDic=[[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:currentOptionalType],@"optionalType",[NSNumber numberWithFloat:_slider.value],@"value", nil]autorelease];
    [[NSNotificationCenter defaultCenter]postNotificationName:OPTIONAL_NOTIFICATION object:paramsDic];
}

- (void)UISegmentControl_ValueChanged:(id)sender{
    UISegmentedControl *_segmentedControl=(UISegmentedControl*)sender;
    optionalType currentOptionalType=fontSizeSetting;
    NSDictionary *paramsDic=[[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:currentOptionalType],@"optionalType",[NSNumber numberWithInt:_segmentedControl.selectedSegmentIndex],@"value", nil]autorelease];
    [[NSNotificationCenter defaultCenter]postNotificationName:OPTIONAL_NOTIFICATION object:paramsDic];
}

@end
