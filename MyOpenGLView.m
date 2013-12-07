//
//  MyOpenGLView.m
//  Golden Triangle
//
//  Created by Lucas Campbell on 11/28/13.
//  Copyright (c) 2013 Lucas Campbell. All rights reserved.
//

#import "MyOpenGLView.h"
#include <OpenGL/gl.h>

#pragma mark Vertex Buffers

static double vertex_buffer[] = {
   -0.6, 0.0, 0.0,
    0.6, 0.0, 0.0,
    0.0, 0.6, 0.0,
    0.6, -0.6, 0.0,
};


#pragma mark GL Drawing

/*
 * void drawAnObject(void)
 * Renders the scene using GL
 */
static void drawAnObject ()
{
    //glColor3f(1.0f, 0.85f, 0.35f);
    size_t i=0;
    size_t array_len = sizeof(vertex_buffer)/sizeof(vertex_buffer[0]);
    double *v = NULL;
    glBegin(GL_TRIANGLE_STRIP);
    glColor3f(1.0f, 0.85f, 0.35f);
    for(i=0;i<array_len/3;i++) {
        v = &vertex_buffer[i*3];
        glVertex3f(v[0], v[1], v[2]);
    }
    glEnd();
}

@implementation MyOpenGLView

/*
 * - (void) drawRect:(NSRect)bounds 
 * Initializes the context, sets and renders the scene
 */
- (void) drawRect:(NSRect)bounds {
    [self initGLExtensions];
    glClearColor(1, 1, 1, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    drawAnObject();
    glFlush();
}

/* Overrides the responders so that we can get mouse events */
-(BOOL)acceptsFirstResponder { return YES; }
-(BOOL)becomeFirstResponder { return YES; }
-(BOOL)resignFirstResponder { return YES; }
-(void)awakeFromNib {
    [[self window] setAcceptsMouseMovedEvents:YES];
}

/* Handles the mouseDown event in the context */
- (void)mouseDown:(NSEvent *)theEvent {
    NSLog(@"Has Shader: %@", [self hasVertexShader] ? @"Yes" : @"No");
}

/* Initializes gl_extensions list with all the GL_EXTENSIONS available */
- (void)initGLExtensions {
    const GLubyte *extensions = glGetString(GL_EXTENSIONS);
    NSString *s_extensions = [NSString stringWithUTF8String:(const char*) extensions];
    gl_extensions = [s_extensions componentsSeparatedByString:@" "];

}

/* Do we have the GL_ARB_vertex_shader extension? */
- (BOOL) hasVertexShader {
    return [gl_extensions containsObject: @"GL_ARB_vertex_shader"];
}


/* Debugging */
- (void) testSomething {
    BOOL has_vertex_shader = [self hasVertexShader];
    NSLog(@"Has Vertex Shader: %@", has_vertex_shader ? @"Yes" : @"No");
}
@end


