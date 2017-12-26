//
//  JCRouterParams.h
//  JCKitHelp
//
//  Created by seris-Jam on 16/10/9.
//  Copyright © 2016年 Jam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCRouterParams : NSObject

@property (nonatomic, strong, readonly) Class controllerClass;

- (instancetype)initWithControllerClass:(Class)controllerClass openParams:(NSDictionary *)openParams extraParams:(NSDictionary *)extraParams;
- (NSDictionary *)controllerParams;

@end
