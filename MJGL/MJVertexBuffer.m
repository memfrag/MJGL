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

#import "MJVertexBuffer.h"

@interface MJVertexBuffer ()
@property (nonatomic, strong) MJVertexDeclaration *vertexDeclaration;
@end

@implementation MJVertexBuffer {
    GLuint _bufferId;
    uint32_t _arrayObjectId;
}

#pragma mark - Initializing/destroying the vertex buffer

- (id)initWithCapacity:(NSUInteger)vertexCount
                 usage:(MJVertexBufferUsagePattern)usagePattern
           declaration:(MJVertexDeclaration *)vertexDeclaration
{
    return [self initWithCapacity:vertexCount
                            usage:usagePattern
                      declaration:vertexDeclaration
                         vertices:(const void *)0];
}

- (id)initWithCapacity:(NSUInteger)vertexCount
                 usage:(MJVertexBufferUsagePattern)usagePattern
           declaration:(MJVertexDeclaration *)vertexDeclaration
              vertices:(const void *)vertices
{
    self = [super init];
	if (self)
	{
        _drawMode = MJVertexDrawModeTriangles; // Default draw mode
		self.vertexDeclaration = vertexDeclaration;
		_count = vertexCount;
		_stride = vertexDeclaration.stride;
		_bufferId = GL_INVALID_VALUE;
		
        glGenVertexArraysMJ(1, &_arrayObjectId);
        glBindVertexArrayMJ(_arrayObjectId);
        
		glGenBuffers(1, &_bufferId);
		glBindBuffer(GL_ARRAY_BUFFER, _bufferId);
		
        [self.vertexDeclaration apply];
        
        glBufferData(GL_ARRAY_BUFFER, _count * _stride, vertices,
                     (GLenum)usagePattern);
        
        // Bind back to default state
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindVertexArrayMJ(0);
	}
	
	return self;
}

- (void)dealloc
{
    glDeleteVertexArraysMJ(1, &_arrayObjectId);
	glDeleteBuffers(1, &_bufferId);
	_bufferId = GL_INVALID_VALUE;
}

#pragma mark - Modifying the vertex buffer

- (void)setVerticesAtOffset:(NSUInteger)offset
                      count:(NSUInteger)vertexCount
                   vertices:(const void *)vertices
{
	glBindBuffer(GL_ARRAY_BUFFER, _bufferId);
	glBufferSubData(GL_ARRAY_BUFFER, offset * _stride, vertexCount * _stride,
                    vertices);
}

#pragma mark - Drawing

- (void)drawWithFirstVertexAtIndex:(NSUInteger)firstIndex
                             count:(NSUInteger)vertexCount
{
    glBindVertexArrayMJ(_arrayObjectId);
	glBindBuffer(GL_ARRAY_BUFFER, _bufferId);
    GLenum drawMode = [self drawModeAsGLConstant];
	glDrawArrays(drawMode, (GLint)firstIndex, (GLint)vertexCount);
    glBindVertexArrayMJ(0);
}

- (void)drawWithIndexBuffer:(MJIndexBuffer *)indexBuffer
{
    [self drawWithFirstVertexAtIndex:0 count:indexBuffer.count indexBuffer:indexBuffer];
}

- (void)drawWithFirstVertexAtIndex:(NSUInteger)firstIndex
                             count:(NSUInteger)vertexCount
                       indexBuffer:(MJIndexBuffer *)indexBuffer
{
    glBindVertexArrayMJ(_arrayObjectId);
	glBindBuffer(GL_ARRAY_BUFFER, _bufferId);
    [indexBuffer bind];
    GLenum drawMode = [self drawModeAsGLConstant];
	glDrawElements(drawMode, (GLint)vertexCount, GL_UNSIGNED_SHORT,
				   (GLvoid *)(firstIndex * sizeof(GLushort)));
    glBindVertexArrayMJ(0);
}

- (void)draw
{
    glBindVertexArrayMJ(_arrayObjectId);
	glBindBuffer(GL_ARRAY_BUFFER, _bufferId);
    GLenum drawMode = [self drawModeAsGLConstant];
	glDrawArrays(drawMode, 0, (GLsizei)_count);
    glBindVertexArrayMJ(0);
}

#pragma mark - Utility methods

- (GLenum)drawModeAsGLConstant
{
    GLenum mode;
    
    switch (_drawMode)
    {
        case MJVertexDrawModeTriangles: mode = GL_TRIANGLES; break;
        case MJVertexDrawModeTriangleStrip: mode = GL_TRIANGLE_STRIP; break;
        case MJVertexDrawModeTriangleFan: mode = GL_TRIANGLE_FAN; break;
        case MJVertexDrawModeLines: mode = GL_LINES; break;
        case MJVertexDrawModeLineLoop: mode = GL_LINE_LOOP; break;
        default: mode = GL_TRIANGLES; break;
    }
    
    return mode;
}

@end
