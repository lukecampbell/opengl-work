//
//  AppDelegate.m
//  Golden Triangle
//
//  Created by Lucas Campbell on 11/28/13.
//  Copyright (c) 2013 Lucas Campbell. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"Well, I'm here now, aren't I?");
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
