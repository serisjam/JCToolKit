//
//  NSObject+JCAOP.m
//  Pods
//
//  Created by Jam on 16/12/18.
//
//

#import "NSObject+JCAOP.h"
#import "JCDefine.h"
#import <objc/runtime.h>
#import <objc/message.h>

@class JCAOPItemInfo;

@interface JCAOPContainer : NSObject

- (void)addAopItemInfo:(JCAOPItemInfo *)itemInfo withOptions:(JCAOPExecuteOptions)options;
- (BOOL)removeAopItemInfo:(JCAOPItemInfo *)itemInfo;
- (BOOL)hasAopItem;

@property (atomic, copy) NSArray *beforeAopItems;
@property (atomic, copy) NSArray *insteadAopItems;
@property (atomic, copy) NSArray *afterAopItems;

@end

@implementation JCAOPContainer

- (void)addAopItemInfo:(JCAOPItemInfo *)itemInfo withOptions:(JCAOPExecuteOptions)options
{
	NSParameterAssert(itemInfo);
	switch (options) {
		case JCAOPExecuteOptionBefore:  self.beforeAopItems  = [(self.beforeAopItems ?:@[]) arrayByAddingObject:itemInfo]; break;
		case JCAOPExecuteOptionInstead: self.insteadAopItems = [(self.insteadAopItems?:@[]) arrayByAddingObject:itemInfo]; break;
		case JCAOPExecuteOptionAfter:   self.afterAopItems   = [(self.afterAopItems  ?:@[]) arrayByAddingObject:itemInfo]; break;
	}
}

- (BOOL)hasAopItem {
	return self.beforeAopItems.count > 0 || self.insteadAopItems.count > 0 || self.afterAopItems.count > 0;
}

- (BOOL)removeAopItemInfo:(JCAOPItemInfo *)itemInfo {
	for (NSString *aspectArrayName in @[NSStringFromSelector(@selector(beforeAopItems)),
										NSStringFromSelector(@selector(insteadAopItems)),
										NSStringFromSelector(@selector(afterAopItems))]) {
		NSArray *array = [self valueForKey:aspectArrayName];
		NSUInteger index = [array indexOfObjectIdenticalTo:itemInfo];
		if (array && index != NSNotFound) {
			NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];
			[newArray removeObjectAtIndex:index];
			[self setValue:newArray forKey:aspectArrayName];
			return YES;
		}
	}
	return NO;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p, before:%@, instead:%@, after:%@>", self.class, self, self.beforeAopItems, self.insteadAopItems, self.afterAopItems];
}

@end

@interface JCAOPItemInfo : NSObject

@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) id block;
@property (nonatomic, strong) NSMethodSignature *blockSignature;
@property (nonatomic, weak) id object;
@property (nonatomic, assign) JCAOPExecuteOptions options;

+ (instancetype)itemInfoWithSelector:(SEL)selector object:(id)object options:(JCAOPExecuteOptions)options block:(id)block error:(NSError **)error;
- (void)invokeWithInfo:(JCAOPInfo *)info;

@end

@implementation JCAOPItemInfo

+ (instancetype)itemInfoWithSelector:(SEL)selector object:(id)object options:(JCAOPExecuteOptions)options block:(id)block error:(NSError **)error {
	
	NSCParameterAssert(block);
	NSCParameterAssert(selector);
	NSMethodSignature *blockSignature = jc_signatureForBlock(block);
	
	JCAOPItemInfo *itemInfo = nil;
	if (blockSignature) {
		itemInfo = [JCAOPItemInfo new];
		itemInfo.selector = selector;
		itemInfo.block = block;
		itemInfo.blockSignature = blockSignature;
		itemInfo.options = options;
		itemInfo.object = object;
	}
	return itemInfo;
}

- (void)invokeWithInfo:(JCAOPInfo *)info {
	NSCParameterAssert(info);
	NSInvocation *blockInvocation = [NSInvocation invocationWithMethodSignature:self.blockSignature];
	[blockInvocation setArgument:&info atIndex:1];
	[blockInvocation invokeWithTarget:self.block];
}

#pragma mark private method

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

@end

@implementation NSInvocation (JCAOP)

//获取NSInvocation 内部的参数转换 copy form ReactiveCocoa
- (id)JCAOP_argumentAtIndex:(NSUInteger)index {
	const char *argType = [self.methodSignature getArgumentTypeAtIndex:index];
	// Skip const type qualifier.
	if (argType[0] == _C_CONST) argType++;
	
#define WRAP_AND_RETURN(type) do { type val = 0; [self getArgument:&val atIndex:(NSInteger)index]; return @(val); } while (0)
	if (strcmp(argType, @encode(id)) == 0 || strcmp(argType, @encode(Class)) == 0) {
		__autoreleasing id returnObj;
		[self getArgument:&returnObj atIndex:(NSInteger)index];
		return returnObj;
	} else if (strcmp(argType, @encode(SEL)) == 0) {
		SEL selector = 0;
		[self getArgument:&selector atIndex:(NSInteger)index];
		return NSStringFromSelector(selector);
	} else if (strcmp(argType, @encode(Class)) == 0) {
		__autoreleasing Class theClass = Nil;
		[self getArgument:&theClass atIndex:(NSInteger)index];
		return theClass;
		// Using this list will box the number with the appropriate constructor, instead of the generic NSValue.
	} else if (strcmp(argType, @encode(char)) == 0) {
		WRAP_AND_RETURN(char);
	} else if (strcmp(argType, @encode(int)) == 0) {
		WRAP_AND_RETURN(int);
	} else if (strcmp(argType, @encode(short)) == 0) {
		WRAP_AND_RETURN(short);
	} else if (strcmp(argType, @encode(long)) == 0) {
		WRAP_AND_RETURN(long);
	} else if (strcmp(argType, @encode(long long)) == 0) {
		WRAP_AND_RETURN(long long);
	} else if (strcmp(argType, @encode(unsigned char)) == 0) {
		WRAP_AND_RETURN(unsigned char);
	} else if (strcmp(argType, @encode(unsigned int)) == 0) {
		WRAP_AND_RETURN(unsigned int);
	} else if (strcmp(argType, @encode(unsigned short)) == 0) {
		WRAP_AND_RETURN(unsigned short);
	} else if (strcmp(argType, @encode(unsigned long)) == 0) {
		WRAP_AND_RETURN(unsigned long);
	} else if (strcmp(argType, @encode(unsigned long long)) == 0) {
		WRAP_AND_RETURN(unsigned long long);
	} else if (strcmp(argType, @encode(float)) == 0) {
		WRAP_AND_RETURN(float);
	} else if (strcmp(argType, @encode(double)) == 0) {
		WRAP_AND_RETURN(double);
	} else if (strcmp(argType, @encode(BOOL)) == 0) {
		WRAP_AND_RETURN(BOOL);
	} else if (strcmp(argType, @encode(bool)) == 0) {
		WRAP_AND_RETURN(BOOL);
	} else if (strcmp(argType, @encode(char *)) == 0) {
		WRAP_AND_RETURN(const char *);
	} else if (strcmp(argType, @encode(void (^)(void))) == 0) {
		__unsafe_unretained id block = nil;
		[self getArgument:&block atIndex:(NSInteger)index];
		return [block copy];
	} else {
		NSUInteger valueSize = 0;
		NSGetSizeAndAlignment(argType, &valueSize, NULL);
		
		unsigned char valueBytes[valueSize];
		[self getArgument:valueBytes atIndex:(NSInteger)index];
		
		return [NSValue valueWithBytes:valueBytes objCType:argType];
	}
	return nil;
#undef WRAP_AND_RETURN
}

- (NSArray *)JCAOP_arguments {
	NSMutableArray *arguments = [NSMutableArray array];
	for (NSUInteger idx = 2; idx < self.methodSignature.numberOfArguments; idx++) {
		[arguments addObject:[self JCAOP_argumentAtIndex:idx] ?: NSNull.null];
	}
	return [arguments copy];
}

@end

@implementation JCAOPInfo

@synthesize arguments = _arguments;

- (instancetype)initWithInstance:(__unsafe_unretained id)instance invocation:(NSInvocation *)invocation
{
	NSCParameterAssert(instance);
	NSCParameterAssert(invocation);
	
	if (self = [super init]) {
		_instance = instance;
		_originalInvocation = invocation;
	}
	
	return self;
}

- (NSArray *)arguments {
	if (!_arguments) {
		_arguments = [_originalInvocation JCAOP_arguments];
	}
	return _arguments;
}

@end

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

@implementation NSObject (JCAOP)

+ (void)jc_hookSelector:(SEL)selector withExcuteOption:(JCAOPExecuteOptions)options usingBlock:(void (^)(JCAOPInfo *))block
{
	NSParameterAssert(selector);
	NSParameterAssert(block);
	
	jc_performLock(^{
		JCAOPContainer *aspectContainer = JC_getContainerForObject((NSObject *)self, selector);
		JCAOPItemInfo *itemInfo = [JCAOPItemInfo itemInfoWithSelector:selector object:self options:options block:block error:nil];
		[aspectContainer addAopItemInfo:itemInfo withOptions:options];
		JCAOP_prepareClassAndHookSelector((NSObject *)self, selector);
	});
}

- (void)jc_hookSelector:(SEL)selector withExcuteOption:(JCAOPExecuteOptions)options usingBlock:(void (^)(JCAOPInfo *aopInfo))block {
    NSParameterAssert(selector);
    NSParameterAssert(block);
	
	jc_performLock(^{
		JCAOPContainer *aspectContainer = JC_getContainerForObject(self, selector);
		JCAOPItemInfo *itemInfo = [JCAOPItemInfo itemInfoWithSelector:selector object:self options:options block:block error:nil];
		[aspectContainer addAopItemInfo:itemInfo withOptions:options];
		JCAOP_prepareClassAndHookSelector(self, selector);
	});
}

#pragma mark private Method

jc_perfomeLock_implementation

static JCAOPContainer *JC_getContainerForObject(NSObject *self, SEL selector) {
	NSCParameterAssert(self);
	NSCParameterAssert(selector);
	
	SEL aliasSelector = JCAOP_aliasForSelector(selector);
	JCAOPContainer *aopContainer = objc_getAssociatedObject(self, aliasSelector);
	if (!aopContainer) {
		aopContainer = [JCAOPContainer new];
		objc_setAssociatedObject(self, aliasSelector, aopContainer, OBJC_ASSOCIATION_RETAIN);
	}
	
	return aopContainer;
}

static JCAOPContainer *JC_getContainerForClass(Class kClass, SEL selector) {
	NSCParameterAssert(kClass);
	
	JCAOPContainer *aopContainer = nil;
	do {
		aopContainer = objc_getAssociatedObject(kClass, selector);
		if (aopContainer.hasAopItem) {
			break;
		}
	} while ((kClass = class_getSuperclass(kClass)));
	
	return aopContainer;
}

static NSString *const JCMessagePrefix = @"JC_";
static SEL JCAOP_aliasForSelector(SEL selector) {
	NSCParameterAssert(selector);
	return NSSelectorFromString([JCMessagePrefix stringByAppendingFormat:@"_%@", NSStringFromSelector(selector)]);
}

static void JCAOP_prepareClassAndHookSelector(NSObject *self, SEL selector) {
	NSCParameterAssert(selector);
	Class klass = jc_hookClass(self);
	Method targetMethod = class_getInstanceMethod(klass, selector);
	IMP targetMethodIMP = method_getImplementation(targetMethod);
	
	if (!jc_isMsgForwardIMP(targetMethodIMP)) {
		const char *typeEncoding = method_getTypeEncoding(targetMethod);
		SEL aliasSelector = JCAOP_aliasForSelector(selector);
		if (![klass instancesRespondToSelector:aliasSelector]) {
			__unused BOOL addedAlias = class_addMethod(klass, aliasSelector, method_getImplementation(targetMethod), typeEncoding);
		}
		class_replaceMethod(klass, selector, jc_getMsgForwardIMP(self, selector), typeEncoding);
	}
}

static NSString *const JCSubClassPrefix = @"_JC_";

static Class jc_hookClass(NSObject *self) {
	Class statedClass = self.class;
	Class baseClass = object_getClass(self);
	NSString *className = NSStringFromClass(baseClass);
	
	if ([className hasPrefix:JCSubClassPrefix]) {
		return baseClass;
	} else if (class_isMetaClass(baseClass)) {
		return jc_swizzleClassInPlace((Class)self);
	} else if (statedClass != baseClass) {
		return jc_swizzleClassInPlace(baseClass);
	}
	
	const char *subclassName = [JCSubClassPrefix stringByAppendingString:className].UTF8String;
	Class subclass = objc_getClass(subclassName);
	
	if (subclass == nil) {
		subclass = objc_allocateClassPair(baseClass, subclassName, 0);
		if (subclass == nil) {
			return nil;
		}
		
		jc_swizzleForwardInvocation(subclass);
		//实现当前类的isa指针指向原生的类
		jc_hookedGetClass(subclass, statedClass);
		//实现当前类的元类的isa指针指向原生的类
		jc_hookedGetClass(object_getClass(subclass), statedClass);
		objc_registerClassPair(subclass);
	}
	object_setClass(self, subclass);
	return subclass;
}

static Class jc_swizzleClassInPlace(Class klass) {
	NSCParameterAssert(klass);
	NSString *className = NSStringFromClass(klass);
	
	_jc_modifySwizzledClasses(^(NSMutableSet *swizzledClasses) {
		if (![swizzledClasses containsObject:className]) {
			jc_swizzleForwardInvocation(klass);
			[swizzledClasses addObject:className];
		}
	});
	return klass;
}

static void _jc_modifySwizzledClasses(void (^block)(NSMutableSet *swizzledClasses)) {
	static NSMutableSet *swizzledClasses;
	static dispatch_once_t pred;
	dispatch_once(&pred, ^{
		swizzledClasses = [NSMutableSet new];
	});
	@synchronized(swizzledClasses) {
		block(swizzledClasses);
	}
}

static void jc_swizzleForwardInvocation(Class klass) {
	NSCParameterAssert(klass);
	
	IMP originalImplementation = class_replaceMethod(klass, @selector(forwardInvocation:), (IMP)jc_hook_forwardInvocation, "v@:@");
	if (originalImplementation) {
		class_addMethod(klass, JCAOP_aliasForSelector(@selector(forwardInvocation:)), originalImplementation, "v@:@");
	}
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

#define JCAOP_invoke(aopItems, info) \
for (JCAOPItemInfo * itemInfo in aopItems) { \
	[itemInfo invokeWithInfo:info];	\
}

static void jc_hook_forwardInvocation(__unsafe_unretained NSObject *self, SEL selector, NSInvocation *invocation) {
	SEL originalSelector = invocation.selector;
	SEL aliasSelector = JCAOP_aliasForSelector(originalSelector);
	invocation.selector = aliasSelector;
	JCAOPContainer *objectContainer = objc_getAssociatedObject(self, aliasSelector);
	JCAOPContainer *classContainer = JC_getContainerForClass(object_getClass(self), aliasSelector);
	JCAOPInfo *info = [[JCAOPInfo alloc] initWithInstance:self invocation:invocation];
	
	JCAOP_invoke(classContainer.beforeAopItems, info);
	JCAOP_invoke(objectContainer.beforeAopItems, info);
	
	if (classContainer.insteadAopItems.count || objectContainer.insteadAopItems.count) {
		JCAOP_invoke(classContainer.insteadAopItems, info);
		JCAOP_invoke(objectContainer.insteadAopItems, info);
	} else {
		BOOL isRespond = YES;
		Class kClass = object_getClass(invocation.target);
		do {
			if ((isRespond = [kClass instancesRespondToSelector:aliasSelector])) {
				[invocation invoke];
				break;
			}
		} while (isRespond && (kClass = class_getSuperclass(kClass)));
	}
	
	JCAOP_invoke(classContainer.afterAopItems, info);
	JCAOP_invoke(objectContainer.afterAopItems, info);
}

static BOOL jc_isMsgForwardIMP(IMP impl) {
	return impl == _objc_msgForward
#if !defined(__arm64__)
	|| impl == (IMP)_objc_msgForward_stret
#endif
	;
}

@end
