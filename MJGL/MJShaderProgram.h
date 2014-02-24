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
#import "MJGL.h"

/** Write shaders with partial syntax coloring right in your code. */
#if !TARGET_OS_IPHONE
#define SHADER_STRING(x) @"#version 150\n" #x
#else
#define SHADER_STRING(x) @ #x
#endif

/** The shader program error domain string. */
extern NSString * const MJShaderProgramErrorDomain;

/** The shader program vertex shader could not be compiled. */
#define kMJShaderProgramErrorCompilingVertexShader 1

/** The shader program fragment shader could not be compiled. */
#define kMJShaderProgramErrorCompilingFragmentShader 2

/** The shader program could not be linked, after shader compilation. */
#define kMJShaderProgramErrorLinkingShaderProgram 3

@interface MJShaderProgram : NSObject

/** The source code of the vertex shader. */
@property (nonatomic, copy, readonly) NSString *vertexShader;

/** The source code of the fragment shader. */
@property (nonatomic, copy, readonly) NSString *fragmentShader;

/**
 * Array of attributes to bind to the vertex stream when compiling the shader,
 * in the same order as they are listed in the vertex shader.
 *
 * Example: @[@"inputPosition", @"inputUV"]
 */
@property (nonatomic, strong, readonly) NSArray *attributes;

/**
 * Initialize the shader program instance with shader source code
 * and shader attributes. The program must still be compiled before use.
 *
 * @param vertexShader The source code of the vertex shader.
 * @param fragmentShader The source code of the fragment shader.
 * @param attributes The attributes to bind to the vertex stream, in the same
 *                   order as they are listed in the vertex shader.
 * @return An initialized instance of the shader program object,
 *         ready for compilation.
 */
- (id)initWithVertexShader:(NSString *)vertexShader
            fragmentShader:(NSString *)fragmentShader
                attributes:(NSArray *)attributes;

/**
 * Compile and link the vertex and fragment shaders into a shader program.
 *
 * @param error Contains a pointer to an error object if compilation failed.
 */
- (void)compileWithError:(__autoreleasing NSError **)error;

/**
 * Get the attribute index of the specified attribute.
 *
 * @param attribute Attribute to get the index for.
 * @return The attribute index of the specified attribute.
 */
- (NSInteger)indexOfAttribute:(NSString *)attribute;

/**
 * Get the uniform index of the specified uniform.
 *
 * @param uniform Uniform to get the index for.
 * @return The uniform index of the specified uniform.
 */
- (NSInteger)indexOfUniform:(NSString *)uniform;

/**
 * Binds the program to the GL context for immediate use.
 */
- (void)prepareToDraw;

@end
