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

#import "MJAbstract3DCamera.h"

@implementation MJAbstract3DCamera

- (id)init
{
    self = [super init];
	if (self)
	{
        _projectionMatrix = GLKMatrix4Identity;
		_dirtyProjection = NO;
	}
		
	return self;
}

- (void)setFov:(float)fov
   aspectRatio:(float)aspectRatio
          near:(float)near
           far:(float)far
{
	_fov = fov;
	_aspectRatio = aspectRatio;
	_near = near;
	_far = far;
	_dirtyProjection = YES;
}

- (float)getFov
{
	return _fov;
}

- (void)setFov:(float)angle
{
	_fov = angle;
	_dirtyProjection = YES;
}

- (float)getAspectRatio
{
	return _aspectRatio;
}

- (void)setAspectRatio:(float)ratio
{
	_aspectRatio = ratio;
	_dirtyProjection = YES;
}

- (float)getNear
{
	return _near;
}

- (void)setNear:(float)value
{
	_near = value;
	_dirtyProjection = YES;
}

- (void)setFar:(float)value
{
	_far = value;
	_dirtyProjection = YES;
}

- (void)updateProjection
{
    _projectionMatrix = GLKMatrix4MakePerspective(_fov, _aspectRatio, _near, _far);
	_dirtyProjection = NO;
}

- (GLKMatrix4)projectionMatrix
{
	if (_dirtyProjection)
	{
		[self updateProjection];
	}
	return _projectionMatrix;
}

- (GLKMatrix4)viewMatrix
{
	[NSException raise:@"Abstract Class Exception" format:@"Error, attempting to use MJAbstract3DCamera directly."];
	return GLKMatrix4Identity;
}

@end
