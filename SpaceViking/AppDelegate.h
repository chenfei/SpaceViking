//
//  AppDelegate.h
//  SpaceViking
//
//  Created by chen fei on 11-8-26.
//  Copyright founder 2011年. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
