//
//  AppDelegate.m
//  CoreGraphicsTest
//
//  Created by Josh Grant on 1/25/14.
//  Copyright (c) 2014 Josh Grant. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ViewController *controller = [[ViewController alloc] init];
    self.window.rootViewController = controller;
    return YES;
}

@end
