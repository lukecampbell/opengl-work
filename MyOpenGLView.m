//
//  MyOpenGLView.m
//  Golden Triangle
//
//  Created by Lucas Campbell on 11/28/13.
//  Copyright (c) 2013 Lucas Campbell. All rights reserved.
//

#import "MyOpenGLView.h"
#
#include <OpenGL/gl.h>

#pragma mark Vertex Buffers

static GLfloat vertex_buffer[] = {
   -0.6, 0.0, 0.0,
    0.6, 0.0, 0.0,
    0.0, 0.6, 0.0
};

static GLfloat color_buffer[] = {
    0., 1., 0., 1.,
    0., 1., 0., 1.,
    0., 1., 0., 1.,
};

static GLfloat pMatrix[] = {
    2.4142136573791504,                  0,                    0,  0,
                     0, 2.4142136573791504,                    0,  0,
                     0,                  0,  -1.0020020008087158, -1,
                     0,                  0, -0.20020020008087158,  0
};

static GLfloat mvMatrix[] = {
    1., 0., 0., 0.,
    0., 1., 0., 0.,
    0., 0., 1., 0.,
    0., 0., -7., 1.
};

#pragma mark GL Drawing

/*
 * void drawAnObject(void)
 * Renders the scene using GL
 */

@implementation MyOpenGLView

/*
 * - (void) drawRect:(NSRect)bounds 
 * Initializes the context, sets and renders the scene
 */
- (void) drawRect:(NSRect)bounds {
    [self initGLExtensions];
    [self initShaders];
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glClearColor(0., 0., 0., 1.);
    glEnable(GL_DEPTH_TEST);
    [self drawAnObject];
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

- (void) initShaders {
    shader = [[Shader alloc] initWithShadersInAppBundle:@"Simple"];
    glUseProgram([shader programObject]);
    NSLog(@"Shaders Loaded");
}

- (void) drawAnObject {
    //glColor3f(1.0f, 0.85f, 0.35f);
    GLuint vbuffer;
    GLint vpos;
    GLint vcolor;
    GLint umvmat;
    GLint upmat;
    glGenBuffers(1, &vbuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vbuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertex_buffer), vertex_buffer, GL_STATIC_DRAW);
    vpos = [shader getAttribLocation: "aVertexPosition"];
    glEnableVertexAttribArray(vpos);

    glVertexAttribPointer(vpos, 3, GL_FLOAT, false, 0, 0);
    
    glGenBuffers(1, &vbuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vbuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(color_buffer), color_buffer, GL_STATIC_DRAW);
    vcolor = [shader getAttribLocation: "aVertexColor"];

    glVertexAttribPointer(vcolor, 4, GL_FLOAT, false, 0, 0);
    glEnableVertexAttribArray(vcolor);

    umvmat = [shader getUniformLocation: "uMVMatrix"];
    upmat = [shader getUniformLocation: "uPMatrix"];

    glUniformMatrix4fv(umvmat, 1, false, mvMatrix);
    glUniformMatrix4fv(upmat, 1, false, pMatrix);


    glDrawArrays(GL_TRIANGLE_STRIP,0,3);
}
@end


