//
//  ZIAVPlayerView.m
//  SchoolOfX
//
//  Created by Brandon Emrich on 6/17/10.
//  Copyright 2010 Zueos, Inc. All rights reserved.
//

#import "ZIAVPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <QuartzCore/QuartzCore.h>
#import <dispatch/dispatch.h>

static const CGFloat offset = 0.0;
static const CGFloat curve = 10.0;

// 1 = YES , 2 = NO
#define __ZIAVPLAYER_RENDERS_SHADOW 0 
#define __ZIAVPLAYER_RENDERS_SHADOW_WITH_PATH 0

@implementation ZIAVPlayerView

@synthesize parentController;


//*******************************************************************
#pragma mark -
#pragma mark Making & Setting up the Class
//*******************************************************************


- (id)initWithFrame:(CGRect)frame withVideoPath:(NSString*)path ofType:(NSString*)mediaType {
	self = [self initWithFrame:frame withVideoPath:path ofType:mediaType withControlsHidden:NO];
	
	return self;
}


- (id)initWithFrame:(CGRect)frame withVideoPath:(NSString*)path ofType:(NSString*)mediaType withControlsHidden:(BOOL)controlsHidden {
    if ((self = [super initWithFrame:frame])) 
	{
        // Initialization code
		
		visiable = YES;
		
		[CATransaction begin];
		[CATransaction setDisableActions:YES];
				
		CALayer *backgroundLayer = [CALayer layer];
		backgroundLayer.backgroundColor = [[UIColor blackColor] CGColor];
		backgroundLayer.frame = frame;
		
		AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:path ofType:mediaType]] options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey]];
		
		AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
		
		// Set up a synchronized layer to sync the layer timing of its subtree
		// with the playback of the playerItem
		AVSynchronizedLayer *syncLayer = [AVSynchronizedLayer synchronizedLayerWithPlayerItem:playerItem];
		
		AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:syncLayer.playerItem];
		playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
		playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
		fullScreen = NO;
		playerLayer.frame = CGRectMake(0.0, 0.0, 480.0, 320.0);
		
#if __ZIAVPLAYER_RENDERS_SHADOW
		
		playerLayer.shadowOpacity = 0.7;
		playerLayer.shadowColor = [[UIColor blackColor] CGColor];
		playerLayer.shadowOffset = CGSizeMake(0.0, 0.0);
		playerLayer.shadowRadius = 5.0;
		
#if __ZIAVPLAYER_RENDERS_SHADOW_WITH_PATH
		
		UIBezierPath *shadowPath = [self bezierPathWithCurvedShadowForRect:CGRectMake(0.0, 25.0, 480.0, 300.0)];
		playerLayer.shadowPath = shadowPath.CGPath;
#endif
#endif
		
		[playerItem release], playerItem = nil;
		[syncLayer addSublayer:playerLayer];    // These sublayers will be synchronized
		
		controlView = [[ZIAVControlView alloc] initWithFrame:CGRectMake(0.0, 0.0, 480.0, 320.0)];
		controlView.userInteractionEnabled = NO;
		
		scrubberView = [[ZIAVScrubberView alloc] initWithFrame:CGRectMake(90.0, 285.0, 300.0, 20.0)];
		scrubberView.currentPlayerItem = playerItem;
		scrubberView.currentPlayer = player;
		
		playButton = [[ZIAVPlaybackButton alloc] initWithFrame:CGRectMake(5.0, 278.0, 34.0, 34.0) andImage:@"PlayButton.png"];
		[playButton setNormalImage:[UIImage imageNamed:@"PlayButton.png"]];
		[playButton setSelectedImage:[UIImage imageNamed:@"PauseButton.png"]];
		[playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
		
		playButton1 = [[ZIAVPlaybackButton alloc] initWithFrame:CGRectMake(441.0, 278.0, 34.0, 34.0) andImage:@"FullscreenButton.png"];
		[playButton1 setNormalImage:[UIImage imageNamed:@"FullscreenButton.png"]];
		[playButton1 addTarget:self action:@selector(adjustPlayerGravity) forControlEvents:UIControlEventTouchUpInside];
		
		
		/* Done Button */
		
		dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
		dismissButton.frame = CGRectMake(10.0, 10.0, 60.0, 30.0);
		[dismissButton setTitle:@"Done" forState:UIControlStateNormal];
		[dismissButton addTarget:self action:@selector(playerDidPlayToEnd:) forControlEvents:UIControlEventTouchDown];
		[dismissButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
		dismissButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		dismissButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
		dismissButton.titleLabel.textColor = [UIColor redColor];
				
		CAGradientLayer *dismissBGLayer = [CAGradientLayer layer];
		dismissBGLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor colorWithWhite:0.250 alpha:1.0] CGColor], nil];
		dismissBGLayer.frame = CGRectMake(0.0, 0.0, 60.0, 30.0);
		dismissBGLayer.cornerRadius = 5.8;
		dismissBGLayer.opacity = 1.0;
		
/*		UIColor *blueTopEdge	= [UIColor colorWithWhite:0.94 alpha:1.0];
//		UIColor *blueOne		= [UIColor colorWithRed:0.306 green:0.380 blue:0.577 alpha:1.000];
//		UIColor *blueTwo		= [UIColor colorWithRed:0.258 green:0.307 blue:0.402 alpha:1.000];
//		UIColor *blueThree	    = [UIColor colorWithRed:0.159 green:0.270 blue:0.550 alpha:1.000];
//		UIColor *blueFour		= [UIColor colorWithRed:0.129 green:0.220 blue:0.452 alpha:1.000];
//		
//		NSArray *blueColors  = [NSArray arrayWithObjects:(id)blueTopEdge.CGColor, blueOne.CGColor, blueTwo.CGColor, blueThree.CGColor, blueFour.CGColor, nil]; */
		NSArray *blueLocations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.02], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.501], [NSNumber numberWithFloat:1.0], nil];
		
		UIColor *grayTop = [UIColor colorWithWhite:1.0 alpha:1.0];
		UIColor *grayfirst = [UIColor colorWithRed:0.858 green:0.328 blue:0.407 alpha:1.000];
		UIColor *grayShine = [UIColor colorWithRed:0.892 green:0.161 blue:0.237 alpha:1.000];
		UIColor *grayAfter = [UIColor colorWithRed:0.831 green:0.000 blue:0.011 alpha:1.000];
		UIColor *graylast = [UIColor colorWithRed:0.340 green:0.000 blue:0.000 alpha:1.000];
		
		NSArray *grayColors = [NSArray arrayWithObjects:(id)grayTop.CGColor, grayfirst.CGColor, grayShine.CGColor, grayAfter.CGColor, graylast.CGColor, nil];
		
/*UIColor *lightBlue = [UIColor colorWithRed:0.443 green:0.533 blue:0.678 alpha:1.000];
		//UIColor *darkBlue = [UIColor colorWithRed:0.251 green:0.360 blue:0.548 alpha:1.000];
//		UIColor *almostBlack = [UIColor colorWithWhite:0.115 alpha:1.000];
//		UIColor *darkGray = [UIColor colorWithRed:0.243 green:0.246 blue:0.246 alpha:1.000];
*/
		
		CAGradientLayer *dismissLayer2 = [CAGradientLayer layer];
		dismissLayer2.colors = grayColors;
		dismissLayer2.locations = blueLocations;
		dismissLayer2.frame = CGRectMake(1.0, 1.0, 58.0, 28.0);
		dismissLayer2.cornerRadius = 5.6;
		dismissLayer2.opacity = 1.0;
		
		[dismissButton.layer addSublayer:dismissBGLayer];
		[dismissButton.layer addSublayer:dismissLayer2];		
		[dismissButton bringSubviewToFront:dismissButton.titleLabel];
		
		[self.layer addSublayer:backgroundLayer];
		
		//[self addSubview:backgroundImage];
		//[backgroundImage release];
		
		[self.layer addSublayer:syncLayer];
		
		if (controlsHidden) {
			[self addSubview:controlView];
			[self addSubview:scrubberView];
			[self addSubview:playButton];
			[self addSubview:playButton1];
		}
		
		[self addSubview:dismissButton];
		
		[CATransaction commit];
		
		[player play];
		[playButton setSelected:YES];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
		
		[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(fadeOutAfterNoInput) userInfo:nil repeats:NO];
	}
    return self;
}


//*******************************************************************
#pragma mark -
#pragma mark Changing playback state
//*******************************************************************

- (void) play:(id)sender {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self performSelector:@selector(fadeOutAfterNoInput) withObject:nil afterDelay:4.0];
	
	if (playerLayer.player.rate == 0.0) {
		[playerLayer.player play];
		[sender setSelected:YES];
	} else {
		[playerLayer.player pause];
		[sender setSelected:NO];
	}
}


- (void) playerDidPlayToEnd:(NSNotification *)notification {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
	[playerLayer.player pause];
	
	[[AVAudioSession sharedInstance] setActive:NO error:nil];
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
	
/*	
//	CALayer *touchedLayer = [self layer];
//	
//	CAAnimationGroup *group = [CAAnimationGroup animation];
//	group.delegate = self;
//	group.duration = 0.3;
//	group.removedOnCompletion = NO;
//	group.fillMode = kCAFillModeForwards;
//	
//	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//	scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
//	scaleAnimation.toValue = [NSNumber numberWithFloat:0.0];
//	
//	CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//	
//	fadeAnimation.fromValue = [NSNumber numberWithFloat:1.0];
//	fadeAnimation.toValue = [NSNumber numberWithFloat:0.0];
//	
//	group.animations = [NSArray arrayWithObjects:scaleAnimation, fadeAnimation, nil];
//	[touchedLayer layoutIfNeeded];
//	[touchedLayer addAnimation:group forKey:kCAOnOrderOut]; */
	
	//[playerLayer removeFromSuperlayer];
	//[parentController dismissModalViewControllerAnimated:YES];
}


- (void) animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	if (flag)
	{
		[self removeFromSuperview];
	}
}


//*******************************************************************
#pragma mark -
#pragma mark Presenting the Movie View
//*******************************************************************

- (void) presentMovieViewInView:(UIView *)hostView animated:(BOOL)animated {
	
	if (animated) {
		
		hostView.transform = CGAffineTransformMakeScale(0.3, 0.3);
		hostView.alpha = 0.0;
		[hostView addSubview:self];
		
		[UIView animateWithDuration:0.25 animations:^{
			hostView.transform = CGAffineTransformIdentity;
			hostView.alpha = 1.0;
		} completion:^(BOOL finished){
			NSLog(@"Finished Presenting Movie View");
		}];
		
	} else {
		
		[hostView addSubview:self];
		
	}
}


- (void) adjustPlayerGravity {
	NSLog(@"Gravity!");
	
	if (![playerLayer.videoGravity compare: AVLayerVideoGravityResizeAspect]) {
		playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	} else {
		playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
	}
}


//*******************************************************************
#pragma mark -
#pragma mark Touch Events
//*******************************************************************

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([touches count] == [[event touchesForWindow:self.window] count]) {
		
		[UIView beginAnimations:nil context:nil];
		
		if (visiable) {
			controlView.alpha = 0.0;
			scrubberView.alpha = 0.0;
			playButton.alpha = 0.0;
			playButton1.alpha = 0.0;
			dismissButton.alpha = 0.0;
			visiable = NO;
		} else {
			controlView.alpha = 1.0;
			scrubberView.alpha = 1.0;
			playButton.alpha = 1.0;
			playButton1.alpha = 1.0;
			dismissButton.alpha = 1.0;
			visiable = YES;
		}
		
		[UIView commitAnimations];
		
		//[NSObject cancelPreviousPerformRequestsWithTarget:self];
//		[self performSelector:@selector(fadeOutAfterNoInput) withObject:nil afterDelay:4.0];
	}
}


- (void) fadeOutAfterNoInput {
	[UIView beginAnimations:nil context:nil];
	controlView.alpha = 0.0;
	scrubberView.alpha = 0.0;
	playButton.alpha = 0.0;
	playButton1.alpha = 0.0;
	dismissButton.alpha = 0.0;
	[UIView commitAnimations];
}


//*******************************************************************
#pragma mark -
#pragma mark Helpers
//*******************************************************************

- (UIBezierPath*)bezierPathWithCurvedShadowForRect:(CGRect)rect {
	
	//dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
		
		UIBezierPath *path = [UIBezierPath bezierPath];	
		
		CGPoint topLeft		 = rect.origin;
		CGPoint bottomLeft	 = CGPointMake(0.0, CGRectGetHeight(rect)+offset);
		CGPoint bottomMiddle = CGPointMake(CGRectGetWidth(rect)/2, CGRectGetHeight(rect)-curve);	
		CGPoint bottomRight	 = CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect)+offset);
		CGPoint topRight	 = CGPointMake(CGRectGetWidth(rect), 25.0);
		
		[path moveToPoint:topLeft];	
		[path addLineToPoint:bottomLeft];
		[path addQuadCurveToPoint:bottomRight
					 controlPoint:bottomMiddle];
		[path addLineToPoint:topRight];
		[path addLineToPoint:topLeft];
		[path closePath];
		
		//dispatch_async(dispatch_get_main_queue(), UIBezierPath* ^{
			return path;
		//});
//	});
}


- (void)dealloc {
	
	[controlView release], controlView = nil;
	[scrubberView release], scrubberView = nil;
	[playButton release], playButton = nil;
	[playButton1 release], playButton1 = nil;
	[dismissButton release], dismissButton = nil;
	
    [super dealloc];
}


@end
