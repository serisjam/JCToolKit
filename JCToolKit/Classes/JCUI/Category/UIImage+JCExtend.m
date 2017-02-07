//
//  UIImage+JCExtend.m
//  Pods
//
//  Created by 唐 on 16/12/18.
//
//

#import "UIImage+JCExtend.h"

#import <Accelerate/Accelerate.h>

@implementation UIImage (JCExtend)

- (UIImage*)jc_subImage:(CGRect)rect {
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage *subImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return subImage;
}

- (UIImage*)jc_scaleToSize:(CGSize)size {
    CGImageRef inImageRef = self.CGImage;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(inImageRef);
    CFDataRef inBitmapData       = CGDataProviderCopyData(inProvider);
    
    vImage_Buffer inBuffer = {
        .data     = (void *)CFDataGetBytePtr(inBitmapData),
        .width    = CGImageGetWidth(inImageRef),
        .height   = CGImageGetHeight(inImageRef),
        .rowBytes = CGImageGetBytesPerRow(inImageRef),
    };
    
    void *outBytes          = malloc(trunc(size.width * size.height * inBuffer.rowBytes));
    vImage_Buffer outBuffer = {
        .data     = outBytes,
        .width    = trunc(size.width),
        .height   = trunc(size.height),
        .rowBytes = inBuffer.rowBytes,
    };
    
    vImage_Error error =
    vImageScale_ARGB8888(&inBuffer,
                         &outBuffer,
                         NULL,
                         kvImageHighQualityResampling);
    if (error)
    {
        return nil;
    }
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef c                = CGBitmapContextCreate(outBuffer.data,
                                                          outBuffer.width,
                                                          outBuffer.height,
                                                          8,
                                                          outBuffer.rowBytes,
                                                          colorSpaceRef,
                                                          kCGImageAlphaNoneSkipLast);
    CGImageRef outImageRef = CGBitmapContextCreateImage(c);
    UIImage *outImage      = [UIImage imageWithCGImage:outImageRef];
    
    CGImageRelease(outImageRef);
    CGContextRelease(c);
    CGColorSpaceRelease(colorSpaceRef);
    CFRelease(inBitmapData);
    
    return outImage;
}

- (UIImage *)jc_stretched:(UIEdgeInsets)capInsets {
    return [self resizableImageWithCapInsets:capInsets];
}

- (UIImage *)jc_grayscale {
    CGSize size = self.size;
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context       = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, rect, [self CGImage]);
    CGImageRef grayscale = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage *image = [UIImage imageWithCGImage:grayscale];
    CFRelease(grayscale);
    
    return image;
}

- (UIColor *)jc_patternColor {
    return [UIColor colorWithPatternImage:self];
}

//画圆角内联方法

// UIKit坐标系统原点在左上角，y方向向下的（坐标系A），但在Quartz中坐标系原点在左下角，y方向向上的(坐标系B)。图片绘制也是颠倒的。
static void jc_addRoundedRectToPath(CGContextRef context, CGRect rect, float radius, UIRectCorner corners) {
    //原点在左下方，y方向向上。移动到线条2的起点。
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
    
    //画出线条2, 目前画线的起始点已经移动到线条2的结束地方了。
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
    
    //如果左上角需要画圆角，画出一个弧线出来。
    if (corners & UIRectCornerTopLeft) {
        //已左上的正方形的右下脚为圆心，半径为radius， 180度到90度画一个弧线，
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI / 2, 1);
    } else {
        //如果不需要画左上角的弧度。从线2终点，画到线3的终点，
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
        
        //线3终点，画到线4的起点
        CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y + rect.size.height);
    }
    
    //画线4的起始，到线4的终点
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius,
                            rect.origin.y + rect.size.height);
    
    //画右上角
    if (corners & UIRectCornerTopRight) {
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
    } else {
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - radius);
    }
    
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
    
    //画右下角弧线
    if (corners & UIRectCornerBottomRight) {
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI / 2, 1);
    } else {
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, rect.origin.y);
    }
    
    CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
    
    //画左下角弧线
    if (corners & UIRectCornerBottomRight) {
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI / 2, M_PI, 1);
    } else {
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + radius);
    }
    
    CGContextClosePath(context);
}

- (UIImage *)jc_roundingCorners:(UIRectCorner)corners withRadius:(float)radius {
    UIImageView *bkImageViewTmp = [[UIImageView alloc] initWithImage:self];
    
    int w = self.size.width;
    int h = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context       = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    jc_addRoundedRectToPath(context, bkImageViewTmp.frame, radius, corners);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageMasked];
    
    CGImageRelease(imageMasked);
    
    return newImage;
}

+ (UIImage *)jc_imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)jc_imageWithBlurRadius:(CGFloat)blurRadius {
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage, @"inputRadius", @(blurRadius), nil];
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef outImage = [context createCGImage:outputImage fromRect:[inputImage extent]];
    return [UIImage imageWithCGImage:outImage];
}

@end
