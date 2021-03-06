//
//  MyOpenGLView.h
//  Golden Triangle
//
//  Created by Lucas Campbell on 11/28/13.
//  Copyright (c) 2013 Lucas Campbell. All rights reserved.
//

#import "Shader/Shader.h"
#import "Utils/Queue.h"
#import <Cocoa/Cocoa.h>


@interface MyOpenGLView : NSOpenGLView
{
   @private
       BOOL initialized;
       NSArray *gl_extensions; 
       Shader *shader;
       Queue *cameraInstructions;
}

@property CGFloat xDown;
@property CGFloat yDown;

- (NSOpenGLPixelFormat *) pixelFormat;

- (void) initGL: (NSRect) theFrame;
- (void) drawRect:(NSRect) bounds;
- (void) initGLExtensions;
- (void) initShaders;
- (void) drawAnObject: (NSRect) bounds;
@end
