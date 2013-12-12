//
//  Mat4.m
//  Golden Triangle
//
//  Created by Lucas Campbell on 12/10/13.
//  Copyright (c) 2013 Lucas Campbell. All rights reserved.
//

#import "Mat4.h"

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

- (void) perspective: (GLfloat) fovy aspect: (GLfloat) aspect near: (GLfloat) near far: (GLfloat) far {
    GLfloat f = 1.0 / tan(fovy / 2.0);
    GLfloat nf = 1.0 / (near - far);

    for(int i=0;i<16;i++) {
        mat[i] = 0.0;
    }


    mat[0] = f / aspect;
    mat[5] = f;
    mat[10] = (far + near) * nf;
    mat[11] = -1;
    mat[14] = (2 * far * near) * nf;

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

- (void) rotateX: (GLfloat) rad {
    GLfloat t[8] = {
        mat[4], mat[5] , mat[6] , mat[7] ,
        mat[8], mat[9], mat[10], mat[11]
    };
    GLfloat c = cosf(rad);
    GLfloat s = sinf(rad);

    mat[4] = t[0] * c + t[4] * s;
    mat[5] = t[1] * c + t[5] * s;
    mat[6] = t[2] * c + t[6] * s;
    mat[7] = t[3] * c + t[7] * s;
    mat[8]  = t[4] * c - t[0] * s;
    mat[9] = t[5] * c - t[1] * s;
    mat[10] = t[6] * c - t[2] * s;
    mat[11] = t[7] * c - t[3] * s;
}

- (void) rotateXdeg: (GLfloat) deg {
    GLfloat rad = deg * M_PI / 180.;
    [self rotateX: rad];
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


@end
