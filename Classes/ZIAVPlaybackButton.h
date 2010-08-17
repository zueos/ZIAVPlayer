//
//  ZIAVPlaybackButton.h
//  SchoolOfX
//
//  Created by Brandon Emrich on 7/2/10.
//  Copyright 2010 Zueos, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface ZIAVPlaybackButton : UIButton 
{
	CALayer *imageLayer;
	
	UIImage *normalImage;
	UIImage *selectedImage;
	
	UIImageView *theImageView;

	CAGradientLayer* layerOne;
}
@property (nonatomic, retain) UIImage *normalImage;
@property (nonatomic, retain) UIImage *selectedImage;

- (id)initWithFrame:(CGRect)frame andImage:(NSString*)imagePath;

@end
