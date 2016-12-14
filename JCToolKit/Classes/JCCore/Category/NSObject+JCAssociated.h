//
//  NSObject+JCAssociated.h
//  WhichBargain
//
//  Created by Jam on 15/10/20.
//  Copyright © 2015年 nahuasuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JCAssociated)

- (id)jc_getAssociatedObjectForKey:(const char *)key;
- (id)jc_retainAssociatedObject:(id)obj forKey:(const char *)key;

@end
