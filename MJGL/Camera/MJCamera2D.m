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

#import "MJCamera2D.h"

@implementation MJCamera2D {
    float _width;
    float _height;
    CGSize _extents;
    BOOL _dirtyProjectionMatrix;
    GLKMatrix4 _projectionMatrix;
    BOOL _dirtyViewMatrix;
}

@synthesize viewMatrix = _viewMatrix;

- (id)initWithWidth:(NSUInteger)width height:(NSUInteger)height
{
    self = [super init];
	if (self) {
        _width = width;
        _height = height;
        _yAxisPositiveUp = NO;
        
        _extents = CGSizeMake(width, height);
        _position = GLKVector2Make(0.0f, 0.0f);
        
        _dirtyProjectionMatrix = YES;
        _projectionMatrix = GLKMatrix4Identity;
        _dirtyViewMatrix = YES;
        _viewMatrix = GLKMatrix4Identity;
    }
    
	return self;
}

- (GLKMatrix4)viewMatrix
{
    if (_dirtyViewMatrix) {
        _viewMatrix = GLKMatrix4Translate(_viewMatrix,
                                          _position.x, _position.y, 0.0f);
        if (_yAxisPositiveUp) _viewMatrix.m22 = -_viewMatrix.m22;
        _dirtyViewMatrix = NO;
    }
	
    return _viewMatrix;
}

- (GLKMatrix4)projectionMatrix
{
	if (_dirtyProjectionMatrix) {
        _projectionMatrix = GLKMatrix4MakeOrtho(-_extents.width * 0.5f,
                                                _extents.width * 0.5f,
                                                -_extents.height * 0.5f,
                                                _extents.height * 0.5f,
                                                -1.0f, 1.0f);
	}
    
	return _projectionMatrix;
}

- (void)setPosition:(GLKVector2)newPosition
{
	if (!GLKVector2AllEqualToVector2(_position, newPosition)) {
		_position = newPosition;
        _dirtyViewMatrix = YES;
	}
}

- (void)setYAxisPositiveUp:(BOOL)positiveUp
{
    if (_yAxisPositiveUp != positiveUp)
    {
        _yAxisPositiveUp = positiveUp;
        _dirtyViewMatrix = YES;
    }
}

- (CGRect)frame
{
    return CGRectMake(_position.x, _position.y, _extents.width, _extents.height);
}

@end
