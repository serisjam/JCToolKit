//
//  JCNavigationViewController.m
//  JCNavigationController
//
//  Created by Jam on 16/3/28.
//  Copyright © 2016年 Jam. All rights reserved.
//

#import "JCNavigationController.h"
#import "JCWrapViewController.h"
#import "NSObject+JCExtend.h"

@interface JCNavigationController () <UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *jc_PopPanGestureRecognizer;

@end

@implementation JCNavigationController

@synthesize jc_PopPanGestureRecognizer = _jc_PopPanGestureRecognizer;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UIViewController *controller = self.viewControllers.firstObject;
        self.viewControllers = @[];
        [self pushViewController:controller animated:NO];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    
    if (self = [super initWithRootViewController:rootViewController]) {
        self.viewControllers = @[];
        [self pushViewController:rootViewController animated:NO];
    }
    return self;
}

- (UIPanGestureRecognizer *)jc_PopPanGestureRecognizer {
    if (!_jc_PopPanGestureRecognizer) {
        _jc_PopPanGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        _jc_PopPanGestureRecognizer.maximumNumberOfTouches = 1;
    }
    return _jc_PopPanGestureRecognizer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarHidden:YES];

    // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
    [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.jc_PopPanGestureRecognizer];

    // Forward the gesture events to the private handler of the onboard gesture recognizer.
    NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
    id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
    SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
    self.jc_PopPanGestureRecognizer.delegate = self;
    [self.jc_PopPanGestureRecognizer addTarget:internalTarget action:internalAction];

    // Disable the onboard gesture recognizer.
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (!viewController.navigationItem.leftBarButtonItem && [self.viewControllers count] != 0) {
        UIImage *backImage = [UIImage imageNamed:@"item_back" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:nil action:@selector(didTapBackButton)];
    }
    viewController.jc_NavigationController = self;
    [super pushViewController:[JCWrapViewController wrapViewControllerWithRootController:viewController] animated:animated];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:[viewControllers count]];
    for (UIViewController *viewController in viewControllers) {
        if ([viewController isKindOfClass:[JCWrapViewController class]]) {
            [controllers addObject:viewController];
        } else {
            if ([viewControllers indexOfObject:viewController] != 0) {
                UIImage *backImage = [UIImage imageNamed:@"item_back" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
                viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:nil action:@selector(didTapBackButton)];
            }
            [controllers addObject:[JCWrapViewController wrapViewControllerWithRootController:viewController]];
        }
        viewController.jc_NavigationController = self;
    }
    [super setViewControllers:controllers animated:animated];
}

- (void)didTapBackButton {
    [self popViewControllerAnimated:YES];
}

#pragma mark public method

- (void)removeViewControllerAtIndex:(NSInteger)index {
    if (index < 0 || index > [self.viewControllers count]) {
        return ;
    }
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    [viewControllers removeObjectAtIndex:index];
    self.viewControllers = viewControllers;
}

#pragma mark - UINavigationControllerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer; {

    JCWrapViewController *wrapViewController = self.topViewController;
    if (wrapViewController.rootViewController.jc_InteractivePopDisabled) {
        return NO;
    }

    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }

    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    BOOL isLeftToRight = [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight;
    CGFloat multiplier = isLeftToRight ? 1 : - 1;
    if ((translation.x * multiplier) <= 0) {
        return NO;
    }
    
    return self.childViewControllers.count > 1;
}

@end

@implementation UIViewController (JCNavigation)

- (void)setJc_NavigationController:(JCNavigationController *)jc_NavigationController {
    [self jc_retainAssociatedObject:jc_NavigationController forKey:@"jc_navigationController"];
}

- (JCNavigationController *)jc_NavigationController {
    return [self jc_getAssociatedObjectForKey:@"jc_navigationController"];
}

- (void)setJc_InteractivePopDisabled:(BOOL)jc_InteractivePopDisabled {
    [self jc_retainAssociatedObject:@(jc_InteractivePopDisabled) forKey:@"jc_interactivePopDisabled"];
}

- (BOOL)jc_InteractivePopDisabled {
    return [[self jc_getAssociatedObjectForKey:@"jc_interactivePopDisabled"] boolValue];
}

@end
