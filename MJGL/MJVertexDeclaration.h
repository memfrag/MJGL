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
 * The MJVertexDeclaration object wraps OpenGL calls for defining the structure
 * of a vertex. Each vertex consists of a number of components.
 *
 * When a vertex buffer is about to be rendered, it applies the vertex
 * declaration so that the rendering pipeline knows how to interpret
 * the vertex data.
 */
@interface MJVertexDeclaration : NSObject

/**
 * The stride, or size in bytes, of an individual vertex.
 */
@property (nonatomic, readonly) NSUInteger stride;

/**
 * Apply the vertex declaration so that the rendering pipeline knows
 * how to interpret the vertex data in the vertex buffer.
 */
- (void)apply;

/**
 * Add a floating point component. The component may consist of one
 * or more floats. For example, the position vector component in 3D space
 * would consist of three floats.
 *
 * @param The number of floats in the component.
 */
- (void)addFloatComponentOfCount:(GLint)count;

/**
 * Add an unsigned byte component, usually an RGB(A) color.
 *
 * @param The number of unsigned bytes in the component.
 */
- (void)addUnsignedByteComponentOfCount:(GLint)count;

/**
 * Add a normalized unsigned byte component.
 *
 * @param The number of normalized unsigned bytes in the component.
 */
- (void)addNormalizedUnsignedByteComponentOfCount:(GLint)count;

/**
 * Add a normalized unsigned short component.
 *
 * @param The number of normalized unsigned shorts in the component.
 */
- (void)addNormalizedUnsignedShortComponentOfCount:(GLint)count;

@end
