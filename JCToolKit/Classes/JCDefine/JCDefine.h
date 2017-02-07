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

#define jc_singleton_implementation  \
static id _instance; \
+ (instancetype)sharedInstance { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [[self alloc] init]; \
    }); \
    return _instance; \
}

@interface JCDefine : NSObject

@end
