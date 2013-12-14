//
//  MyOpenGLView.m
//  Golden Triangle
//
//  Created by Lucas Campbell on 11/28/13.
//  Copyright (c) 2013 Lucas Campbell. All rights reserved.
//

#import "MyOpenGLView.h"
#import "Mat4.h"
#include <OpenGL/gl.h>

#pragma mark Vertex Buffers

static GLfloat vertex_buffer[] = {
    -1.0, -1.0, 0.0,
    -1.0,  1.0, 0.0,
     1.0, -1.0, 0.0,
     1.0,  1.0, 0.0
};

static GLfloat color_buffer[] = {
    1., 0., 0., 0.,
    1., 1., 1., 1.,
    1., 1., 1., 1.,
    1., 0., 0., 1.
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
    if(!initialized) {
        [self initGL: bounds];
    }
    NSLog(@"Drawing");
    GLsizei w = NSWidth(bounds),
            h = NSHeight(bounds);
    NSLog(@"%d %d", w,h);
    glViewport(0, 0, w, h);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glClearColor(0., 0., 0., 1.);
    glEnable(GL_DEPTH_TEST);
    [self drawAnObject: bounds];
    glFlush();
}

/* Overrides the responders so that we can get mouse events */
-(BOOL)acceptsFirstResponder { return YES; }
-(BOOL)becomeFirstResponder { return YES; }
-(BOOL)resignFirstResponder { return YES; }
-(void)awakeFromNib {
    [[self window] setAcceptsMouseMovedEvents:YES];
    initialized = NO;
}

- (void) initGL: (NSRect) theFrame {
    [self initGLExtensions];
    [self initShaders];
    initialized = YES;
}

/* Handles the mouseDown event in the context */
- (void)mouseDown:(NSEvent *)theEvent {

}

- (id) initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if(self) {
        NSLog(@"NSOpenGL initializatio");
        [self setFrameSize: frameRect.size];
    }
    return self;
}

/* Initializes gl_extensions list with all the GL_EXTENSIONS available */
- (void)initGLExtensions {
    const GLubyte *extensions = glGetString(GL_EXTENSIONS);
    NSString *s_extensions = [NSString stringWithUTF8String:(const char*) extensions];
    gl_extensions = [s_extensions componentsSeparatedByString:@" "];

}

- (void) initShaders {
    shader = [[Shader alloc] initWithShadersInAppBundle:@"Simple"];
    glUseProgram([shader programObject]);
    NSLog(@"Shaders Loaded");
}

- (void) drawAnObject: (NSRect) bounds {
    //glColor3f(1.0f, 0.85f, 0.35f);
    GLuint vbuffer;
    GLint vpos;
    GLint vcolor;
    GLint umvmatAttr;
    GLint upmatAttr;
    Mat4 *uMVMatrix = [[Mat4 alloc] init];
    Mat4 *uPMatrix = [[Mat4 alloc] init];
    GLfloat translation[] = { 0., 0., -7.0};

    /* -- Set vertex for aVertexPosition -- */
    glGenBuffers(1, &vbuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vbuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertex_buffer), vertex_buffer, GL_STATIC_DRAW);
    vpos = [shader getAttribLocation: "aVertexPosition"];
    glEnableVertexAttribArray(vpos);

    glVertexAttribPointer(vpos, 3, GL_FLOAT, false, 0, 0);
    
    /* -- Set color for aVertexColor -- */
    glGenBuffers(1, &vbuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vbuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(color_buffer), color_buffer, GL_STATIC_DRAW);
    vcolor = [shader getAttribLocation: "aVertexColor"];

    glVertexAttribPointer(vcolor, 4, GL_FLOAT, false, 0, 0);
    glEnableVertexAttribArray(vcolor);

    /* -- Set uniform matrices -- */
    umvmatAttr = [shader getUniformLocation: "uMVMatrix"];
    upmatAttr = [shader getUniformLocation: "uPMatrix"];

    [uPMatrix perspective: 45.0
                   aspect: bounds.size.width / bounds.size.height
                     near: 0.1
                      far: 100.0];

    [uMVMatrix identity];
    [uMVMatrix translate: translation];
    glUniformMatrix4fv(umvmatAttr, 1, false, uMVMatrix.floats);
    glUniformMatrix4fv(upmatAttr, 1, false, uPMatrix.floats);


    glDrawArrays(GL_TRIANGLE_STRIP,0,4);
}
@end


