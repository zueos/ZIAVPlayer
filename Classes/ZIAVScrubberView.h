//
//  ZIAVScrubberView.h
//  SchoolOfX
//
//  Created by Brandon Emrich on 7/2/10.
//  Copyright 2010 Zueos, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface ZIAVScrubberView : UIControl 
{
	NSTimer *playBackTimer;
	
	CAGradientLayer *playheadLayer;
	CAGradientLayer *progressBar;
	
	AVPlayerItem *currentPlayerItem;
	AVPlayer *currentPlayer;
	
	UILabel *currentTimeLabel;
	UILabel *endTimeLabel;
	
	CGFloat duration;
	
	BOOL controlShowing;
}

@property (nonatomic, retain) AVPlayerItem *currentPlayerItem;
@property (nonatomic, retain) AVPlayer *currentPlayer;

@end
