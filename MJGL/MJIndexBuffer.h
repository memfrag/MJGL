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

#import "MJGL.h"

/**
 * The MJIndexBuffer object wraps a number of OpenGL calls for creating
 * "index buffer objects" (IBOs). An IBO is a memory buffer, controlled by
 * the OpenGL driver, where index data is stored. This allows the OpenGL
 * driver to store index data in a suitable area, such as video memory.
 *
 * Each index in the buffer points to a particular vertex in a vertex
 * buffer. It allows for reuse of vertices without storing several
 * instances of the same vertex.
 */
@interface MJIndexBuffer : NSObject

/** The number of indices in the buffer. */
@property (nonatomic, readonly) NSUInteger count;

/**
 * Initialize the index buffer and copy index data to it.
 *
 * @param indexCount The number of indices to store in the index buffer.
 *
 * @param indices Pointer to an array of indices.
 */
- (id)initWithCapacity:(unsigned int)indexCount
               indices:(const GLshort *)indices;

/**
 * Bind the index buffer to the OpenGL context as the current index buffer.
 *
 * This method is only necessary to call if the index buffer is not used
 * in conjunction with the draw call of the MJVertexBuffer object.
 */
- (void)bind;

@end
