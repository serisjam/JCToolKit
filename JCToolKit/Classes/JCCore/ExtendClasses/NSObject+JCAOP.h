//
//  NSObject+JCAOP.h
//  Pods
//
//  Created by Jam on 16/12/18.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JCAOPExecuteOptions) {
    JCAOPExecuteOptionAfter,
    JCAOPExecuteOptionInstead,
    JCAOPExecuteOptionBefore
};

@interface JCAOPInfo : NSObject

@property (nonatomic, unsafe_unretained, readonly) id instance;
@property (nonatomic, strong, readonly) NSInvocation *originalInvocation;
@property (nonatomic, strong, readonly) NSArray *arguments;

@end

@interface NSObject (JCAOP)

+ (void)jc_hookSelector:(SEL)selector withExcuteOption:(JCAOPExecuteOptions)options usingBlock:(void (^)(JCAOPInfo *aopInfo))block;
- (void)jc_hookSelector:(SEL)selector withExcuteOption:(JCAOPExecuteOptions)options usingBlock:(void (^)(JCAOPInfo *aopInfo))block;

@end
