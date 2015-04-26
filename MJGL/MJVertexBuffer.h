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
#import "MJVertexDeclaration.h"
#import "MJIndexBuffer.h"

#pragma mark - Type Definitions

/**
 * The draw mode specifies how a sequence of vertices is to be interpreted
 * as geometric primitives when the vertex buffer is drawn.
 */
typedef enum MJVertexDrawMode
{
    /** The vertices will be interpreted as separate triangles. */
    MJVertexDrawModeTriangles = 0,
    
    /**
     * The vertices will be interpreted as a connected strip of triangles,
     * where each triangle shares two vertices with the one before it.
     */
    MJVertexDrawModeTriangleStrip,
    
    /**
     * The vertices will be interpreted as a fan where each triangle shares
     * one common vertex with all triangles and one vertex with the previous
     * triangle.
     */
    MJVertexDrawModeTriangleFan,
    
    /**
     * Interprets each pair of vertices as an independent line segment.
     */
    MJVertexDrawModeLines,
    
    /**
     * Interprets each vertex as the endpoint of a line, connected to
     * the previous vertex.
     */
    MJVertexDrawModeLineLoop
} MJVertexDrawMode;

/**
 * The usage pattern specifies how dynamic the vertex data is intended to be.
 */
typedef enum MJVertexBufferUsagePattern
{
    /**
     * MJVertexBufferStatic should be used for vertex data that is only
     * specified once and won't change.
     */
    MJVertexBufferStatic = GL_STATIC_DRAW,
    
    /**
     * MJVertexBufferChangesSometimes should be used for vertex data that may
     * change during rendering loop.
     */
    MJVertexBufferChangesSometimes = GL_DYNAMIC_DRAW,
    
    /**
     * MJVertexBufferChangesEveryFrame should be used for transient gemoetry
     * that is rendered a small number of times and then discarded. It is
     * common to create two vertex buffers so that one buffer can be filled
     * with data while the other is being rendered.
     */
    MJVertexBufferChangesEveryFrame = GL_STREAM_DRAW
} MJVertexBufferUsagePattern;


#pragma mark - MJVertexBuffer Interface

/**
 * The MJVertexBuffer object wraps a number of OpenGL calls for creating
 * "vertex buffer objects" (VBOs). A VBO is a memory buffer, controlled by
 * the OpenGL driver, where vertex data is stored. This allows the OpenGL
 * driver to store vertex data in a suitable area, such as video memory.
 */
@interface MJVertexBuffer : NSObject

/** The number of vertices in the buffer. */
@property (nonatomic, readonly) NSUInteger count;

/** The stride, or size, in bytes, of an individual vertex. */
@property (nonatomic, readonly) NSUInteger stride;

/**
 * The mode the vertex buffer will be drawn in. It specifies how the
 * geometry defined by the vertices will be interpreted. The default is
 * to interpret the vertices as a sequence of separate triangles.
 */
@property (nonatomic, assign) MJVertexDrawMode drawMode;

/**
 * Initialize an empty vertex buffer with room for a number of vertices.
 *
 * @param vertexCount The number of vertices that will fit in the buffer.
 *
 * @param usagePattern Specifies how the buffer will be used, which
 *                     allows for the OpenGL driver to allocate a buffer
 *                     that is suitable for that purpose.
 *
 * @param vertexDeclaration Declaration of how the individual vertices
 *                          in the buffer are structured.
 *
 * @return The vertex buffer or nil if it could not be created.
 */
- (id)initWithCapacity:(NSUInteger)vertexCount
                 usage:(MJVertexBufferUsagePattern)usagePattern
           declaration:(MJVertexDeclaration *)vertexDeclaration;

/**
 * Initialize a vertex buffer and fill it with vertex data.
 *
 * @param vertexCount The number of vertices that will fit in the buffer.
 *
 * @param usagePattern Specifies how the buffer will be used, which
 *                     allows for the OpenGL driver to allocate a buffer
 *                     that is suitable for that purpose.
 *
 * @param vertexDeclaration Declaration of how the individual vertices
 *                          in the buffer are structured.
 *
 * @param vertices A pointer to the vertex data to fill the buffer with.
 *
 * @return The vertex buffer or nil if it could not be created.
 */
- (id)initWithCapacity:(NSUInteger)vertexCount
                 usage:(MJVertexBufferUsagePattern)usagePattern
           declaration:(MJVertexDeclaration *)vertexDeclaration
              vertices:(const void *)vertices;

- (void)setVerticesAtOffset:(NSUInteger)offset
                      count:(NSUInteger)vertexCount
                   vertices:(const void *)vertices;

/**
 * Draw the geometry defined by the vertices, interpreted according to
 * the draw mode specified by the drawMode property.
 */
- (void)draw;

/**
 * Draw the geometry defined by the specified range of vertices, interpreted
 * according to the draw mode specified by the drawMode property.
 */
- (void)drawWithFirstVertexAtIndex:(NSUInteger)firstIndex
                             count:(NSUInteger)vertexCount;

/**
 * Draw the geometry indirectly defined by the index buffer where each index
 * points to a vertex in the specified range of vertices, interpreted
 * according to the draw mode specified by the drawMode property.
 */
- (void)drawWithIndexBuffer:(MJIndexBuffer *)indexBuffer;

/**
 * Draw the geometry indirectly defined by the index buffer where each index
 * points to a vertex in the specified range of vertices, interpreted
 * according to the draw mode specified by the drawMode property.
 */
- (void)drawWithFirstVertexAtIndex:(NSUInteger)firstIndex
                             count:(NSUInteger)vertexCount
                       indexBuffer:(MJIndexBuffer *)indexBuffer;

@end
