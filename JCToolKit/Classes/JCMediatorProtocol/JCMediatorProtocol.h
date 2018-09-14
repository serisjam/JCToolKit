//
//  JCMediatorProtocol.h
//  JCToolKit
//
//  Created by Jam Jia on 9/13/18.
//

#import "JCDefine.h"

#define JCServicePrefix @"JC"

@interface JCMediatorProtocol : NSObject

jc_singleton

- (id)getServiceProvide:(NSString *)serviceTargetName withProtocl:(Protocol *)protocol shouldCacheService:(BOOL)shouldCache;
- (void)removeServiceWithProtocl:(Protocol *)protocol;

@end
