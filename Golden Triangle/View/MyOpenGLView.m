//
//  MyOpenGLView.m
//  Golden Triangle
//
//  Created by Lucas Campbell on 11/28/13.
//  Copyright (c) 2013 Lucas Campbell. All rights reserved.
//

#import "MyOpenGLView.h"

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
    NSLog(@"Mouse Down Event");
    _xDown = [theEvent locationInWindow].x;
    _yDown = [theEvent locationInWindow].y;
}

- (void) mouseDragged: (NSEvent *) theEvent {
    NSPoint eventLocation = [theEvent locationInWindow];
    NSLog(@"Dragged x:%f", eventLocation.x - _xDown);
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
    GLObject *square = [GLObject new];
    [square setArrays: 4
          vertexArray: vertex_buffer
           colorArray: color_buffer];
    Mat4 *camera = [Mat4 new];
    [camera identity];
    [camera rotateXdeg: 45];
    [camera translateX: 0
                     Y: -2
                     Z: -7];
    Mat4 *perspective = [Mat4 new];
    [perspective identity];
    [perspective perspective: 45
                      aspect: (bounds.size.width / bounds.size.height)
                        near: 0.1
                         far: 100.0];

    [square drawUsingShader: shader
               cameraMatrix: camera
                perspective: perspective];
}
@end


