//
//  NSObject+JCAssociated.m
//  WhichBargain
//
//  Created by Jam on 15/10/20.
//  Copyright © 2015年 nahuasuan. All rights reserved.
//

#import "NSObject+JCExtend.h"
#import <objc/runtime.h>

@implementation NSObject (JCExtend)

- (id)jc_getAssociatedObjectForKey:(NSString *)key {
    const char * propName = [key UTF8String];
    id currValue = objc_getAssociatedObject( self, propName );
    return currValue;
}

- (id)jc_retainAssociatedObject:(id)obj forKey:(NSString *)key {
    const char * propName = [key UTF8String];
    id oldValue = objc_getAssociatedObject(self, propName );
    objc_setAssociatedObject( self, propName, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    return oldValue;
}

@end
