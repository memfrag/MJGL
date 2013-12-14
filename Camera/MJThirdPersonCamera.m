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

#import "MJThirdPersonCamera.h"

@implementation MJThirdPersonCamera {
	GLKMatrix4 _viewMatrix;
	BOOL _dirtyView;
}

@synthesize target = _target;
@synthesize position = _position;
@synthesize up = _up;

- (id)init
{
    self = [super init];
	if (self) {
		_viewMatrix = GLKMatrix4Identity;
		_target = GLKVector3Make(0.0f, 0.0f, -1.0f);
		_position = GLKVector3Make(0.0f, 0.0f, 0.0f);
		_up = GLKVector3Make(0.0, 1.0f, 0.0);
		_dirtyView = NO;
	}
	
	return self;
}

- (GLKMatrix4)viewMatrix
{
	if (_dirtyView) {
        _viewMatrix = GLKMatrix4MakeLookAt(_position.x, _position.y, _position.z,
                                           _target.x, _target.y, _target.z,
                                           _up.x, _up.y, _up.z);
        _dirtyView = NO;
	}
	return _viewMatrix;
}

- (GLKVector3)position
{
	return _position;
}

- (void)setPosition:(GLKVector3)positionVector
{
	_position = positionVector;
	_dirtyView = YES;
}

- (GLKVector3)target
{
	return _target;
}

- (void)setTarget:(GLKVector3)targetVector
{
	_target = targetVector;
	_dirtyView = YES;
}

- (GLKVector3)up
{
	return _up;
}

- (void)setUp:(GLKVector3)upVector
{
	_up = upVector;
	_dirtyView = YES;
}

@end
