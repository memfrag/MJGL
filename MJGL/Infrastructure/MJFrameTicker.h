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

@protocol MJFrameTickerDelegate;

/**
 * The frame ticker calls a delegate method everytime a new frame
 * is about to be rendered.
 */
@protocol MJFrameTicker <NSObject>

/** The delegate of the frame ticker. */
@property (nonatomic, weak) id<MJFrameTickerDelegate> delegate;

/**
 * Check if the frame ticker is running or if it has been stopped.
 *
 * @return YES if the frame ticker is running.
 */
- (BOOL)running;

/**
 * Start the frame ticker.
 *
 * On iOS, this would typically be used to start the frame ticker
 * after the app has been activated.
 */
- (void)start;

/**
 * Stop the frame ticker.
 *
 * On iOS, this would typically be used to stop the frame ticker
 * when the app is about to be deactivated.
 */
- (void)stop;

@end

/**
 * Default implementation of the frame ticker protocol.
 */
@interface MJFrameTicker : NSObject <MJFrameTicker>

#if !TARGET_OS_IPHONE
/**
 * Initialize the frame ticker with the OS X OpenGL view to track frames for.
 *
 * NOTE: OS X only!
 *
 * @param view OpenGL view to track frames for.
 *
 * @return Initialized frame ticker object.
 */
- (id)initWithView:(NSOpenGLView *)view;
#endif

@end


/**
 * Delegate protocol of the frame ticker.
 */
@protocol MJFrameTickerDelegate <NSObject>

/**
 * Called when the next frame is about to be rendered.
 *
 * @param frameTicker The frame ticker object that called the method.
 * @param elapsedTime The time that has elapsed since the last frame.
 */
- (void)frameTicker:(MJFrameTicker *)frameTicker nextFrameWithElapsedTime:(NSTimeInterval)elapsedTime;

@end

