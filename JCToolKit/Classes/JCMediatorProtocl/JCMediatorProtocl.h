//
//  JCMediatorProtocl.h
//  JCToolKit
//
//  Created by Jam Jia on 9/13/18.
//

#import "JCDefine.h"

NSString * const JCServicePrefix = @"JC";

@interface JCMediatorProtocl : NSObject

jc_singleton

- (id)getServiceProvide:(NSString *)serviceTargetName withProtocl:(Protocol *)protocol;

@end
