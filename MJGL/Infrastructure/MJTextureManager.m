//
//  Copyright (c) 2014 Martin Johannesson
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

#import "MJTextureManager.h"

@implementation MJTextureManager {
    NSMutableDictionary *_textures;
}

- (GLKTextureInfo *)loadTexture:(NSString *)textureName {
    NSError *error = nil;
    GLKTextureInfo *texture = _textures[textureName];
    if (texture) {
        return texture;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:textureName ofType:@"png"];
    texture = [GLKTextureLoader textureWithContentsOfFile:path options:@{GLKTextureLoaderGenerateMipmaps: @YES} error:&error];
    if (error) {
        NSLog(@"ERROR: %@", error.localizedDescription);
    } else {
        _textures[textureName] = texture;
    }
    return texture;
}

- (void)removeTextureWithName:(NSString *)textureName {
    [_textures removeObjectForKey:textureName];
}

@end
