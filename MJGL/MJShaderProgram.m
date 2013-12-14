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

#import "MJShaderProgram.h"

const NSString *MJShaderProgramErrorDomain = @"MJShaderProgramErrorDomain";

@interface MJShaderProgram ()

@property (nonatomic, copy, readwrite) NSString *vertexShader;
@property (nonatomic, copy, readwrite) NSString *fragmentShader;
@property (nonatomic, strong, readwrite) NSArray *attributes;
@property (nonatomic, assign) GLuint program;

@end

@implementation MJShaderProgram {
    NSString *_vertexShader;
    NSString *_fragmentShader;
}

- (id)initWithVertexShader:(NSString *)vertexShader
            fragmentShader:(NSString *)fragmentShader
                attributes:(NSArray *)attributes {
    self = [super init];
    if (self) {
        _vertexShader = [vertexShader copy];
        _fragmentShader = [fragmentShader copy];
        _attributes = [NSArray arrayWithArray:attributes];
    }
    return self;
}

- (void)dealloc
{
    glDeleteProgram(self.program);
}

- (NSInteger)indexOfAttribute:(NSString *)attribute {
    return [self.attributes indexOfObject:attribute];
}

- (NSInteger)indexOfUniform:(NSString *)uniform {
    int location = glGetUniformLocation(self.program, [uniform UTF8String]);
    GLenum result = glGetError();
    if (result != GL_NO_ERROR) {
        NSLog(@"GL ERROR: %d", result);
    }
    
    return location;
}

- (void)prepareToDraw {
    glUseProgram(self.program);
    GLenum result = glGetError();
    if (result != GL_NO_ERROR) {
        NSLog(@"GL ERROR: %d", result);
    }
}

#pragma mark - Compilation and Linking

- (void)compileWithError:(__autoreleasing NSError **)error {
    
    *error = nil;
    
    // Create shader program.
    GLuint program = glCreateProgram();
    
    // Create and compile vertex shader.
    GLuint vertexShader;
    bool success = [self compileShader:&vertexShader
                                  type:GL_VERTEX_SHADER
                                  code:[self.vertexShader UTF8String]];
    if (!success) {
        glDeleteProgram(program);
        *error = [NSError errorWithDomain:(NSString *)MJShaderProgramErrorDomain
                                     code:kMJShaderProgramErrorCompilingVertexShader
                                 userInfo:@{NSLocalizedDescriptionKey : @"Failed to compile vertex shader."}];
        return;
    }
    
    // Create and compile fragment shader.
    GLuint fragmentShader;
    success = [self compileShader:&fragmentShader
                             type:GL_FRAGMENT_SHADER
                             code:[self.fragmentShader UTF8String]];
    if (!success) {
        glDeleteShader(vertexShader);
        glDeleteProgram(program);
        *error = [NSError errorWithDomain:(NSString *)MJShaderProgramErrorDomain
                                     code:kMJShaderProgramErrorCompilingFragmentShader
                                 userInfo:@{NSLocalizedDescriptionKey: @"Failed to compile fragment shader."}];
        return;
    }
    
    // Attach vertex shader to program.
    glAttachShader(program, vertexShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fragmentShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    int i = 0;
    for (NSString *attribute in self.attributes) {
        glBindAttribLocation(program, i++, [attribute UTF8String]);
    }
    
    // Link program.
    success = [self linkProgram:program];
    if (!success) {
        glDetachShader(program, vertexShader);
        glDeleteShader(vertexShader);
        glDetachShader(program, fragmentShader);
        glDeleteShader(fragmentShader);
        glDeleteProgram(program);
        *error = [NSError errorWithDomain:(NSString *)MJShaderProgramErrorDomain
                                     code:kMJShaderProgramErrorLinkingShaderProgram
                                 userInfo:@{NSLocalizedDescriptionKey: @"Failed to compile shader program."}];
        return;
    }
    
    // Release vertex and fragment shaders.
    glDetachShader(program, vertexShader);
    glDeleteShader(vertexShader);
    glDetachShader(program, fragmentShader);
    glDeleteShader(fragmentShader);
    
    self.program = program;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type code:(const char *)sourceCode {
    GLint status;
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &sourceCode, NULL);
    glCompileShader(*shader);
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        GLint logLength;
        glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
        if (logLength > 0) {
            GLchar *log = (GLchar *)malloc(logLength);
            glGetShaderInfoLog(*shader, logLength, &logLength, log);
            NSLog(@"Shader compile log:\n%s", log);
            free(log);
        }
        
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)program {
    GLint status;
    glLinkProgram(program);
    
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    if (status == 0) {
        GLint logLength;
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLength);
        if (logLength > 0) {
            GLchar *log = (GLchar *)malloc(logLength);
            glGetProgramInfoLog(program, logLength, &logLength, log);
            NSLog(@"Program link log:\n%s", log);
            free(log);
        }
        
        return NO;
    }
    
    return YES;
}

@end
