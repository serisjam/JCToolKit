//
//  JCRouterParams.m
//  JCKitHelp
//
//  Created by seris-Jam on 16/10/9.
//  Copyright © 2016年 Jam. All rights reserved.
//

#import "JCRouterParams.h"

@interface JCRouterParams ()

@property (nonatomic, strong) NSDictionary *openParams;
@property (nonatomic, strong) NSDictionary *extraParams;

@end

@implementation JCRouterParams

- (instancetype)initWithControllerClass:(Class)controllerClass openParams:(NSDictionary *)openParams extraParams:(NSDictionary *)extraParams {
    self = [super init];
    
    if (self) {
        _controllerClass = controllerClass;
        self.openParams = openParams;
        self.extraParams = extraParams;
    }
    
    return self;
}

- (NSDictionary *)controllerParams  {
    NSMutableDictionary *controllerParams = [NSMutableDictionary dictionary];
    [controllerParams addEntriesFromDictionary:self.extraParams];
    [controllerParams addEntriesFromDictionary:self.openParams];
    return controllerParams;
}

@end
