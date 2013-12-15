//
//  GLObject.h
//  Golden Triangle
//
//  Created by Lucas Campbell on 12/15/13.
//  Copyright (c) 2013 Lucas Campbell. All rights reserved.
//

#import "Mat4.h"
#import "Shader.h"
#import <Foundation/Foundation.h>


@interface GLObject : NSObject {
    Mat4 *modelView;
    GLfloat *vertexArray;
    GLfloat *colorArray;
    GLsizei points;
}

- (void) drawUsingShader: (Shader *) shader 
            cameraMatrix: (Mat4 *) cameraMatrix  
             perspective: (Mat4 *) pMatrix ;
- (void) setArrays: (GLsizei) points
       vertexArray: (GLfloat *) vArray
        colorArray: (GLfloat *) cArray ;

@end
