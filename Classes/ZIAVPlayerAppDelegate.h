//
//  ZIAVPlayerAppDelegate.h
//  ZIAVPlayer
//
//  Created by Brandon Emrich on 8/16/10.
//  Copyright 2010 Zueos, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZIAVPlayerViewController;

@interface ZIAVPlayerAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
    ZIAVPlayerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ZIAVPlayerViewController *viewController;

@end

