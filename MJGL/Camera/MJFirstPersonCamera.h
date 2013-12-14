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
#import "MJAbstract3DCamera.h"

/**
 * Represents a first person camera.
 * Suitable for observing a particular direction in the 3D world.
 */
@interface MJFirstPersonCamera : MJAbstract3DCamera

/** The yaw camera rotation angle in radians. (Turns left or right.) */
@property(nonatomic, assign) float yaw;

/** The pitch camera rotation angle in radians. (Turns up or down.) */
@property(nonatomic, assign) float pitch;

/** the roll camera rotation angle in radians. (Rolls around forward axis.) */
@property(nonatomic, assign) float roll;

/** The forward axis vector of the camera. The camera faces this direction. */
@property(nonatomic, readonly) GLKVector3 forward;

/** The position of the camera in the 3D world. */
@property(nonatomic, assign) GLKVector3 position;

/**
 * Set camera rotation angles.
 *
 * @param yawAngle The yaw camera rotation angle in radians.
 * @param pitchAngle The pitch camera rotation angle in radians.
 * @param rollAngle The roll camera rotation angle in radians.
 */
- (void)setYaw:(float)yawAngle pitch:(float)pitchAngle roll:(float)rollAngle;

@end
