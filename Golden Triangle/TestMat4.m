//
//  TestMat4.m
//  Golden Triangle
//
//  Created by Lucas Campbell on 12/10/13.
//  Copyright (c) 2013 Lucas Campbell. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Mat4.h"

@interface TestMat4 : XCTestCase

@end

@implementation TestMat4

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    Mat4 *mat = [[Mat4 alloc] init];
    [mat identity];
    NSLog(@"\n%@", [mat toString]);
}

- (void) testIdentity
{
    Mat4 *mat = [[Mat4 alloc] init];
    [mat identity];
    GLfloat arr[] = {
        1., 0., 0., 0.,
        0., 1., 0., 0.,
        0., 0., 1., 0.,
        0., 0., 0., 1. };
    GLfloat *floats = mat.floats;
    for(int i=0;i<16;i++) {
        XCTAssertEqual(arr[i], floats[i], @"Value Comparison");
    }
}

- (void) testClone {
    Mat4 *first = [[Mat4 alloc] init];
    [first identity];
    first.floats[2] = 3;

    Mat4 *second = [first clone];
    XCTAssertEqual(first.floats[2], second.floats[2]);
    XCTAssertEqual(first.floats[2], (GLfloat)3.0);
}

- (void) testTranspose {
    GLfloat vec[] = {
         0.,  1.,  2.,  3.,
         4.,  5.,  6.,  7.,
         8.,  9., 10., 11.,
        12., 13., 14., 15.
    };

    GLfloat vec_t[] = {
        0., 4.,  8., 12.,
        1., 5.,  9., 13.,
        2., 6., 10., 14.,
        3., 7., 11., 15.
    };

    Mat4 *a = [[Mat4 alloc] initFromFloats: vec];
    Mat4 *b = [[Mat4 alloc] initFromFloats: vec_t];

    [a transpose];
    XCTAssert([a equals: b]);
}

- (void) testTranslate {
    GLfloat correct[] = {
        1., 0., 0., 0.,
        0., 1., 0., 0.,
        0., 0., 1., 0.,
        5., 6., 7., 1.
    };
    GLfloat vec[] = {5., 6., 7.};

    Mat4 *a = [[Mat4 alloc] init];
    [a identity];
    [a translate: vec];
    Mat4 *correct_mat = [[Mat4 alloc] initFromFloats: correct];
    XCTAssert([a equals: correct_mat]);

    GLfloat correct_T[] = {
        1., 0., 0., 5.,
        0., 1., 0., 6.,
        0., 0., 1., 7.,
        0., 0., 0., 1.
    };

    correct_mat = [[Mat4 alloc] initFromFloats: correct_T];
    [correct_mat transpose];
    XCTAssert([a equals: correct_mat]);

}

- (void) testRotation {
    Mat4 *a = [[Mat4 alloc] init];
    GLfloat v[] = {2., 1., 1.};
    GLfloat corr[] = {
        1.,  0.,  0., 0.,
        0., -1.,  0., 0.,
        0.,  0., -1., 0.,
        2.,  1.,  1., 1.
    };
    Mat4 *corr_mat = [[Mat4 alloc] initFromFloats: corr];
    [a identity];
    [a translate: v];
    [a rotateX: (GLfloat)M_PI];
    XCTAssert([a nearEqual: corr_mat]);

}

- (void) testPerspective {
    Mat4 *a = [[Mat4 alloc] init];
    GLfloat corr[] = {
        2.4142136573791504, 0, 0, 0, 
        0, 2.4142136573791504, 0, 0, 
        0, 0, -1.0020020008087158, -1, 
        0, 0, -0.20020020008087158, 0
    };

    [a perspective: 45.0
            aspect: 1.0
              near: 0.1
               far: 100.0 ];
    Mat4 *comp = [[Mat4 alloc] initFromFloats: corr];
    NSLog(@"%@", [comp toString]);
    NSLog(@"%@", [a toString]);

    //XCTAssert([a nearEqual: [[Mat4 alloc] initFromFloats: corr]]);
}



@end
