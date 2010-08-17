//
//  ZIAVPlayerViewController.h
//  ZIAVPlayer
//
//  Created by Brandon Emrich on 8/16/10.
//  Copyright 2010 Zueos, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZIAVPlayerViewController : UIViewController 
{
	NSString *videoPath;
	NSString *videoType;
	
	BOOL isIntro;
}

@property (nonatomic, retain, readwrite) NSString *videoPath;
@property (nonatomic, retain, readwrite) NSString *videoType;

@property (nonatomic, readwrite) BOOL isIntro;

@end

