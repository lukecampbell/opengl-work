//
//  MyOpenGLView.h
//  Golden Triangle
//
//  Created by Lucas Campbell on 11/28/13.
//  Copyright (c) 2013 Lucas Campbell. All rights reserved.
//

#import "Shader.h"
#import "Mat4.h"
#import "GLObject.h"
#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>


@interface MyOpenGLView : NSOpenGLView
{
   @private
       BOOL initialized;
       NSArray *gl_extensions; 
       Shader *shader;
}

@property CGFloat xDown;
@property CGFloat yDown;

- (NSOpenGLPixelFormat *) pixelFormat;

- (void) initGL: (NSRect) theFrame;
- (void) drawRect:(NSRect) bounds;
- (void) initGLExtensions;
- (void) initShaders;
- (void) drawAnObject: (NSRect) bounds 
    withRotationTheta: (GLfloat) theta
           withVector: (GLfloat*) vec3;
- (void) drawAnObject: (NSRect) bounds;
@end
