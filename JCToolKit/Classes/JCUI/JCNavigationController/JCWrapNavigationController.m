//
//  JCWrapNavigationController.m
//  JCNavigationController
//
//  Created by Jam on 16/3/28.
//  Copyright © 2016年 Jam. All rights reserved.
//

#import "JCNavigationController.h"
#import "JCWrapNavigationController.h"
#import "JCWrapViewController.h"

@interface JCWrapNavigationController ()

@end

@implementation JCWrapNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popToRootViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController pushViewController:viewController animated:animated];
}


-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [self.navigationController dismissViewControllerAnimated:flag completion:completion];
    [self.viewControllers makeObjectsPerformSelector:@selector(setJc_NavigationController:) withObject:nil];
}

@end
