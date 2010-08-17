//
//  ZIAVControlView.m
//  SchoolOfX
//
//  Created by Brandon Emrich on 6/22/10.
//  Copyright 2010 Zueos, Inc. All rights reserved.
//

#import "ZIAVControlView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ZIAVControlView


//*******************************************************************
#pragma mark -
#pragma mark Making & Setting up the Class
//*******************************************************************

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
//		UIColor *bgFirst = [UIColor blackColor];
//		UIColor *bgSecond = [UIColor colorWithWhite:0.09 alpha:1.0];
//		UIColor *bgThird = [UIColor colorWithWhite:0.198 alpha:1.0];
//		UIColor *bgForth = [UIColor lightGrayColor];
//		
//		NSArray *bgColors = [NSArray arrayWithObjects:(id)bgFirst.CGColor, bgSecond.CGColor, bgThird.CGColor, bgForth.CGColor, nil];
//		NSArray *bgLocations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.02], [NSNumber numberWithFloat:0.98], [NSNumber numberWithFloat:1.0], nil];
        
		self.backgroundColor = [UIColor clearColor];
		
		CAGradientLayer *titleBarLayer = [CAGradientLayer layer];
		titleBarLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor],
								(id)[[UIColor colorWithWhite:0.15 alpha:1.0] CGColor],
								(id)[[UIColor colorWithWhite:0.13 alpha:1.0] CGColor],
								(id)[[UIColor colorWithWhite:0.09 alpha:1.0] CGColor],
								(id)[[UIColor blackColor] CGColor],
								nil];
		
		titleBarLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.02], [NSNumber numberWithFloat:0.50], [NSNumber numberWithFloat:0.501], [NSNumber numberWithFloat:1.0], nil];
		titleBarLayer.frame = CGRectMake(0.0, 0.0, 480.0, 50.0);
		titleBarLayer.startPoint = CGPointMake(0.5, 0.0);
		titleBarLayer.endPoint = CGPointMake(0.5, 1.0);
		titleBarLayer.opacity = 1.0;
		[self.layer addSublayer:titleBarLayer];
		
		CAGradientLayer *controlLayer = [CAGradientLayer layer];
		controlLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor],
							   (id)[[UIColor colorWithWhite:0.15 alpha:1.0] CGColor],
							   (id)[[UIColor colorWithWhite:0.13 alpha:1.0] CGColor],
							   (id)[[UIColor colorWithWhite:0.09 alpha:1.0] CGColor],
							   (id)[[UIColor blackColor] CGColor],
							   nil];
		controlLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.02], [NSNumber numberWithFloat:0.50], [NSNumber numberWithFloat:0.501], [NSNumber numberWithFloat:1.0], nil];
		controlLayer.frame = CGRectMake(0.0, 270.0, 480.0, 50.0);
		controlLayer.startPoint = CGPointMake(0.5, 0.0);
		controlLayer.endPoint = CGPointMake(0.5, 1.0);
		controlLayer.opacity = 1.0;
		[self.layer addSublayer:controlLayer];
		
		UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VideoBG.png"]];
		logoImage.center = CGPointMake(240.0, 25.0);
		[self addSubview:logoImage];
		[logoImage release];
		
    }
    return self;
}


//*******************************************************************
#pragma mark -
#pragma mark Dealloc
//*******************************************************************

- (void)dealloc {
    [super dealloc];
}


@end
