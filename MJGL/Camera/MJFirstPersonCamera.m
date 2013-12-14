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

#import "MJFirstPersonCamera.h"

static const GLKVector3 referenceVector = {0.0, 0.0, 1.0f};
static const GLKVector3 up = {0.0, 1.0f, 0.0};

@implementation MJFirstPersonCamera {
	BOOL _dirtyView;
	GLKMatrix4 _rotationMatrix;
	GLKMatrix4 _viewMatrix;
}

- (id)init
{
    self = [super init];
	if (self)
	{
		_yaw = 0;
		_pitch = 0;
		_roll = 0;
		_viewMatrix = GLKMatrix4Identity;
		_rotationMatrix = GLKMatrix4Identity;
		_forward = referenceVector;
		_position = GLKVector3Make(0.0f, 0.0f, 0.0f);
		_dirtyView = NO;
	}
	
	return self;
}

- (GLKQuaternion)quaternionFromYaw:(float)yaw pitch:(float)pitch roll:(float)roll
{
    float n9 = roll * 0.5f;
    float n6 = (float)sin((double)n9);
    float n5 = (float)cos((double)n9);
    float n8 = pitch * 0.5f;
    float n4 = (float)sin((double)n8);
    float n3 = (float)cos((double)n8);
    float n7 = yaw * 0.5f;
    float n2 = (float)sin((double)n7);
    float n = (float)cos((double)n7);
    GLKQuaternion quaternion;
    quaternion.x = ((n * n4) * n5) + ((n2 * n3) * n6);
    quaternion.y = ((n2 * n3) * n5) - ((n * n4) * n6);
    quaternion.z = ((n * n3) * n6) - ((n2 * n4) * n5);
    quaternion.w = ((n * n3) * n5) + ((n2 * n4) * n6);
    return quaternion;
}

- (void)updateView
{
	GLKQuaternion quaternion;
	quaternion = [self quaternionFromYaw:_yaw pitch:_pitch roll:_roll];
	
    _forward = GLKQuaternionRotateVector3(quaternion, referenceVector);
	GLKVector3 target = GLKVector3Add(_position, _forward);
	
    _viewMatrix = GLKMatrix4MakeLookAt(_position.x, _position.y, _position.z,
                                       target.x, target.y, target.z,
                                       up.x, up.y, up.z);
		
	_dirtyView = NO;
}

- (GLKMatrix4)viewMatrix
{
	if (_dirtyView) {
		[self updateView];
	}
	return _viewMatrix;
}

- (void)setYaw:(float)yawAngle pitch:(float)pitchAngle roll:(float)rollAngle
{
	_yaw = yawAngle;
	_pitch = pitchAngle;
	_roll = rollAngle;
	_dirtyView = YES;
}

- (float)getYaw
{
	return _yaw;
}

- (void)setYaw:(float)angle
{
	_yaw = angle;
	_dirtyView = YES;
}

- (float)getPitch
{
	return _pitch;
}

- (void)setPitch:(float)angle
{
	_pitch = angle;
	_dirtyView = YES;
}

- (float)getRoll
{
	return _roll;
}

- (void)setRoll:(float)angle
{
	_roll = angle;
	_dirtyView = YES;
}

- (GLKVector3)getPosition
{
	return _position;
}

- (void)setPosition:(GLKVector3)positionVector
{
	_position = positionVector;
	_dirtyView = YES;
}

@end
