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

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

/**
 * Super simple texture manager. Its only purpose is to cache loaded
 * textures to avoid redundant loads of an already loaded texture.
 */
@protocol MJTextureManager <NSObject>

/**
 * Loads a texture from the main bundle or returns a cached
 * texture if the texture has been loaded by this instance of the
 * texture manager before.
 */
- (GLKTextureInfo *)loadTexture:(NSString *)textureName;

/**
 * Removes a texture from the cache. Note that the texture object will
 * not be deallocated if other objects strongly refer to it.
 */
- (void)removeTextureWithName:(NSString *)textureName;

@end

/**
 * Default implementation of the texture manager protocol.
 */
@interface MJTextureManager : NSObject <MJTextureManager>

@end
