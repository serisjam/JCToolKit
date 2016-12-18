//
//  NSObject+JCAOP.m
//  Pods
//
//  Created by 唐 on 16/12/18.
//
//

#import "NSObject+JCAOP.h"

//block 内部实现，用于获取block signature copy form BlocksKit https://github.com/zwaldowski/BlocksKit.git

typedef NS_OPTIONS(int, JCBlockFlags) {
    JCBlockFlagsHasCopyDisposeHelpers = (1 << 25),
    JCBlockFlagsHasSignature          = (1 << 30)
};

typedef struct _JCBlock {
    __unused Class isa;
    JCBlockFlags flags;
    __unused int reserved;
    void (__unused *invoke)(struct _JCBlock *block, ...);
    struct {
        unsigned long int reserved;
        unsigned long int size;
        void (*copy)(void *dst, const void *src);
        void (*dispose)(const void *);
        const char *signature;
        const char *layout;
    } *descriptor;
} *JCBlockRef;

@implementation NSObject (JCAOP)

+ (void)jc_hookSelector:(SEL)selector withExcuteOption:(JCAOPExecuteOptions)options usingBlock:(id)block {
    NSParameterAssert(selector);
    NSParameterAssert(block);
}

#pragma mark private Method

+ (NSMethodSignature *)jc_signatureForBlock:(id)block {
    JCBlockRef layout = (__bridge void *)block;
    // 如果 block 没有签名直接返回空
    if (!(layout->flags & JCBlockFlagsHasSignature))
    return nil;
    void *desc = layout->descriptor;
    desc += 2 * sizeof(unsigned long int);
    if (layout->flags & JCBlockFlagsHasCopyDisposeHelpers)
    desc += 2 * sizeof(void *);
    if (!desc)
    return nil;
    const char *signature = (*(const char **)desc);
    return [NSMethodSignature signatureWithObjCTypes:signature];
}

@end
