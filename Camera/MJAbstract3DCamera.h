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
 * Abstract base class for 3D cameras. DO NOT INSTANTIATE DIRECTLY!
 */
@interface MJAbstract3DCamera : NSObject <MJCamera> {
@protected
	BOOL _dirtyProjection;
	GLKMatrix4 _projectionMatrix;
}

/** Camera field of view angle in radians. */
@property(nonatomic, assign) float fov;

/** The aspect ratio of the camera. Adjust when viewport dimensions change. */
@property(nonatomic, assign) float aspectRatio;

/** Distance to the near plane of the camera frustum from the view point. */
@property(nonatomic, assign) float near;

/** Distance to the far plane of the camera frustum from the view point. */
@property(nonatomic, assign) float far;

/**
 * Sets parameters that are used for calculating the projection matrix.
 *
 * @param fov The angle of the camera field of view in radians.
 * @param aspectRatio The aspect ratio of the viewport.
 * @param near Distance to the near plane from the camera position.
 * @param far Distance to the far plane from the camera position.
 */
- (void)setFov:(float)fov
   aspectRatio:(float)aspectRatio
          near:(float)near
           far:(float)far;

@end
