//
//  GLObject.m
//  Golden Triangle
//
//  Created by Lucas Campbell on 12/15/13.
//  Copyright (c) 2013 Lucas Campbell. All rights reserved.
//

#import "GLObject.h"

@implementation GLObject

- (id) init {
    self = [super init];
    if(self) {
        modelView = [Mat4 new];
        [modelView identity];
        vertexArray = NULL;
        colorArray = NULL;
        points = 0;
    }
    return self;
}

- (void) dealloc {
    if(vertexArray) {
        free(vertexArray);
    }
    if(colorArray) {
        free(colorArray);
    }
}

- (void) setArrays: (GLsizei) p
       vertexArray: (GLfloat *) vArray
        colorArray: (GLfloat *) cArray {
    if(vertexArray) {
        free(vertexArray);
    }
    if(colorArray) {
        free(colorArray);
    }
    points = p;
    size_t n = sizeof(GLfloat) * points;
    vertexArray = malloc(n * 3);
    colorArray = malloc(n * 4);
    memcpy(vertexArray, vArray, n * 3);
    memcpy(colorArray, cArray, n * 4);
}

- (void) drawUsingShader: (Shader *) shader 
            cameraMatrix: (Mat4 *) cameraMatrix  
             perspective: (Mat4 *) pMatrix {
    GLuint vbuffer;
    GLint attrib;
    GLint uniform;
    Mat4 *mv = [modelView clone];
    if(vertexArray==NULL || colorArray==NULL) {
        return;
    }

    /* Handle the vertex buffer */
    glGenBuffers(1, &vbuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vbuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * points * 3, vertexArray, GL_STATIC_DRAW);
    attrib = [shader getAttribLocation: "aVertexPosition"];
    glEnableVertexAttribArray(attrib);
    glVertexAttribPointer(attrib, 3, GL_FLOAT, false, 0, 0);

    /* Handle the color buffer */
    glGenBuffers(1, &vbuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vbuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * points * 4, colorArray, GL_STATIC_DRAW);
    attrib = [shader getAttribLocation: "aVertexColor"];
    glEnableVertexAttribArray(attrib);
    glVertexAttribPointer(attrib, 4, GL_FLOAT, false, 0, 0);

    /* set uniforms */
    uniform = [shader getUniformLocation: "uMVMatrix"];

    /* Do camera translations */
    [mv dot: cameraMatrix];
    NSLog(@"mv: %@", [mv toString]);
    glUniformMatrix4fv(uniform, 1, false, mv.floats);

    uniform = [shader getUniformLocation: "uPMatrix"];

    glUniformMatrix4fv(uniform, 1, false, pMatrix.floats);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, points);
 }




    


@end
