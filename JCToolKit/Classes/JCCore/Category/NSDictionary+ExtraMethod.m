//
//  NSDictionary+ExtraMethod.m
//  MYCloud
//
//  Created by Jam on 15/12/2.
//  Copyright © 2015年 Jam. All rights reserved.
//

#import "NSDictionary+ExtraMethod.h"

@implementation NSDictionary (ExtraMethod)

- (id)objectSafetyForKey:(NSString *)key {
    if ([[self objectForKey:key] isKindOfClass:[NSNull class]]) {
        return nil;
    } else if ([[self objectForKey:key] isKindOfClass:[NSString class]]) {
        NSString *value = [self objectForKey:key];
        if ([value isEqualToString:@""] || [value isEqualToString:@"NIL"] || [value isEqualToString:@"Nil"] || [value isEqualToString:@"nil"] || [value isEqualToString:@"nil"] || [value isEqualToString:@"NULL"] || [value isEqualToString:@"Null"] || [value isEqualToString:@"null"] || [value isEqualToString:@"(NULL)"] || [value isEqualToString:@"(null)"] || [value isEqualToString:@"<NULL>"] || [value isEqualToString:@"<Null>"] || [value isEqualToString:@"<null>"]) {
            return nil;
        }
    }
    
    return [self objectForKey:key];
}

@end
