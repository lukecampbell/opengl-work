//
//  Mat4.m
//  Golden Triangle
//
//  Created by Lucas Campbell on 12/10/13.
//  Copyright (c) 2013 Lucas Campbell. All rights reserved.
//

#import "Mat4.h"
#include <math.h>

@implementation Mat4

- (id) init {
    self = [super init];
    if(self != nil) {
        mat = (GLfloat *)malloc(sizeof(GLfloat) * 16);
    }
    return self;
}

- (void) dealloc {
    if(mat != NULL) {
        free(mat);
    }
}

- (void) identity {
    for(int i=0;i<16;i++) {
        if((i%5) == 0) {
            mat[i] = 1.0;
        } else {
            mat[i] = 0.0;
        }
    }
}

- (NSString *) toString {
    NSMutableString *theString = [[NSMutableString alloc] init];
    for(int i=0;i<16;i++) {
        if(i > 0 && (0 == i%4)) {
            [theString appendString: @"\n"];
        }
        [theString appendString:[NSString stringWithFormat:@"%f ", mat[i]]];
    }
    return [NSString stringWithString:theString];
}

- (GLfloat *) floats {
    return mat;
}

- (Mat4*) clone {
    Mat4 *retval = [[Mat4 alloc] init];
    for(int i=0;i<16;i++) {
        retval.floats[i] = mat[i];
    }
    return retval;
}

- (void) transpose {
    GLfloat a01 = mat[1], a02 = mat[2], a03 = mat[3],
            a12 = mat[6], a13 = mat[7], a23 = mat[11];

    mat[1] = mat[4];
    mat[2] = mat[8];
    mat[3] = mat[12];
    mat[4] = a01;
    mat[6] = mat[9];
    mat[7] = mat[13];
    mat[8] = a02;
    mat[9] = a12;
    mat[11] = mat[14];
    mat[12] = a03;
    mat[13] = a13;
    mat[14] = a23;
}

- (id) initFromFloats: (GLfloat *) arr {
    self = [self init];
    if(self) {
        for(int i=0;i<16;i++) {
            mat[i] = arr[i];
        }
    }
    return self;
}

- (BOOL) equals: (Mat4*) other {
    for(int i=0;i<16;i++) {
        if(mat[i] != other.floats[i]) {
            return NO;
        }
    }
    return YES;
}

- (void) translate: (GLfloat *)v {
    GLfloat x=v[0], y=v[1], z=v[2];
    mat[0] += mat[3] * x;
    mat[1] += mat[3] * y;
    mat[2] += mat[3] * z;
    
    mat[4] += mat[7] * x;
    mat[5] += mat[7] * y;
    mat[6] += mat[7] * z;

    mat[8] += mat[11] * x;
    mat[9] += mat[11] * y;
    mat[10] += mat[11] * z;

    mat[12] += mat[15] * x;
    mat[13] += mat[15] * y;
    mat[14] += mat[15] * z;
}

- (void) translateX: (GLfloat) x
                  Y: (GLfloat) y
                  Z: (GLfloat) z {
    GLfloat v[3] = {x, y, z};
    [self translate: v];
}

- (void) rotate: (GLfloat) rad
           axis: (GLfloat *) axis {
    GLfloat x = axis[0],
            y = axis[1],
            z = axis[2];
    GLfloat len = sqrtf(x*x + y*y + z*z);
    GLfloat s, c, t;
    GLfloat a00, a01, a02, a03,
            a10, a11, a12, a13,
            a20, a21, a22, a23,
            b00, b01, b02,
            b10, b11, b12,
            b20, b21, b22;
    GLfloat *a = mat;

    if (fabs(len) < FLT_EPSILON) {
        // Don't do anything, there's no rotation
        return;
    }

    len = 1 / len;
    x *= len;
    y *= len;
    z *= len;

    s = sinf(rad);
    c = cosf(rad);
    t = 1 - c;

    a00 = a[0]; a01 = a[1]; a02 =  a[2]; a03 =  a[3];
    a10 = a[4]; a11 = a[5]; a12 =  a[6]; a13 =  a[7];
    a20 = a[8]; a21 = a[9]; a22 = a[10]; a23 = a[11];

    b00 = x * x * t + c;
    b01 = y * x * t + z * s;
    b02 = z * x * t - y * s;
    b10 = x * y * t - z * s;
    b11 = y * y * t + c;
    b12 = z * y * t + x * s;
    b20 = x * z * t + y * s;
    b21 = y * z * t - x * s;
    b22 = z * z * t + c;

    // Perform rotation-specific matrix multiplication
    a[0]  = a00 * b00 + a10 * b01 + a20 * b02;
    a[1]  = a01 * b00 + a11 * b01 + a21 * b02;
    a[2]  = a02 * b00 + a12 * b01 + a22 * b02;
    a[3]  = a03 * b00 + a13 * b01 + a23 * b02;
    a[4]  = a00 * b10 + a10 * b11 + a20 * b12;
    a[5]  = a01 * b10 + a11 * b11 + a21 * b12;
    a[6]  = a02 * b10 + a12 * b11 + a22 * b12;
    a[7]  = a03 * b10 + a13 * b11 + a23 * b12;
    a[8]  = a00 * b20 + a10 * b21 + a20 * b22;
    a[9]  = a01 * b20 + a11 * b21 + a21 * b22;
    a[10] = a02 * b20 + a12 * b21 + a22 * b22;
    a[11] = a03 * b20 + a13 * b21 + a23 * b22;

}


- (BOOL) nearEqual: (Mat4*) other {
    GLfloat *o = other.floats;
    for(int i=0;i<16;i++) {
        if(fabs(o[i] - mat[i]) > FLT_EPSILON) {
            return NO;
        }
    }
    return YES;
}

- (void) perspective: (GLfloat) fovy 
              aspect: (GLfloat) aspect 
                near: (GLfloat) near 
                 far: (GLfloat) far {
    GLfloat f = 1.0 / tanf(fovy / 2.);
    GLfloat nf = 1.0 / (near - far);

    mat[0] = f / aspect;
    mat[1] = 0;
    mat[2] = 0;
    mat[3] = 0;
    mat[4] = 0;
    mat[5] = f;
    mat[6] = 0;
    mat[7] = 0;
    mat[8] = 0;
    mat[9] = 0;
    mat[10] = (far + near) * nf;
    mat[11] = -1;
    mat[12] = 0;
    mat[13] = 0;
    mat[14] = (2 * far * near) * nf;
    mat[15] = 0;
}

- (void) dot: (Mat4*) other {
    GLfloat t[16];
    GLfloat *o = other.floats;
    memcpy(t, mat, sizeof(GLfloat) * 16);
    mat[0] = t[0] * o[0] + t[1] * o[4] + t[2] * o[8]  + t[3] * o[12];
    mat[1] = t[0] * o[1] + t[1] * o[5] + t[2] * o[9]  + t[3] * o[13];
    mat[2] = t[0] * o[2] + t[1] * o[6] + t[2] * o[10] + t[3] * o[14];
    mat[3] = t[0] * o[3] + t[1] * o[7] + t[2] * o[11] + t[3] * o[15];

    mat[4] = t[4] * o[0] + t[5] * o[4] + t[6] * o[8]  + t[7] * o[12];
    mat[5] = t[4] * o[1] + t[5] * o[5] + t[6] * o[9]  + t[7] * o[13];
    mat[6] = t[4] * o[2] + t[5] * o[6] + t[6] * o[10] + t[7] * o[14];
    mat[7] = t[4] * o[3] + t[5] * o[7] + t[6] * o[11] + t[7] * o[15];
    
    mat[8]  = t[8] * o[0] + t[9] * o[4] + t[10] * o[8]  + t[11] * o[12];
    mat[9]  = t[8] * o[1] + t[9] * o[5] + t[10] * o[9]  + t[11] * o[13];
    mat[10] = t[8] * o[2] + t[9] * o[6] + t[10] * o[10] + t[11] * o[14];
    mat[11] = t[8] * o[3] + t[9] * o[7] + t[10] * o[11] + t[11] * o[15];
    
    mat[12] = t[12] * o[0] + t[13] * o[4] + t[14] * o[8]  + t[15] * o[12];
    mat[13] = t[12] * o[1] + t[13] * o[5] + t[14] * o[9]  + t[15] * o[13];
    mat[14] = t[12] * o[2] + t[13] * o[6] + t[14] * o[10] + t[15] * o[14];
    mat[15] = t[12] * o[3] + t[13] * o[7] + t[14] * o[11] + t[15] * o[15];

}


@end
