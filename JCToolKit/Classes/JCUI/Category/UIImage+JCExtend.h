//
//  UIImage+JCExtend.h
//  Pods
//
//  Created by Jam on 16/12/18.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (JCExtend)

// 获取图片制定位置子图片
- (UIImage*)jc_subImage:(CGRect)rect;

// 缩放到指定size
- (UIImage*)jc_scaleToSize:(CGSize)size;

// 拉伸
- (UIImage *)jc_stretched:(UIEdgeInsets)capInsets;

// 灰度
- (UIImage *)jc_grayscale;

// 创建并返回使用指定的图像中的颜色对象。
- (UIColor *)jc_patternColor;

// 圆角类似UIBezierPath的圆角操作
- (UIImage *)jc_roundingCorners:(UIRectCorner)corners withRadius:(float)radius;

// 由颜色返回图片
+ (UIImage *)jc_imageWithColor:(UIColor *)color size:(CGSize)size;

// 高斯模糊
- (UIImage *)jc_imageWithBlurRadius:(CGFloat)blurRadius;

@end
