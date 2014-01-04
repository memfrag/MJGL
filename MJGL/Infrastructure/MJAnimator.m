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

#import "MJAnimator.h"

double (^MJAnimationCurveLinear)(double t) = ^(double t) {
    return t;
};

double (^MJAnimationCurveEaseIn)(double t) = ^(double t) {
    return t * t;
};

double (^MJAnimationCurveEaseOut)(double t) = ^(double t) {
    return -t * (t - 2);
};

double (^MJAnimationCurveEaseInOut)(double t) = ^(double t) {
    return 0.5 * (1 - cos(M_PI * t));
};


@interface MJAnimationInstance : NSObject

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, assign) BOOL repeat;
@property (nonatomic, copy) double (^curve)(double t);
@property (nonatomic, copy) void (^animation)(double t);
@property (nonatomic, copy) void (^completion)();

@property (nonatomic, assign) NSTimeInterval oneOverDuration;
@property (nonatomic, assign) NSTimeInterval remainingDelay;
@property (nonatomic, assign) NSTimeInterval animationTime;
@property (nonatomic, assign) BOOL markedForRemoval;

- (id)initWithDuration:(NSTimeInterval)duration
                 delay:(NSTimeInterval)delay
                repeat:(BOOL)repeat
                 curve:(double (^)(double t))curve
             animation:(void (^)(double t))animation
            completion:(void (^)())completion;

- (void)updateWithElapsedTime:(NSTimeInterval)elapsedTime;

@end

@implementation MJAnimationInstance

- (id)initWithDuration:(NSTimeInterval)duration
                 delay:(NSTimeInterval)delay
                repeat:(BOOL)repeat
                 curve:(double (^)(double t))curve
             animation:(void (^)(double t))animation
            completion:(void (^)())completion
{
    self = [super init];
    if (self) {
        _duration = duration;
        _oneOverDuration = 1.0 / duration;
        _delay = delay;
        _remainingDelay = delay;
        _repeat = repeat;
        _curve = curve;
        _animation = animation;
        _completion = completion;
        
    }
    return self;
}

- (void)updateWithElapsedTime:(NSTimeInterval)elapsedTime
{
    if (_remainingDelay > 0.0f) {
        _remainingDelay -= elapsedTime;
        if (_remainingDelay > 0.0f) {
            return;
        } else {
            elapsedTime = -_remainingDelay;
        }
    }
    
    _animationTime += elapsedTime;
    
    
    if (_animationTime >= _duration) {
        if (_repeat) {
            fmod(_animationTime, _duration);
        } else {
            _animation(_curve(1.0));
            if (_completion) {
                _completion();
            }
            _markedForRemoval = YES;
            return;
        }
    }
    
    double t = _animationTime * _oneOverDuration;
    _animation(_curve(t));
}

@end


@interface MJAnimator ()

@property (nonatomic, strong) NSMutableDictionary *animations;

@end

@implementation MJAnimator

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred;
    static id instance = nil;
    dispatch_once(&pred, ^{
        instance = [[super alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _animations = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)isIdle
{
    return _animations.count == 0;
}

- (NSUInteger)currentAnimationCount
{
    return _animations.count;
}

- (MJAnimationId)animateWithDuration:(NSTimeInterval)duration
                               delay:(NSTimeInterval)delay
                              repeat:(BOOL)repeat
                               curve:(double (^)(double t))curve
                           animation:(void (^)(double t))animation
                          completion:(void (^)())completion
{
    static MJAnimationId currentAnimationId = 0;
    MJAnimationId animationId = ++currentAnimationId;
    
    MJAnimationInstance *animationInstance = [[MJAnimationInstance alloc] initWithDuration:duration
                                                                                     delay:delay
                                                                                    repeat:repeat
                                                                                     curve:curve
                                                                                 animation:animation
                                                                                completion:completion];

    
    self.animations[@(animationId)] = animationInstance;
    
    return animationId;
}

- (MJAnimationId)animateWithDuration:(NSTimeInterval)duration
                               delay:(NSTimeInterval)delay
                               curve:(double (^)(double t))curve
                           animation:(void (^)(double t))animation
                          completion:(void (^)())completion
{
    return [self animateWithDuration:duration
                               delay:delay
                              repeat:NO
                               curve:curve
                           animation:animation
                          completion:completion];
}

- (MJAnimationId)animateWithDuration:(NSTimeInterval)duration
                               curve:(double (^)(double t))curve
                           animation:(void (^)(double t))animation
                          completion:(void (^)())completion
{
    return [self animateWithDuration:duration
                               delay:0.0
                              repeat:NO
                               curve:curve
                           animation:animation
                          completion:completion];
}

- (MJAnimationId)animateWithDuration:(NSTimeInterval)duration
                               delay:(NSTimeInterval)delay
                           animation:(void (^)(double t))animation
                          completion:(void (^)())completion
{
    return [self animateWithDuration:duration
                               delay:delay
                              repeat:NO
                               curve:^(double t){return t;}
                           animation:animation
                          completion:completion];
}


- (MJAnimationId)animateWithDuration:(NSTimeInterval)duration
                           animation:(void (^)(double t))animation
                          completion:(void (^)())completion
{
    return [self animateWithDuration:duration
                               delay:0.0
                              repeat:NO
                               curve:^(double t){return t;}
                           animation:animation
                          completion:completion];
}


- (MJAnimationId)animateWithDuration:(NSTimeInterval)duration
                               curve:(double (^)(double t))curve
                           animation:(void (^)(double t))animation
{
    return [self animateWithDuration:duration
                               delay:0.0
                              repeat:NO
                               curve:curve
                           animation:animation
                          completion:nil];
}


- (MJAnimationId)animateWithDuration:(NSTimeInterval)duration
                               delay:(NSTimeInterval)delay
                           animation:(void (^)(double t))animation
{
    return [self animateWithDuration:duration
                               delay:delay
                              repeat:NO
                               curve:^(double t){return t;}
                           animation:animation
                          completion:nil];
}


- (MJAnimationId)animateWithDuration:(NSTimeInterval)duration
                           animation:(void (^)(double t))animation
{
    return [self animateWithDuration:duration
                               delay:0.0
                              repeat:NO
                               curve:^(double t){return t;}
                           animation:animation
                          completion:nil];
}


- (MJAnimationId)animateWithRepeatingDuration:(NSTimeInterval)duration
                                        delay:(NSTimeInterval)delay
                                        curve:(double (^)(double t))curve
                                    animation:(void (^)(double t))animation
{
    return [self animateWithDuration:duration
                               delay:delay
                              repeat:YES
                               curve:curve
                           animation:animation
                          completion:nil];
}


- (MJAnimationId)animateWithRepeatedDuration:(NSTimeInterval)duration
                                       curve:(double (^)(double t))curve
                                   animation:(void (^)(double t))animation
{
    return [self animateWithDuration:duration
                               delay:0.0
                              repeat:YES
                               curve:curve
                           animation:animation
                          completion:nil];
}


- (MJAnimationId)animateWithRepeatingDuration:(NSTimeInterval)duration
                                        delay:(NSTimeInterval)delay
                                    animation:(void (^)(double t))animation
{
    return [self animateWithDuration:duration
                               delay:delay
                              repeat:YES
                               curve:^(double t){return t;}
                           animation:animation
                          completion:nil];
}


- (MJAnimationId)animateWithRepeatingDuration:(NSTimeInterval)duration
                                    animation:(void (^)(double t))animation
{
    return [self animateWithDuration:duration
                               delay:0.0
                              repeat:YES
                               curve:^(double t){return t;}
                           animation:animation
                          completion:nil];
}


- (void)invalidateAnimationWithId:(MJAnimationId)animationId
{
    MJAnimationInstance *animationInstance = [self.animations objectForKey:@(animationId)];
    if (animationInstance) {
        animationInstance.markedForRemoval = YES;
    }
}

- (void)updateWithElapsedTime:(NSTimeInterval)elapsedTime
{
    NSMutableArray *removals = [NSMutableArray array];
    
    for (id animationId in self.animations) {
        MJAnimationInstance *animation = self.animations[animationId];
        if (animation.markedForRemoval) {
            [removals addObject:animationId];
            continue;
        }
        
        [animation updateWithElapsedTime:elapsedTime];
        
        if (animation.markedForRemoval) {
            [removals addObject:animationId];
        }
    }
}

@end
