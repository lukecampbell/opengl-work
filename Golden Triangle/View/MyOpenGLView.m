//
//  MyOpenGLView.m
//  Golden Triangle
//
//  Created by Lucas Campbell on 11/28/13.
//  Copyright (c) 2013 Lucas Campbell. All rights reserved.
//

#import "MyOpenGLView.h"

#pragma mark Vertex Buffers

typedef struct _VertexObject {
    GLfloat *vertex_pos;
    GLfloat *vertex_color;
} VertexObject;

GLfloat vertex_buffer[] = {
    // Front face
    -1, -1, 1,
    -1,  1, 1,
     1, -1, 1,
     1,  1, 1,

    // Back face
    -1, -1,  1,
    -1,  1,  1,
     1,  1,  1,
     1, -1, -1
};

GLfloat vertex_colors[] = {
    1, 0, 0, 1,
    1, 0, 0, 1,
    1, 0, 0, 1,
    1, 0, 0, 1,

    0, 0, 1, 1,
    0, 0, 1, 1,
    0, 0, 1, 1,
    0, 0, 1, 1
};






#pragma mark GL Drawing


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
    GLfloat x = eventLocation.x - _xDown;
    GLfloat y = eventLocation.y - _yDown;
    GLfloat mag = sqrtf(x*x + y*y);
    GLfloat xn = x / mag;
    GLfloat yn = y / mag;
    GLfloat vec[] = {xn, yn, 0};
    GLfloat theta = mag * M_PI / (180 * 180);
    [self drawAnObject:self.frame withRotationTheta:theta withVector:vec];
    glFlush();

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
   [self drawAnObject: bounds
    withRotationTheta: 0.0
           withVector: NULL];
}



- (void) drawAnObject: (NSRect) bounds 
    withRotationTheta: (GLfloat) theta
           withVector: (GLfloat*) vec3
{
    GLObject *square = [GLObject new];
    [square setArrays: 4
          vertexArray: vertex_buffer
           colorArray: vertex_colors];
    Mat4 *camera = [Mat4 new];
    [camera identity];
    [camera translateX: 0
                     Y: 0
                     Z: -7];
    if(theta > 0 && vec3 != NULL) {
        NSLog(@"Rotating");
        [camera rotate: theta
                  axis: vec3];
    } else {
        GLfloat example[] = {1, 1, 0};
        [camera rotate: M_PI / 4
                  axis: example];
    }
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


