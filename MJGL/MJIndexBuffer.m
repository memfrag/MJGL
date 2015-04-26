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

#if !__has_feature(objc_arc)
#error ARC must be enabled!
#endif

#import "MJIndexBuffer.h"

@implementation MJIndexBuffer {
	unsigned int _bufferId;
}

- (id)initWithCapacity:(unsigned int)indexCount
               indices:(const GLushort *)indices
{
    self = [super init];
	if (self)
	{
		_bufferId = GL_INVALID_VALUE;
        _count = indexCount;
		
		glGenBuffers(1, &_bufferId);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _bufferId);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, indexCount * sizeof(GLushort),
                     indices, GL_STATIC_DRAW);
	}
	
	return self;
}

- (void)dealloc
{
    glDeleteBuffers(1, &_bufferId);
	_bufferId = GL_INVALID_VALUE;
}

- (void)bind
{
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _bufferId);
}

@end
