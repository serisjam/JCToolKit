//
//  UIControl+JCExtend.m
//  Pods
//
//  Created by Jam on 16/12/18.
//
//

#import "UIControl+JCExtend.h"

#import <objc/runtime.h>
#import "NSObject+JCExtend.h"

@implementation UIControl (JCExtend)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
        Method swizzledMethod = class_getInstanceMethod(self, @selector(swizzled_sendAction:to:forEvent:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)swizzled_sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event {
    
    if (NSDate.date.timeIntervalSince1970 - [self acceptEventTime] < self.acceptEventInterval) return;
    
    if (self.acceptEventInterval > 0) {
        [self setAcceptEventTime:NSDate.date.timeIntervalSince1970];
    }
    
    [self swizzled_sendAction:action to:target forEvent:event];
}

- (NSTimeInterval)acceptEventInterval {
    return [[self jc_getAssociatedObjectForKey:"UIControl_acceptEventInterval"] doubleValue];
}

- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval {
    [self jc_retainAssociatedObject:@(acceptEventInterval) forKey:"UIControl_acceptEventInterval"];
}

- (NSTimeInterval)acceptEventTime {
    return [[self jc_getAssociatedObjectForKey:"UIControl_acceptEventTime"] doubleValue];
}

- (void)setAcceptEventTime:(NSTimeInterval)acceptEventInterval {
    [self jc_retainAssociatedObject:@(acceptEventInterval) forKey:"UIControl_acceptEventTime"];
}

@end
