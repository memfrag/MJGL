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

#pragma once

#if TARGET_OS_MAC && !TARGET_OS_IPHONE
#define GL_DO_NOT_WARN_IF_MULTI_GL_VERSION_HEADERS_INCLUDED
#import <OpenGL/gl3.h>
#elif TARGET_OS_IPHONE
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#else
#error This file is only meant for OS X or iOS.
#endif

#if TARGET_OS_MAC && !TARGET_OS_IPHONE
#define glGenVertexArraysMJ glGenVertexArrays
#define glBindVertexArrayMJ glBindVertexArray
#define glBindVertexArrayMJ glBindVertexArray
#define glDeleteVertexArraysMJ glDeleteVertexArrays
#elif TARGET_OS_IPHONE
#define glGenVertexArraysMJ glGenVertexArraysOES
#define glBindVertexArrayMJ glBindVertexArrayOES
#define glBindVertexArrayMJ glBindVertexArrayOES
#define glDeleteVertexArraysMJ glDeleteVertexArraysOES
#else
#error This file can only be compiled for OS X or iOS.
#endif
