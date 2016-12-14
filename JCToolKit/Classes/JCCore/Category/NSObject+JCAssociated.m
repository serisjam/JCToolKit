//
//  NSObject+JCAssociated.m
//  WhichBargain
//
//  Created by Jam on 15/10/20.
//  Copyright © 2015年 nahuasuan. All rights reserved.
//

#import "NSObject+JCAssociated.h"
#import <objc/runtime.h>

@implementation NSObject (JCAssociated)

- (id)jc_getAssociatedObjectForKey:(const char *)key {
    const char * propName = key;
    id currValue = objc_getAssociatedObject( self, propName );
    return currValue;
}

- (id)jc_retainAssociatedObject:(id)obj forKey:(const char *)key {
    const char * propName = key;
    id oldValue = objc_getAssociatedObject(self, propName );
    objc_setAssociatedObject( self, propName, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    return oldValue;
}

@end
