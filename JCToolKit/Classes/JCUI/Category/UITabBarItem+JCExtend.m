//
//  UITabBarItem+JCExtend.m
//  Pods
//
//  Created by Jam on 17/2/7.
//
//

#import "UITabBarItem+JCExtend.h"

@implementation UITabBarItem (JCExtend)

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    UIImage *normalImage     = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage     = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectImage];
    [tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    return tabBarItem;
}

@end
