//
//  JCMediatorProtocl.m
//  JCToolKit
//
//  Created by Jam Jia on 9/13/18.
//

#import "JCMediatorProtocl.h"

@interface JCMediatorProtocl ()

@property (nonatomic, strong) NSMutableSet *serviceProvideSet;

@end

@implementation JCMediatorProtocl

jc_singleton_implementation

- (instancetype)init
{
	self = [super init];
	
	if (self) {
		self.serviceProvideSet = [NSMutableSet set];		
	}
	return self;
}

- (id)getServiceProvide:(NSString *)serviceTargetName withProtocl:(Protocol *)protocol
{
	if ([serviceTargetName length] == 0 || !protocol) {
		return nil;
	}

	id serviceTarget = [self.serviceProvideSet valueForKey:NSStringFromProtocol(protocol)];
	if (serviceTarget) {
		return serviceTarget;
	}
	
	NSString *targetClassName = [JCServicePrefix stringByAppendingString:serviceTargetName];
	Class targetClass = NSClassFromString(targetClassName);
	serviceTarget = [[targetClass alloc] init];
	
	if ( [serviceTarget conformsToProtocol:protocol] ) {
		return serviceTarget;
	}
	
	return nil;
}

@end
