//
//  NSObject+JCAssociated.h
//  WhichBargain
//
//  Created by Jam on 15/10/20.
//  Copyright © 2015年 nahuasuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JCExtend)

- (id)jc_getAssociatedObjectForKey:(NSString *)key;
- (id)jc_retainAssociatedObject:(id)obj forKey:(NSString *)key;

@end
