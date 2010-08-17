//
//  ZIAVPlaybackButton.m
//  SchoolOfX
//
//  Created by Brandon Emrich on 7/2/10.
//  Copyright 2010 Zueos, Inc. All rights reserved.
//

#import "ZIAVPlaybackButton.h"

@implementation ZIAVPlaybackButton


@synthesize normalImage, selectedImage;


//*******************************************************************
#pragma mark -
#pragma mark Making & Setting up the Class
//*******************************************************************

- (id)initWithFrame:(CGRect)frame andImage:(NSString*)imagePath {
    if ((self = [super initWithFrame:frame])) {
		
		UIColor *bgFirst = [UIColor whiteColor];
		UIColor *bgSecond = [UIColor colorWithWhite:0.35 alpha:1.0];
		UIColor *bgThird = [UIColor colorWithWhite:0.75 alpha:1.0];
		UIColor *bgForth = [UIColor whiteColor];
		
		NSArray *bgColors = [NSArray arrayWithObjects:(id)bgForth.CGColor, bgSecond.CGColor, bgThird.CGColor, bgFirst.CGColor, nil];
		NSArray *bgLocations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.02], [NSNumber numberWithFloat:0.98], [NSNumber numberWithFloat:1.0], nil];
				
		CALayer *maskLayer = [CALayer layer];
		maskLayer.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(frame), CGRectGetHeight(frame));
		maskLayer.contents = (id)[[UIImage imageNamed:imagePath] CGImage];
		
		layerOne = [CAGradientLayer layer];
		layerOne.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(frame), CGRectGetHeight(frame));
		layerOne.colors = bgColors;
		layerOne.locations = bgLocations;
		layerOne.mask = maskLayer;
		layerOne.borderColor = [UIColor whiteColor].CGColor;
		layerOne.borderWidth = 1.0;
		
		[self.layer addSublayer:layerOne];
    }
    return self;
}


//*******************************************************************
#pragma mark -
#pragma mark Changing the Control's state
//*******************************************************************

- (void) setSelected:(BOOL)selected {
	
	UIColor *bgFirst = [UIColor whiteColor];
	UIColor *bgSecond = [UIColor colorWithWhite:0.35 alpha:1.0];
	UIColor *bgThird = [UIColor colorWithWhite:0.75 alpha:1.0];
	UIColor *bgForth = [UIColor whiteColor];
	
	NSArray *bgColors = [NSArray arrayWithObjects:(id)bgForth.CGColor, bgSecond.CGColor, bgThird.CGColor, bgFirst.CGColor, nil];
	NSArray *bgLocations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.02], [NSNumber numberWithFloat:0.98], [NSNumber numberWithFloat:1.0], nil];
	
	if (selected) {
		
		[layerOne removeFromSuperlayer];
		if (!layerOne) {
			layerOne = [CAGradientLayer layer];
		}
		
		CALayer *newMask = [CALayer layer];
		newMask.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
		newMask.contents = (id)selectedImage.CGImage;
		
		layerOne.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
		layerOne.colors = bgColors;
		layerOne.locations = bgLocations;
		layerOne.mask = newMask;
		layerOne.borderColor = [UIColor whiteColor].CGColor;
		layerOne.borderWidth = 1.0;
		
		[self.layer addSublayer:layerOne];
			
//		[theImageView setImage:selectedImage];
	} else {
		[layerOne removeFromSuperlayer];
		if (!layerOne) {
			layerOne = [CAGradientLayer layer];
		}
		
		CALayer *newMask = [CALayer layer];
		newMask.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
		newMask.contents = (id)normalImage.CGImage;
		
		layerOne.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
		layerOne.colors = bgColors;
		layerOne.locations = bgLocations;
		layerOne.mask = newMask;
		layerOne.borderColor = [UIColor whiteColor].CGColor;
		layerOne.borderWidth = 1.0;
		
		[self.layer addSublayer:layerOne];
	}
}


- (void)dealloc {
    [super dealloc];
}


@end
