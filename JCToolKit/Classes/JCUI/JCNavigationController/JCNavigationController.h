//
//  JCNavigationViewController.h
//  JCNavigationController
//
//  Created by Jam on 16/3/28.
//  Copyright © 2016年 Jam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCNavigationControllerBar <NSObject>

- (Class)jcNavigationBarClass;

@end

@interface JCNavigationController : UINavigationController

- (void)removeViewControllerAtIndex:(NSInteger)index;

@end

@interface UIViewController (JCNavigation)

@property (nonatomic, strong) JCNavigationController *jc_NavigationController;
@property (nonatomic, assign) BOOL jc_InteractivePopDisabled;

@end
