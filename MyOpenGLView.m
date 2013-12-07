//
//  MyOpenGLView.m
//  Golden Triangle
//
//  Created by Lucas Campbell on 11/28/13.
//  Copyright (c) 2013 Lucas Campbell. All rights reserved.
//

#import "MyOpenGLView.h"
#include <OpenGL/gl.h>

static double vertex_buffer[] = {
   -0.6, 0.0, 0.0,
    0.6, 0.0, 0.0,
    0.0, 0.6, 0.0,
    0.6, -0.6, 0.0,
};


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

- (void) drawRect:(NSRect)bounds {
    glClearColor(1, 1, 1, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    drawAnObject();
    glFlush();
}

-(BOOL)acceptsFirstResponder { return YES; }
-(BOOL)becomeFirstResponder { return YES; }
-(BOOL)resignFirstResponder { return YES; }
-(void)awakeFromNib {
    [[self window] setAcceptsMouseMovedEvents:YES];
}
- (void)mouseDown:(NSEvent *)theEvent {
    NSLog(@"Mouse was clicked");
}
@end


