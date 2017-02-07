//
//  JCDefine.h
//  Pods
//
//  Created by 贾淼 on 17/2/7.
//
//

#import <Foundation/Foundation.h>

//弱引用
#define jc_weakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
//弱引用之后强引用
#define jc_strongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

#define jc_weakSelf __weak typeof(self) selfWeak = self;
//必须先定义上面的弱引用之后才能使用
#define jc_strongSelf __strong typeof(self) selfStrong = selfWeak;

//单例类
#define jc_singleton \
+ (instancetype)sharedInstance;

#define jc_singleton_implementation(className)  \
+ (instancetype)sharedInstance { \
    static className *shared##className = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        shared##className = [[self alloc] init]; \
    }); \
    return shared##className; \
}

@interface JCDefine : NSObject

@end
