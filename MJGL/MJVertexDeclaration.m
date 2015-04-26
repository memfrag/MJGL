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

#import "MJVertexDeclaration.h"

@interface MJVertexDeclarationComponent : NSObject
@property (nonatomic, assign) GLuint index;
@property (nonatomic, assign) GLint size;
@property (nonatomic, assign) GLenum type;
@property (nonatomic, assign) GLboolean normalized;
@property (nonatomic, assign) GLsizei stride;
@property (nonatomic, assign) const GLvoid *offset;
@property (nonatomic, assign) GLuint attribute;
@end
@implementation MJVertexDeclarationComponent
@end



@interface MJVertexDeclaration ()
@property (nonatomic, strong) NSMutableArray *components;
@property (nonatomic, readwrite) NSUInteger stride;

@end

@implementation MJVertexDeclaration

- (void)apply
{
    for (MJVertexDeclarationComponent *component in self.components)
    {
        glVertexAttribPointer(component.index,
                              component.size,
                              component.type,
                              component.normalized,
                              component.stride,
                              component.offset);
        glEnableVertexAttribArray(component.attribute);
    }
}

- (void)addComponentOfType:(GLenum)type
                normalized:(GLboolean)normalized
                     count:(GLint)count
{
    if (self.components == nil) {
        // Lazily instantiate components array
        self.components = [NSMutableArray array];
    }

    MJVertexDeclarationComponent *component =
                                [[MJVertexDeclarationComponent alloc] init];
    component.index = (GLuint) self.components.count;
	component.size = count;
	component.type = type;
	component.normalized = normalized;
	component.stride = 0;
	component.offset = (const GLvoid *)_stride;
	component.attribute = (GLuint) self.components.count;

    [self.components addObject:component];

    switch (type)
    {
        case GL_FLOAT:
            _stride += count * sizeof(GLfloat);
            break;
        case GL_UNSIGNED_BYTE:
            _stride += count * sizeof(GLubyte);
            break;
    }

    // Update stride
    for (MJVertexDeclarationComponent *component in self.components)
    {
        component.stride = (GLsizei) _stride;
    }
}


- (void)addFloatComponentOfCount:(GLint)count
{
    [self addComponentOfType:GL_FLOAT normalized:GL_FALSE count:count];
}

- (void)addUnsignedByteComponentOfCount:(GLint)count
{
    [self addComponentOfType:GL_UNSIGNED_BYTE normalized:GL_FALSE count:count];
}

- (void)addNormalizedUnsignedByteComponentOfCount:(GLint)count
{
    [self addComponentOfType:GL_UNSIGNED_BYTE normalized:GL_TRUE count:count];
}

- (void)addNormalizedUnsignedShortComponentOfCount:(GLint)count
{
    [self addComponentOfType:GL_UNSIGNED_SHORT normalized:GL_TRUE count:count];
}


@end
