//
//  Mat4.h
//  Golden Triangle
//
//  Created by Lucas Campbell on 12/10/13.
//  Copyright (c) 2013 Lucas Campbell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGL/gl.h>

@interface Mat4 : NSObject {
    @private
        GLfloat *mat;
    
}
@property (readonly) GLfloat *floats;
- (void) identity;
- (NSString *) toString;
- (void) perspective: (GLfloat) fovy
              aspect: (GLfloat) aspect
                near: (GLfloat) near
                 far: (GLfloat) far;
- (Mat4*) clone;
- (void) transpose;
- (id) initFromFloats: (GLfloat *)arr;
- (BOOL) equals: (Mat4*) other;
- (void) translate: (GLfloat*) v;
- (void) translateX: (GLfloat) x
                  Y: (GLfloat) y
                  Z: (GLfloat) z;
- (void) rotate: (GLfloat) rad
           axis: (GLfloat *) axis;
- (BOOL) nearEqual: (Mat4*) other;
- (void) dot: (Mat4*) other;

@end
