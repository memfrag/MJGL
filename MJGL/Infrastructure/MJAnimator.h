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

typedef uint32_t MJAnimationId;

double (^MJAnimationCurveLinear)(double t);
double (^MJAnimationCurveEaseIn)(double t);
double (^MJAnimationCurveEaseOut)(double t);
double (^MJAnimationCurveEaseInOut)(double t);


@protocol MJAnimator <NSObject>

@property (nonatomic, readonly) BOOL isIdle;
@property (nonatomic, readonly) NSUInteger currentAnimationCount;

- (MJAnimationId)animateWithDuration:(NSTimeInterval)duration
                               delay:(NSTimeInterval)delay
                               curve:(double (^)(double t))curve
                           animation:(void (^)(double t))animation
                          completion:(void (^)())completion;

- (MJAnimationId)animateWithDuration:(NSTimeInterval)duration
                               curve:(double (^)(double t))curve
                           animation:(void (^)(double t))animation
                          completion:(void (^)())completion;

- (MJAnimationId)animateWithDuration:(NSTimeInterval)duration
                               delay:(NSTimeInterval)delay
                           animation:(void (^)(double t))animation
                          completion:(void (^)())completion;

- (MJAnimationId)animateWithDuration:(NSTimeInterval)duration
                           animation:(void (^)(double t))animation
                          completion:(void (^)())completion;

- (MJAnimationId)animateWithDuration:(NSTimeInterval)duration
                               curve:(double (^)(double t))curve
                           animation:(void (^)(double t))animation;

- (MJAnimationId)animateWithDuration:(NSTimeInterval)duration
                               delay:(NSTimeInterval)delay
                           animation:(void (^)(double t))animation;

- (MJAnimationId)animateWithDuration:(NSTimeInterval)duration
                           animation:(void (^)(double t))animation;

- (MJAnimationId)animateWithRepeatingDuration:(NSTimeInterval)duration
                                        delay:(NSTimeInterval)delay
                                        curve:(double (^)(double t))curve
                                    animation:(void (^)(double t))animation;

- (MJAnimationId)animateWithRepeatedDuration:(NSTimeInterval)duration
                                       curve:(double (^)(double t))curve
                                   animation:(void (^)(double t))animation;

- (MJAnimationId)animateWithRepeatingDuration:(NSTimeInterval)duration
                                        delay:(NSTimeInterval)delay
                                    animation:(void (^)(double t))animation;

- (MJAnimationId)animateWithRepeatingDuration:(NSTimeInterval)duration
                                    animation:(void (^)(double t))animation;

- (void)invalidateAnimationWithId:(MJAnimationId)animationId;

- (void)updateWithElapsedTime:(NSTimeInterval)elapsedTime;

@end


@interface MJAnimator : NSObject <MJAnimator>

@end
