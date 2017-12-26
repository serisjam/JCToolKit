//
//  JCRouter.h
//  JCKitHelp
//
//  Created by 贾淼 on 16/9/29.
//  Copyright © 2016年 Jam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCRouter : NSObject

@property (nonatomic, strong) Class defaultNavigationClass;

+ (instancetype)shareRouter;

- (void)mapKey:(NSString *)key toController:(Class)controllerClass;
- (__kindof UIViewController *)mapObjectForKey:(NSString *)key withExtraParams:(NSDictionary *)extraParams;
- (__kindof UIViewController *)currentViewController;

- (void)pushURL:(NSString *)urlString;
- (void)pushURL:(NSString *)urlString extraParams:(NSDictionary *)extraParams;
- (void)pushURL:(NSString *)urlString extraParams:(NSDictionary *)extraParams animated:(BOOL)animated;
- (void)pushURL:(NSString *)urlString extraParams:(NSDictionary *)extraParams withIndex:(NSInteger)index animated:(BOOL)animated;

- (void)presentURL:(NSString *)urlString completion:(void (^)(void))completion;
- (void)presentURL:(NSString *)urlString withNavigationClass:(Class)navigationClass completion:(void (^)(void))completion;
- (void)presentURL:(NSString *)urlString extraParams:(NSDictionary *)extraParams withNavigationClass:(Class)navigationClass completion:(void (^)(void))completion;
- (void)presentURL:(NSString *)urlString extraParams:(NSDictionary *)extraParams withNavigationClass:(Class)navigationClass animated:(BOOL)animated completion:(void (^)(void))completion;

- (void)popViewControllerAnimated:(BOOL)animated;
//回跳到第几层, A->B->C,那么当index为1时跳转到B， index为2跳转到A
- (void)popViewControllerWithIndex:(NSInteger)index animated:(BOOL)animated;
- (void)popToRootViewControllerAnimated:(BOOL)animated;
- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismissViewControllerWithIndex:(NSInteger)index animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismissToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
