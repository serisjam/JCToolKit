//
//  JCToolKit_Core.h
//  Pods
//
//  Created by 贾淼 on 16/12/14.
//
//

#ifndef JCToolKit_Core_h
#define JCToolKit_Core_h

//弱引用
#define jc_weakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
//弱引用之后强引用
#define jc_strongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

#define jc_weakSelf __weak typeof(self) selfWeak = self;
//必须先定义上面的弱引用之后才能使用
#define jc_strongSelf __strong typeof(self) selfStrong = selfWeak;

#import "NSObject+JCExtend.h"
#import "NSData+JCExtend.h"
#import "NSTimer+JCExtend.h"
#import "NSString+JCExtend.h"
#import "NSArray+JCExtend.h"
#import "NSDictionary+JCExtend.h"

#import "NSObject+JCAOP.h"
#import "JCDeviceInfo.h"

#endif /* JCToolKit_Core_h */
