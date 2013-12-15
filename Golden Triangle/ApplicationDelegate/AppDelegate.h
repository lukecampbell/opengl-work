//
//  AppDelegate.h
//  Golden Triangle
//
//  Created by Lucas Campbell on 11/28/13.
//  Copyright (c) 2013 Lucas Campbell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyOpenGLView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) MyOpenGLView *view;

@end
