//
//  ZIAVPlayerViewController.m
//  ZIAVPlayer
//
//  Created by Brandon Emrich on 8/16/10.
//  Copyright 2010 Zueos, Inc. All rights reserved.
//

#import "ZIAVPlayerViewController.h"
#import "ZIAVPlayerView.h"

@implementation ZIAVPlayerViewController

@synthesize videoPath, videoType, isIntro;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	if (!videoPath)
		videoPath = @"m4v";
	
	ZIAVPlayerView *playerView;
	
	if (isIntro) {
		playerView = [[ZIAVPlayerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 480.0, 320.0) withVideoPath:videoPath ofType:@"mov" withControlsHidden:NO];
	} else {
		playerView = [[ZIAVPlayerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 480.0, 320.0) withVideoPath:videoPath ofType:@"mov" withControlsHidden:YES];
	}
	
	playerView.parentController = self;
	
	self.view = playerView;
	[playerView release];
	
	self.view.backgroundColor = [UIColor blackColor];
}


- (void)viewDidLoad {
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft); // || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
