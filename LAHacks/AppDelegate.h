//
//  AppDelegate.h
//  LAHacks
//
//  Created by Aryaman Sharda on 4/11/14.
//  Copyright (c) 2014 LaHacks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>
#import "RecordViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (Rdio *)rdioInstance;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) RecordViewController *viewController;
@property (readonly) Rdio *rdio;
@end
