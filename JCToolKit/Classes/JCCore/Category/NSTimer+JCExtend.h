//
//  NSTimer+Addition.h
//  JCFindHouse
//
//  Created by Jam on 14-4-21.
//  Copyright (c) 2014年 jiamiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (JCExtend)

+ (NSTimer *)jc_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;
+ (NSTimer *)jc_timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

- (void)jc_pauseTimer;
- (void)jc_resumeTimer;
- (void)jc_resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
