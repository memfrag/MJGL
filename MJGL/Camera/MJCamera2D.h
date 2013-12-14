//
//  Copyright (c) 2013 Martin Johannesson
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//
//  (MIT License)
//

#import <Foundation/Foundation.h>
#import "MJCamera.h"

/**
 * Camera with orthographic projection for use with 2D scenes and overlays.
 */
@interface MJCamera2D : NSObject <MJCamera>

/** Position of the upper left corner of the camera frame in the 2D world. */
@property(nonatomic, assign) GLKVector2 position;

/** Position and dimensions of the camera frame in the 2D world. */
@property(nonatomic, readonly) CGRect frame;

/**
 * Indicates whether the Y axis is positive in the up screen direction.
 *
 * Default value is NO.
 */
@property(nonatomic, assign) BOOL yAxisPositiveUp;

/**
 * Initialize the camera object and set the width and height of the frame.
 *
 * @param width Width of the camera frame in the 2D world.
 * @param height Height of the camera frame in the 2D world.
 */
- (id)initWithWidth:(NSUInteger)width height:(NSUInteger)height;

@end
