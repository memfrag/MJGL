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

#import "MJGLContext.h"

@interface MJGLContext ()

#ifdef TARGET_OS_IPHONE
@property (nonatomic, strong) EAGLContext *glContext;
#else
@property (nonatomic, strong) NSOpenGLContext *glContext;
#endif

@end

@implementation MJGLContext

- (id)init
{
    self = [super init];
    if (self) {
#ifdef TARGET_OS_IPHONE
        _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
#endif
    }
    return self;
}

#ifndef TARGET_OS_IPHONE
#endif

- (void)makeCurrent
{
#ifdef TARGET_OS_IPHONE
    [EAGLContext setCurrentContext:self.glContext];
#else
    [self.glContext makeCurrent];
#endif
}

@end
