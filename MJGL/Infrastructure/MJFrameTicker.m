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

#import "MJFrameTicker.h"

#if !defined(TARGET_OS_IPHONE)
#import <CoreVideo/CoreVideo.h>
#include <sys/time.h>
#else
#import <QuartzCore/QuartzCore.h>
#endif

@implementation MJFrameTicker {
#if !defined(TARGET_OS_IPHONE)
    __weak NSView *_view;
    CVDisplayLinkRef _displayLink;
    struct timeval _previousTime;
#else
    CADisplayLink *_displayLink;
#endif
    BOOL _running;
}

@synthesize delegate;

#if !defined(TARGET_OS_IPHONE)
- (id)initWithView:(NSView *)view
{
    
}
#endif

- (BOOL)running
{
    return _running;
}

- (void)start
{
	if (!_running) {
#if !defined(TARGET_OS_IPHONE)
        // Create a display link capable of being used with all active displays
        CVDisplayLinkCreateWithActiveCGDisplays(&_displayLink);
        
        // Set the renderer output callback function
        CVDisplayLinkSetOutputCallback(_displayLink, &MJDisplayLinkCallback, (__bridge void *)(self));
        
        // Set the display link for the current renderer
        CGLContextObj cglContext = [view.openGLContext CGLContextObj];
        CGLPixelFormatObj cglPixelFormat = [view.pixelFormat CGLPixelFormatObj];
        CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(_displayLink, cglContext, cglPixelFormat);
        
        gettimeofday(&_previousTime, NULL);
        
        // Activate the display link
        CVDisplayLinkStart(_displayLink);
#else
		_displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
		[_displayLink setFrameInterval:1];
		[_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
#endif
        
		_running = YES;
	}
}

- (void)stop
{
    if (_running) {
#if !defined(TARGET_OS_IPHONE)
        CVDisplayLinkStop(_displayLink);
        CVDisplayLinkRelease(_displayLink);
        _displayLink = nil;
#else
		[_displayLink invalidate];
		_displayLink = nil;
#endif
		
		_running = NO;
	}
}

#if !defined(TARGET_OS_IPHONE)
// This is the renderer output callback function
static CVReturn MJDisplayLinkCallback(CVDisplayLinkRef displayLink,
                                      const CVTimeStamp *now,
                                      const CVTimeStamp *outputTime,
                                      CVOptionFlags flagsIn,
                                      CVOptionFlags *flagsOut,
                                      void *displayLinkContext)
{
    @autoreleasepool {
        struct timeval now;
        gettimeofday(&now, NULL);
        
        double elapsedSeconds = now.tv_sec - _previousTime.tv_sec;
        double elapsedMicroSeconds = now.tv_usec - _previousTime.tv_usec;
        double elapsedTime = elapsedSeconds + elapsedMicroSeconds * 0.000001;
        
        // Set some thresholds to get reasonable values no matter what.
        if (elapsedTime < (1.0 / 512.0)) {
            elapsedTime = 1 / 60.0;
        } else if (elapsedTime > (1.0 / 4.0)) {
            elapsedTime = 1 / 60.0;
        }
        
        _previousTime = now;

        MJFrameTicker *frameTicker = (__bridge MJFrameTicker *)displayLinkContext;
        
        if (frameTicker.delegate && [frameTicker.delegate respondsToSelector:@selector(frameTicker:nextFrameWithElapsedTime:)]) {
            [frameTicker.delegate frameTicker:frameTicker nextFrameWithElapsedTime:elapsedTime];
        }

        return kCVReturnSuccess;
    }
}
#else
- (void)tick:(CADisplayLink *)displayLink
{
    @autoreleasepool {
        double elapsedTime = displayLink.duration;
        if (self.delegate && [self.delegate respondsToSelector:@selector(frameTicker:nextFrameWithElapsedTime:)]) {
            [self.delegate frameTicker:self nextFrameWithElapsedTime:elapsedTime];
        }
    }
}
#endif

@end
