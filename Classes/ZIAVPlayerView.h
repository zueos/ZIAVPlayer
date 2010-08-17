//
//  ZIAVPlayerView.h
//  SchoolOfX
//
//  Created by Brandon Emrich on 6/17/10.
//  Copyright 2010 Zueos, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ZIAVControlView.h"
#import "ZIAVScrubberView.h"
#import "ZIAVPlaybackButton.h"
#import "ZIAVPlayerViewController.h"

@interface ZIAVPlayerView : UIView 
{
	AVPlayerLayer *playerLayer;
	CAGradientLayer *pauseLayer;
	CATextLayer *clickToPlay;
	CAShapeLayer *triangleLogo;
	ZIAVControlView *controlView;
	ZIAVScrubberView *scrubberView;
	BOOL fullScreen;
	BOOL visiable; 
	
	ZIAVPlaybackButton *playButton;
	ZIAVPlaybackButton *playButton1;
	
	UIButton *dismissButton;
	
	ZIAVPlayerViewController *parentController;
}

@property(nonatomic, retain) ZIAVPlayerViewController *parentController;

- (id)initWithFrame:(CGRect)frame withVideoPath:(NSString*)path ofType:(NSString*)mediaType;
- (id)initWithFrame:(CGRect)frame withVideoPath:(NSString*)path ofType:(NSString*)mediaType withControlsHidden:(BOOL)controlsHidden;
- (void) play:(id)sender;
- (UIBezierPath*)bezierPathWithCurvedShadowForRect:(CGRect)rect;

- (void) presentMovieViewInView:(UIView *)hostView animated:(BOOL)animated;

@end
