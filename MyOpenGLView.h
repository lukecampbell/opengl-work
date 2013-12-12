//
//  MyOpenGLView.h
//  Golden Triangle
//
//  Created by Lucas Campbell on 11/28/13.
//  Copyright (c) 2013 Lucas Campbell. All rights reserved.
//

#import "Shader.h"
#import <Cocoa/Cocoa.h>


@interface MyOpenGLView : NSOpenGLView
{
   @private
       NSArray *gl_extensions; 
       Shader *shader;
}

- (void) drawRect:(NSRect) bounds;
- (void) testSomething;
- (void) initGLExtensions;
- (BOOL) hasVertexShader;
- (void) initShaders;
- (void) drawAnObject;
@end
