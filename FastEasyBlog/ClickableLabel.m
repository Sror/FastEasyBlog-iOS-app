//
//  ClickableLabel.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12-7-23.
//  Copyright (c) 2012年 yanghua_kobe. All rights reserved.
//

#import "ClickableLabel.h"
#import "Global.h"

@implementation ClickableLabel

@synthesize lblDelegate;

-(void)dealloc{
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
    }
    
    return self;
}

#pragma -
#pragma touch events
/*
 *
 */
-(void)touchesBegan:(NSSet *)touches
          withEvent:(UIEvent *)event{

}

-(void)touchesEnded:(NSSet *)touches
          withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    if (point.x>=0&&point.y>=0&&point.x<=self.frame.size.width&&point.y<=self.frame.size.height) {
        [lblDelegate doClickAtTarget:self];
    }
}


@end
