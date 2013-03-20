//
//  RenRenPublishController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 10/6/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "RenRenPublishController.h"
#import "RenRenManager.h"
#import "PhotoPickerController.h"
#import "MapKitDragAndDropViewController.h"
#import "FollowedListController.h"
#import "RenRenPublishOperation.h"

@interface RenRenPublishController ()

@property (nonatomic,retain) PhotoPickerController *photoPicker;

@end

@implementation RenRenPublishController

- (void)dealloc{
    [_photoPicker release],_photoPicker=nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil
                         platform:RenRen];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    super.delegate=self;
    [super viewDidLoad];
    self.navigationItem.title=@"发表人人状态";
    self.topicBtn.hidden=YES;                   //hidden topic button
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

#pragma mark - PublishBaseControllerDelegate -
- (void)photoBtn_handle:(id)sender{
    if (!_photoPicker) {
        _photoPicker = [[PhotoPickerController alloc] initWithDelegate:self];
    }
    [self.photoPicker showWithPhotoLibrary];
}

- (void)cameraBtn_handle:(id)sender{
	if (!_photoPicker) {
        _photoPicker = [[PhotoPickerController alloc] initWithDelegate:self];
    }
    [self.photoPicker showWithCamera];
}

- (void)lbsPositionBtn_handle:(id)sender{
	[self.navigationController pushViewController:[[[MapKitDragAndDropViewController alloc]initWithNibName:@"MapKitDragAndDropViewController" bundle:nil]autorelease] animated:YES];
}

- (void)atBtn_handle:(id)sender{
	FollowedListController *followedListCtrller=[[FollowedListController alloc]initWithNibName:@"FollowedListView" bundle:nil platform:self.currentPlatform];
    followedListCtrller.delegate=self;
    
    UINavigationController *followedListNavCtrller=[[UINavigationController alloc]initWithRootViewController:followedListCtrller];
    [followedListCtrller release];
    
    [self presentModalViewController:followedListNavCtrller animated:YES];
    [followedListNavCtrller release];
}


- (void)publishBtn_handle:(id)sender{
    NSString *txt=self.publishTxtView.text;
    PublishOperation *publishOperation=[[[RenRenPublishOperation alloc]initWithOperateParams:txt]autorelease];
    [((FastEasyBlogAppDelegate*)appDelegateObj).operationQueue addOperation:publishOperation];
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - FollowedListDelegate -
- (void)didSelectedFollowed:(Followed *)aFollowed{
    [self.followedList addObject:aFollowed];
    self.publishTxtView.text=[NSString stringWithFormat:@"%@ @%@(%@) ",self.publishTxtView.text,aFollowed.nick,aFollowed.userId];
}

@end
