//
//  JCMediatorProtocol.m
//  JCToolKit
//
//  Created by Jam Jia on 9/13/18.
//

#import "JCMediatorProtocol.h"

@interface JCMediatorProtocol ()

@property (nonatomic, strong) NSMutableDictionary *serviceProvideDic;

@end

@implementation JCMediatorProtocol

jc_singleton_implementation

- (instancetype)init
{
	self = [super init];
	
	if (self) {
		self.serviceProvideDic = [NSMutableDictionary dictionary];
	}
	return self;
}

- (id)getServiceProvide:(NSString *)serviceTargetName withProtocl:(Protocol *)protocol shouldCacheService:(BOOL)shouldCache
{
	if ([serviceTargetName length] == 0 || !protocol) {
		return nil;
	}

	id serviceTarget = [self.serviceProvideDic valueForKey:NSStringFromProtocol(protocol)];
	if (serviceTarget) {
		return serviceTarget;
	}
	
	NSString *targetClassName = [JCServicePrefix stringByAppendingString:serviceTargetName];
	Class targetClass = NSClassFromString(targetClassName);
	serviceTarget = [[targetClass alloc] init];
	
	if ( [serviceTarget conformsToProtocol:protocol] ) {
		
		if (shouldCache) {
			[self.serviceProvideDic setObject:serviceTarget forKey:NSStringFromProtocol(protocol)];
		}
		
		return serviceTarget;
	}
	
	return nil;
}

- (void)removeServiceWithProtocl:(Protocol *)protocol
{
	[self.serviceProvideDic removeObjectForKey:NSStringFromProtocol(protocol)];
}

@end
