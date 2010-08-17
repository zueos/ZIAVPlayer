//
//  ZIAVScrubberView.m
//  SchoolOfX
//
//  Created by Brandon Emrich on 7/2/10.
//  Copyright 2010 Zueos, Inc. All rights reserved.
//

#import "ZIAVScrubberView.h"
#import <QuartzCore/QuartzCore.h>
#include <dispatch/dispatch.h>

@implementation ZIAVScrubberView

@synthesize currentPlayerItem, currentPlayer;

//*******************************************************************
#pragma mark -
#pragma mark Making & Setting up the Class
//*******************************************************************

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
				
		controlShowing = YES;
		
		[CATransaction begin];
		[CATransaction setDisableActions:YES];
		
		CAGradientLayer *containerLayer = [CAGradientLayer layer];
		containerLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor darkGrayColor] CGColor], nil];
		containerLayer.frame = CGRectMake(-1.0, -1.0, CGRectGetWidth(frame) + 2.0, CGRectGetHeight(frame) +1.0);
		containerLayer.cornerRadius = 5.8;
		containerLayer.opacity = 1.0;
		
		UIColor *bgFirst = [UIColor blackColor];
		UIColor *bgSecond = [UIColor colorWithWhite:0.09 alpha:1.0];
		UIColor *bgThird = [UIColor colorWithWhite:0.198 alpha:1.0];
		UIColor *bgForth = [UIColor lightGrayColor];
		
		NSArray *bgColors = [NSArray arrayWithObjects:(id)bgFirst.CGColor, bgSecond.CGColor, bgThird.CGColor, bgForth.CGColor, nil];
		NSArray *bgLocations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.02], [NSNumber numberWithFloat:0.98], [NSNumber numberWithFloat:1.0], nil];
		
		CAGradientLayer *containerLayer1 = [CAGradientLayer layer];
		containerLayer1.colors = bgColors;
		containerLayer1.locations = bgLocations;
		containerLayer1.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(frame), CGRectGetHeight(frame));
		containerLayer1.cornerRadius = 5.8;
		containerLayer1.opacity = 1.0;
		
		//UIColor *blueTopEdge	= [UIColor colorWithWhite:0.96 alpha:1.0];
//		UIColor *blueOne		= [UIColor colorWithRed:0.306 green:0.380 blue:0.577 alpha:1.000];
//		UIColor *blueTwo		= [UIColor colorWithRed:0.258 green:0.307 blue:0.402 alpha:1.000];
//		UIColor *blueThree	    = [UIColor colorWithRed:0.159 green:0.270 blue:0.550 alpha:1.000];
//		UIColor *blueFour		= [UIColor colorWithRed:0.129 green:0.220 blue:0.452 alpha:1.000];
//		
//		NSArray *blueColors  = [NSArray arrayWithObjects:(id)blueTopEdge.CGColor, blueOne.CGColor, blueTwo.CGColor, blueThree.CGColor, blueFour.CGColor, nil];	
		
		UIColor *grayTop = [UIColor colorWithWhite:1.0 alpha:1.0];
		UIColor *grayfirst = [UIColor colorWithWhite:0.800 alpha:1.000];
		UIColor *grayShine = [UIColor colorWithWhite:0.86 alpha:1.000];
		UIColor *grayAfter = [UIColor colorWithWhite:0.78 alpha:1.000];
		UIColor *graylast = [UIColor colorWithWhite:0.600 alpha:1.000];
		
		NSArray *grayColors = [NSArray arrayWithObjects:(id)grayTop.CGColor, grayfirst.CGColor, grayShine.CGColor, grayAfter.CGColor, graylast.CGColor, nil];
		
		progressBar = [CAGradientLayer layer];
		
		//progressBar.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.85 alpha:1.000] CGColor], (id)[[UIColor colorWithWhite:0.98 alpha:1.000] CGColor], (id)[[UIColor colorWithWhite:0.80 alpha:1.000] CGColor], (id)[[UIColor colorWithWhite:0.7 alpha:1.000] CGColor], nil];
		progressBar.colors = grayColors;
		progressBar.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.02], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.501], [NSNumber numberWithFloat:1.0], nil];
		progressBar.frame = CGRectMake(0.0, 0.5, 0.0, 19.0);
		progressBar.cornerRadius = 5.6;
		progressBar.opacity = 1.0;
		
		[containerLayer1 addSublayer:progressBar];
		[self.layer addSublayer:containerLayer];
		[self.layer addSublayer:containerLayer1];
		
		
		
		playheadLayer = [CAGradientLayer layer];
		playheadLayer.frame = CGRectMake(0.0, 0.0, 12.0, 20.0);
		playheadLayer.colors = grayColors;
		playheadLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.02], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.501], [NSNumber numberWithFloat:1.0], nil];
		playheadLayer.cornerRadius = 5.0;
		playheadLayer.shadowColor = [[UIColor blackColor] CGColor];
		playheadLayer.shadowRadius = 2.0;
		playheadLayer.shadowOpacity = 1.0;
		playheadLayer.shadowOffset = CGSizeMake(0.0, 0.0);
		playheadLayer.opacity = 1.0;
		playheadLayer.borderColor = [[UIColor blackColor] CGColor];
		playheadLayer.borderWidth = 0.8;
		playheadLayer.startPoint = CGPointMake(1.0, 0.0);
		playheadLayer.endPoint = CGPointMake(0.0, 1.0);
		
		[self.layer addSublayer:playheadLayer];
		
		currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 14.0)];
		currentTimeLabel.center = CGPointMake(-18.0, 10.0);
		currentTimeLabel.text = @"0:00";
		currentTimeLabel.backgroundColor = [UIColor clearColor];
		currentTimeLabel.textColor = [UIColor lightTextColor];
		currentTimeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10.0];
		
		[self addSubview:currentTimeLabel];
		
		endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 15.0)];
		endTimeLabel.center = CGPointMake(CGRectGetWidth(frame) + 37.0, 10.0);
		endTimeLabel.text = @"0:00";
		endTimeLabel.backgroundColor = [UIColor clearColor];
		endTimeLabel.textColor = [UIColor lightTextColor];
		endTimeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10.0];
		
		[self addSubview:endTimeLabel];
		
		[CATransaction commit];
		
		 //Get the time ranges end time
		//CMTime endTime = CMTimeRangeGetEnd([rangeValue CMTimeRangeValue]);
		CMTime endTime = currentPlayer.currentItem.asset.duration;
		// convert that endTime object to seconds
		CGFloat endSeconds = CMTimeGetSeconds(endTime);
		
		duration = endSeconds;
		
		playBackTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(setPlayHead) userInfo:nil repeats:YES];
		
		/*CAShapeLayer *circleLayer = [CAShapeLayer layer];
		UIBezierPath *cirPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0, 0.0, 5.5, 5.5)];
		[cirPath closePath];
		circleLayer.path = cirPath.CGPath;
		circleLayer.fillColor = [[UIColor darkTextColor] CGColor];
		circleLayer.shadowPath = cirPath.CGPath;
		circleLayer.shadowOpacity = 1.0;
		circleLayer.shadowColor = [[UIColor whiteColor] CGColor];
		circleLayer.shadowRadius = 0.0;
		circleLayer.shadowOffset = CGSizeMake(0.5, 0.0);
		circleLayer.position = CGPointMake(1.0, 0.5);*/
    }
    return self;
}


//*******************************************************************
#pragma mark -
#pragma mark setPlayHead Loop called every 0.2 milli's
//*******************************************************************

- (void) setPlayHead {
	
	//if (currentPlayer.rate == 0.0) 
//		return;
//	
	if (self.tracking) 
		return;
	
	if (self.alpha <= 0.0)
		return;
	
	// Get the time ranges end time
	// CMTime endTime = CMTimeRangeGetEnd([rangeValue CMTimeRangeValue]);
	CMTime endTime = currentPlayer.currentItem.asset.duration;
	// convert that endTime object to seconds
	CGFloat endSeconds = CMTimeGetSeconds(endTime);
	
	duration = endSeconds;
	
	CGFloat currentSeconds = CMTimeGetSeconds(currentPlayer.currentTime);
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
		
		int seconds = (int)currentSeconds % 60;
		int minutes = (int)currentSeconds / 60;
		
		NSString *timeString = nil;
		
		timeString = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
		
		//** Algorithm Begin **//
		
		Float64 percentComplete =  currentSeconds * 100.0 / endSeconds;
		
		//CGFloat newPosition = CGRectGetWidth(CGRectMake(90.0, 310.0, 300.0, 20.0)) - ( percentComplete * (CGRectGetWidth(CGRectMake(90.0, 310.0, 300.0, 20.0)) / 100));
		
		CGFloat newPosition = percentComplete * ( 300.0 / 100 );
				
		// newPostion need to represent the playHeads position from 400 to 0 
		// 400 = the movies start time and 0 = the movies total duration.
		
		//** Algorithm End **//
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue
							 forKey:kCATransactionDisableActions];
			
			currentTimeLabel.text = timeString;
			endTimeLabel.text = [NSString stringWithFormat:@"0:%02.0f", duration - currentSeconds];
			
			if ((newPosition >= 295.0) || (newPosition <= 5.0)) {
				
			} else {
				CGFloat percent = (percentComplete / 100);
				
				if (!self.tracking)
					playheadLayer.position = CGPointMake( newPosition + 1.0, 10.0);
				playheadLayer.startPoint = CGPointMake( 1.0 - percent , 0.0);
				playheadLayer.endPoint = CGPointMake( percent, 1.0);
			}
			
			progressBar.frame = CGRectMake(0.0, 0.5, newPosition, 19.0);
			[CATransaction commit];
		});
	});
}



//*******************************************************************
#pragma mark -
#pragma mark Touch Events
//*******************************************************************

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	
	[currentPlayer pause];
		
	CGPoint location = [touch locationInView:self];
	
	if (location.x >= CGRectGetWidth(self.frame))
		return NO;
	if (location.x <= 0.0) 
		return NO;
	
	playheadLayer.affineTransform = CGAffineTransformMakeScale(1.3, 1.3);
	
	//CATransform3D scale = CATransform3DMakeScale(2.0, 2.0, 1.0);
//	CATransform3D invert = CATransform3DMakeTranslation(1.0, -4.0, 1.0);
//	
//	playheadLayer.transform = CATransform3DConcat(scale, invert);
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
	
	playheadLayer.shadowColor = [[UIColor whiteColor] CGColor];
	playheadLayer.shadowRadius = 2.0;
	playheadLayer.shadowOpacity = 0.9;
	playheadLayer.shadowOffset = CGSizeMake(0.0, 0.0);
	//playheadLayer.borderWidth = 1.0;
	
	//progressBar.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:0.198 green:0.491 blue:0.812 alpha:1.000], (id)[UIColor colorWithRed:0.183 green:0.327 blue:0.553 alpha:1.000], nil];
	
	[CATransaction commit];
	
	
	return YES;
}


- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	
	CGPoint locationPoint = [touch locationInView:self];
	
	if (locationPoint.x >= CGRectGetWidth(self.frame))
		return NO;
	if (locationPoint.x <= 0.0) 
		return NO;
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	
	playheadLayer.position = CGPointMake(locationPoint.x + 1.0, 10.0);
	
	progressBar.frame = CGRectMake(0.0, 0.5, locationPoint.x, 19.5);
	
	CGFloat location = (locationPoint.x);
	
	NSLog(@"Location: %f", location);
	NSLog(@"Duration: %f", duration);
	
	CGFloat percentageOfCompletion = ((location / 3.0) / 100) * duration;
	
	CGFloat percent = ((percentageOfCompletion / 100) * 2.0);
	playheadLayer.startPoint = CGPointMake( 1.0 - percent , 0.0);
	playheadLayer.endPoint = CGPointMake( percent, 1.0);
	
	NSLog(@"NewSeconds: %f", percentageOfCompletion);
	
	int seconds = (int)percentageOfCompletion % 60;
	int minutes = (int)percentageOfCompletion / 60;
	
	NSString *timeString = nil;
	
	timeString = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
	
	currentTimeLabel.text = timeString;
	
	[self.currentPlayer.currentItem seekToTime:CMTimeMakeWithSeconds(percentageOfCompletion, 1.0) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
	[self.currentPlayer seekToTime:CMTimeMakeWithSeconds(percentageOfCompletion, 1.0) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
	
	[CATransaction commit];
	
	return YES;
}


- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	
	playheadLayer.affineTransform = CGAffineTransformIdentity;
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
	
	playheadLayer.shadowColor = [[UIColor blackColor] CGColor];
	playheadLayer.shadowRadius = 2.0;
	playheadLayer.shadowOpacity = 0.7;
	playheadLayer.shadowOffset = CGSizeMake(0.0, 0.0);
	//playheadLayer.borderWidth = 0.0;
	
	//progressBar.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.800 alpha:1.000] CGColor], (id)[[UIColor colorWithWhite:0.600 alpha:1.000] CGColor], nil];

	[CATransaction commit];
	
	[currentPlayer play];
}


//*******************************************************************
#pragma mark -
#pragma mark Additional Drawing (drawRect:)
//*******************************************************************

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//*******************************************************************
#pragma mark -
#pragma mark Dealloc
//*******************************************************************

- (void)dealloc {
    [super dealloc];
}


@end
