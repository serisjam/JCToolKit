//
//  NSTimer+Addition.m
//  JCFindHouse
//
//  Created by Jam on 14-4-21.
//  Copyright (c) 2014年 jiamiao. All rights reserved.
//

#import "NSTimer+JCExtend.h"

@implementation NSTimer (JCExtend)

+ (void)jc_execBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)jc_timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(jc_execBlock:) userInfo:[block copy] repeats:repeats];
}

- (void)jc_pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


- (void)jc_resumeTimer {
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)jc_resumeTimerAfterTimeInterval:(NSTimeInterval)interval {
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
