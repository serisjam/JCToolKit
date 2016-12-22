//
//  NSObject+JCAOP.m
//  Pods
//
//  Created by 唐 on 16/12/18.
//
//

#import "NSObject+JCAOP.h"

#import <objc/runtime.h>
#import <objc/message.h>

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

static NSMethodSignature * jc_signatureForBlock(id block) {
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

static IMP jc_getMsgForwardIMP(NSObject *self, SEL selector) {
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    // As an ugly internal runtime implementation detail in the 32bit runtime, we need to determine of the method we hook returns a struct or anything larger than id.
    // https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/LowLevelABI/000-Introduction/introduction.html
    // https://github.com/ReactiveCocoa/ReactiveCocoa/issues/783
    // http://infocenter.arm.com/help/topic/com.arm.doc.ihi0042e/IHI0042E_aapcs.pdf (Section 5.4)
    Method method = class_getInstanceMethod(self.class, selector);
    const char *encoding = method_getTypeEncoding(method);
    BOOL methodReturnsStructValue = encoding[0] == _C_STRUCT_B;
    if (methodReturnsStructValue) {
        @try {
            NSUInteger valueSize = 0;
            NSGetSizeAndAlignment(encoding, &valueSize, NULL);
            
            if (valueSize == 1 || valueSize == 2 || valueSize == 4 || valueSize == 8) {
                methodReturnsStructValue = NO;
            }
        } @catch (__unused NSException *e) {}
    }
    if (methodReturnsStructValue) {
        msgForwardIMP = (IMP)_objc_msgForward_stret;
    }
#endif
    return msgForwardIMP;
}

//把class的isa指针指向statedClass
static void jc_hookedGetClass(Class class, Class statedClass) {
    NSCParameterAssert(class);
    NSCParameterAssert(statedClass);
    Method method = class_getInstanceMethod(class, @selector(class));
    IMP newIMP = imp_implementationWithBlock(^(id self) {
        return statedClass;
    });
    class_replaceMethod(class, @selector(class), newIMP, method_getTypeEncoding(method));
}

static void jc_hook_forwardInvocation(__unsafe_unretained NSObject *self, SEL selector, NSInvocation *invocation) {
    SEL originalSelector = invocation.selector;
    SEL aliasSelector = NSSelectorFromString([@"_jc" stringByAppendingFormat:@"_%@", NSStringFromSelector(originalSelector)]);
    invocation.selector = aliasSelector;
    [invocation invoke];
}

static NSString *const JCSubClassPrefix = @"_JC_";

static Class jc_hookClass(NSObject *self, NSError **error) {
    
    Class statedClass = self.class;
    Class baseClass = object_getClass(self);
    NSString *className = NSStringFromClass(baseClass);
    
    if ([className hasPrefix:JCSubClassPrefix]) {
        
    } else if (class_isMetaClass(baseClass)) {
        IMP originalImplementation = class_replaceMethod(self, @selector(forwardInvocation:), (IMP)jc_hook_forwardInvocation, "v@:@");
        class_addMethod(self, NSSelectorFromString(@"jc_hook_forwardInvocation:"), originalImplementation, "v@:@");
    } else if (statedClass != baseClass) {
        
    }
    
    const char *subclassName = [JCSubClassPrefix stringByAppendingString:className].UTF8String;
    Class subclass = objc_getClass(subclassName);
    
    if (subclass == nil) {
        subclass = objc_allocateClassPair(baseClass, subclassName, 0);
        if (subclass == nil) {
            return nil;
        }
        
        IMP originalImplementation = class_replaceMethod(subclass, @selector(forwardInvocation:), (IMP)jc_hook_forwardInvocation, "v@:@");
        if (originalImplementation) {
            class_addMethod(subclass, NSSelectorFromString(@"_JC_forwardInvocation:"), originalImplementation, "v@:@");
        }
        //实现当前类的isa指针指向原生的类
        jc_hookedGetClass(subclass, statedClass);
        //实现当前类的元类的isa指针指向原生的类
        jc_hookedGetClass(object_getClass(subclass), statedClass);
        objc_registerClassPair(subclass);
    }
    
    object_setClass(self, subclass);
    return subclass;
}

@implementation NSObject (JCAOP)

- (void)jc_hookSelector:(SEL)selector withExcuteOption:(JCAOPExecuteOptions)options usingBlock:(id)block {
    NSParameterAssert(selector);
    NSParameterAssert(block);
    
    NSMethodSignature *blockSignature = jc_signatureForBlock(block);
    
    Class jcClass = jc_hookClass(self, nil);
    
    Method targetMethod = class_getInstanceMethod(jcClass, selector);
    IMP targetMethodIMP = method_getImplementation(targetMethod);
    
    const char *typeEncoding = method_getTypeEncoding(targetMethod);
    SEL aliasSelector = NSSelectorFromString([@"_jc" stringByAppendingFormat:@"_%@", NSStringFromSelector(selector)]);
    
    if (![jcClass instancesRespondToSelector:aliasSelector]) {
        __unused BOOL addedAlias = class_addMethod(jcClass, aliasSelector, method_getImplementation(targetMethod), typeEncoding);
    }
    class_replaceMethod(jcClass, selector, jc_getMsgForwardIMP(self, selector), typeEncoding);
}

#pragma mark private Method

@end
