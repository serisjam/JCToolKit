//
//  NSObject+JCAOP.h
//  Pods
//
//  Created by 唐 on 16/12/18.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JCAOPExecuteOptions) {
    JCAOPExecuteOptionAfter,
    JCAOPExecuteOptionInstead,
    JCAOPExecuteOptionBefore
};

@interface NSObject (JCAOP)

+ (void)jc_hookSelector:(SEL)selector withExcuteOption:(JCAOPExecuteOptions)options usingBlock:(id)block;

@end
