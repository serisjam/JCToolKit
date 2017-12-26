//
//  JCRouter.m
//  JCKitHelp
//
//  Created by 贾淼 on 16/9/29.
//  Copyright © 2016年 Jam. All rights reserved.
//

#import "JCRouter.h"
#import "JCRouterParams.h"


@interface JCRouter ()

@property (nonatomic, strong) NSMutableDictionary *routes;
@property (nonatomic, strong) NSMutableDictionary *cacheRoutes;

@end

@implementation JCRouter

+ (instancetype)shareRouter {
    static JCRouter *shareRouter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareRouter = [[JCRouter alloc] init];
    });
    
    return shareRouter;
}

- (id<UIApplicationDelegate>)applicationDelegate {
    return [UIApplication sharedApplication].delegate;
}

- (UINavigationController *)currentNavigationViewController {
    UIViewController* currentViewController = self.rootViewController;
    return currentViewController.navigationController;
}

- (UIViewController *)rootViewController {
    UIViewController* rootViewController = self.applicationDelegate.window.rootViewController;
    return [self currentViewControllerFrom:rootViewController];
}

// 通过递归拿到当前控制器
- (UIViewController *)currentViewControllerFrom:(UIViewController*)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController *)viewController;
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
    } // 如果传入的控制器是导航控制器,则返回最后一个
    else if([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
    } // 如果传入的控制器是tabBar控制器,则返回选中的那个
    else if(viewController.presentedViewController != nil) {
        return [self currentViewControllerFrom:viewController.presentedViewController];
    } // 如果传入的控制器发生了modal,则就可以拿到modal的那个控制器
    else {
        return viewController;
    }
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.routes = [[NSMutableDictionary alloc] init];
        self.defaultNavigationClass = [UINavigationController class];
    }
    
    return self;
}

- (void)mapKey:(NSString *)key toController:(Class)controllerClass {
    if (!key) {
        @throw [NSException exceptionWithName:@"映射路由不能创建"
                                       reason:@"路由映射关键值不能为空"
                                     userInfo:nil];
        return;
    }
    
    [self.routes setObject:controllerClass forKey:key];
}

- (__kindof UIViewController *)mapObjectForKey:(NSString *)key withExtraParams:(NSDictionary *)extraParams {
    if (!key) {
        @throw [NSException exceptionWithName:@"映射路由不能创建"
                                       reason:@"路由映射关键值不能为空"
                                     userInfo:nil];
        return nil;
    }
    
    JCRouterParams *routerParams = [self routerParamsForUrl:key withextraParams:extraParams];
    UIViewController *controller = [self controllerForRouterOption:routerParams];
    
    return controller;
}

- (__kindof UIViewController *)currentViewController {
    return self.rootViewController;
}

- (void)pushURL:(NSString *)urlString {
    [self pushURL:urlString extraParams:nil];
}

- (void)pushURL:(NSString *)urlString extraParams:(NSDictionary *)extraParams {
    [self pushURL:urlString extraParams:extraParams animated:YES];
}

- (void)pushURL:(NSString *)urlString extraParams:(NSDictionary *)extraParams animated:(BOOL)animated {
    JCRouterParams *routerParams = [self routerParamsForUrl:urlString withextraParams:extraParams];
    UIViewController *controller = [self controllerForRouterOption:routerParams];
    
    if (self.currentNavigationViewController) {
        [self.currentNavigationViewController pushViewController:controller animated:animated];
    } else {
        UINavigationController *navc = [[self.defaultNavigationClass alloc] initWithRootViewController:controller];
        self.applicationDelegate.window.rootViewController = navc;
    }
}

- (void)popViewControllerAnimated:(BOOL)animated {
    [self popViewControllerWithIndex:1 animated:animated];
}

- (void)popViewControllerWithIndex:(NSInteger)index animated:(BOOL)animated {
    if (self.currentNavigationViewController) {
        NSInteger count = [[self.currentNavigationViewController viewControllers] count];
        if (count > index) {
            [self.currentNavigationViewController popToViewController:[[self.currentNavigationViewController viewControllers] objectAtIndex:count-1-index] animated:animated];
        } else {
            return ;
        }
    }
}

- (void)pushURL:(NSString *)urlString extraParams:(NSDictionary *)extraParams withIndex:(NSInteger)index animated:(BOOL)animated {
    
    [self pushURL:urlString extraParams:extraParams animated:animated];
    if (index <= 0) return;
    //TODO 以后改为切面编程 ，切didappear
    if (animated) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeViewControllerWithIndex:index];
        });
        return;
    }
    
    [self removeViewControllerWithIndex:index];
}

- (void)removeViewControllerWithIndex:(NSInteger)index {
    if (self.currentNavigationViewController) {
        NSMutableArray *viewControllers =  [NSMutableArray arrayWithArray:[self.currentNavigationViewController viewControllers]];
        NSInteger count = [[self.currentNavigationViewController viewControllers] count];
        if (count > index) {
            [viewControllers removeObjectsInRange:NSMakeRange(count - index -1, index)];
            [self.currentNavigationViewController setViewControllers:viewControllers animated:NO];
        }
    }
}


- (void)popToRootViewControllerAnimated:(BOOL)animated {
    [self.currentNavigationViewController popToRootViewControllerAnimated:animated];
}

- (void)presentURL:(NSString *)urlString completion:(void (^)(void))completion {
    [self presentURL:urlString withNavigationClass:nil completion:completion];
}

- (void)presentURL:(NSString *)urlString withNavigationClass:(Class)navigationClass completion:(void (^)(void))completion {
    [self presentURL:urlString extraParams:nil withNavigationClass:navigationClass completion:completion];
}

- (void)presentURL:(NSString *)urlString extraParams:(NSDictionary *)extraParams withNavigationClass:(Class)navigationClass completion:(void (^)(void))completion {
    [self presentURL:urlString extraParams:extraParams withNavigationClass:navigationClass animated:YES completion:completion];
}

- (void)presentURL:(NSString *)urlString extraParams:(NSDictionary *)extraParams withNavigationClass:(Class)navigationClass animated:(BOOL)animated completion:(void (^)(void))completion {
    JCRouterParams *routerParams = [self routerParamsForUrl:urlString withextraParams:extraParams];
    UIViewController *controller = [self controllerForRouterOption:routerParams];
    
    if (navigationClass) {
        controller = [[navigationClass alloc] initWithRootViewController:controller];
    }
    
    if (self.rootViewController) {
        [self.rootViewController presentViewController:controller animated:animated completion:completion];
    } else {
        self.applicationDelegate.window.rootViewController = controller;
    }
}

- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self dismissViewControllerWithIndex:0 animated:animated completion:completion];
}

- (void)dismissViewControllerWithIndex:(NSInteger)index animated:(BOOL)animated completion:(void (^)(void))completion {
    UIViewController *rootVC = self.rootViewController;
    if (rootVC) {
        while (index > 0) {
            rootVC = rootVC.presentingViewController;
            index -= 1;
        }
        [rootVC dismissViewControllerAnimated:YES completion:completion];
    }
    
    if (!rootVC.presentedViewController) {
        return ;
    }
}

- (void)dismissToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    UIViewController *rootVC = self.rootViewController;
    if (rootVC) {
        NSInteger index = 1;
        while (index) {
            if (!rootVC.presentingViewController) {
                index = 0;
                break;
            }
            rootVC = rootVC.presentingViewController;
            
        }
        [rootVC dismissViewControllerAnimated:YES completion:completion];
    }
    
    if (!rootVC.presentedViewController) {
        return ;
    }
}

//构造一个JCRouterPararms
- (JCRouterParams *)routerParamsForUrl:(NSString *)urlString withextraParams:(NSDictionary *)extraParams {
    if (!urlString) {
        @throw [NSException exceptionWithName:@"映射路由不能创建"
                                       reason:@"路由映射路径不能为空"
                                     userInfo:nil];
    }
    
    if ([self.cacheRoutes objectForKey:urlString] && !extraParams) {
        return [self.cacheRoutes objectForKey:urlString];
    }
    
    NSArray *parts = urlString.pathComponents;
    NSArray *paramsParts = [urlString componentsSeparatedByString:@"/"];
    
    if ([parts count] != [paramsParts count]) {
        parts = paramsParts;
    }
    
    __block JCRouterParams *routerParams = nil;
    
    [self.routes enumerateKeysAndObjectsUsingBlock:^(NSString *routerUrl, Class controllerClass, BOOL *stop){
        NSArray *routerParts = [routerUrl pathComponents];
        
        if ([routerParts count] == [paramsParts count]) {
            NSDictionary *givenParams = [self paramsForUrlComponents:parts routerUrlComponents:routerParts];
            if (givenParams) {
                routerParams = [[JCRouterParams alloc] initWithControllerClass:controllerClass openParams:givenParams extraParams: extraParams];
                *stop = YES;
            }
        }
    }];
    
    if (!routerParams) {
        @throw [NSException exceptionWithName:@"映射路由不能创建"
                                       reason:@"路由映射路径不能为空"
                                     userInfo:nil];
    }
    
    [self.cacheRoutes setObject:routerParams forKey:urlString];
    return routerParams;
}

- (NSDictionary *)paramsForUrlComponents:(NSArray *)givenUrlComponents
                     routerUrlComponents:(NSArray *)routerUrlComponents {
    
    __block NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [routerUrlComponents enumerateObjectsUsingBlock:
     ^(NSString *routerComponent, NSUInteger idx, BOOL *stop) {
         
         NSString *givenComponent = givenUrlComponents[idx];
         if ([routerComponent hasPrefix:@":"]) {
             NSString *key = [routerComponent substringFromIndex:1];
             [params setObject:givenComponent forKey:key];
         }
         else if (![routerComponent isEqualToString:givenComponent]) {
             params = nil;
             *stop = YES;
         }
     }];
    return params;
}

- (UIViewController *)controllerForRouterOption:(JCRouterParams *)routerParams {
    SEL CONTROLLER_CLASS_SELECTOR = sel_registerName("allocWithRouterParams:");
    SEL CONTROLLER_SELECTOR = sel_registerName("initWithRouterParams:");
    UIViewController *controller = nil;
    
    Class controllerClass = routerParams.controllerClass;
    
    if ([controllerClass respondsToSelector:CONTROLLER_CLASS_SELECTOR]) {
        NSMethodSignature *sig  = [controllerClass methodSignatureForSelector:CONTROLLER_CLASS_SELECTOR];
        NSInvocation *invocatin = [NSInvocation invocationWithMethodSignature:sig];
        [invocatin setTarget:controllerClass];
        [invocatin setSelector:CONTROLLER_CLASS_SELECTOR];
        NSDictionary *paramsDic = [routerParams controllerParams];
        [invocatin setArgument:&paramsDic atIndex:2];
        [invocatin invoke];
        [invocatin getReturnValue: &controller];
    }
    else if ([controllerClass instancesRespondToSelector:CONTROLLER_SELECTOR]) {
        UIViewController *target = [controllerClass alloc];
        NSMethodSignature *sig  = [controllerClass instanceMethodSignatureForSelector:CONTROLLER_SELECTOR];
        NSInvocation *invocatin = [NSInvocation invocationWithMethodSignature:sig];
        [invocatin setTarget:target];
        [invocatin setSelector:CONTROLLER_SELECTOR];
        NSDictionary *paramsDic = [routerParams controllerParams];
        [invocatin setArgument:&paramsDic atIndex:2];
        [invocatin invoke];
        controller = target;
    }
    
    return controller;
}

//Stack operations
- (void)popViewControllerFromRouterAnimated:(BOOL)animated {
    if (self.rootViewController.presentedViewController) {
        [self.rootViewController dismissViewControllerAnimated:animated completion:nil];
    }
    else {
        [(UINavigationController *)self.rootViewController popViewControllerAnimated:animated];
    }
}
- (void)pop {
    [self popViewControllerFromRouterAnimated:YES];
}

- (void)pop:(BOOL)animated {
    [self popViewControllerFromRouterAnimated:animated];
}

@end
