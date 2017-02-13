//
//  UIView+JCExtend.m
//  Pods
//
//  Created by 贾淼 on 17/2/8.
//
//

#import "UIView+JCExtend.h"
#import <objc/runtime.h>
#import "NSObject+JCExtend.h"
#import "Aspects.h"

@implementation UIView (JCExtend)

+ (void)load {
    [self aspect_hookSelector:@selector(drawRect:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo, CGRect rect){
        UIView *view = aspectInfo.instance;
        [view swizzled_drawRect:rect];
    } error:NULL];
}

- (void)swizzled_drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Retain屏幕画1像素
    CGFloat bottomInset = 0.25;
    CGContextSaveGState(context);
    // draw
    CGContextSetLineWidth(context, 0.5);
    UIColor *lineColor = [self lineColor];
    if (!lineColor) {
        lineColor = [UIColor blackColor];
    }
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    
    CGFloat lineLength = [self getJCLineLength];
    
    if (self.drawPosition & JCLineHeader) {
        CGFloat xOffset = (rect.size.width - lineLength);
        CGContextMoveToPoint(context, xOffset, bottomInset);
        CGContextAddLineToPoint(context, CGRectGetWidth(rect), bottomInset);
    }
    
    if (self.drawPosition & JCLineBottom) {
        CGFloat xOffset = (rect.size.width - lineLength);
        CGContextMoveToPoint(context, xOffset+5, CGRectGetHeight(rect)-bottomInset);
        CGContextAddLineToPoint(context, CGRectGetWidth(rect)-10, CGRectGetHeight(rect)-bottomInset);
    }
    
    if (self.drawPosition & JCLineLeft) {
        CGFloat yOffset = (rect.size.height - lineLength);
        CGContextMoveToPoint(context, 0.25f, yOffset);
        CGContextAddLineToPoint(context, 0.25f, CGRectGetHeight(rect));
    }
    
    if (self.drawPosition & JCLineRight) {
        CGFloat yOffset = (rect.size.height - lineLength);
        CGContextMoveToPoint(context, CGRectGetWidth(rect)-0.25, yOffset);
        CGContextAddLineToPoint(context, CGRectGetWidth(rect)-0.25, CGRectGetHeight(rect));
    }
    
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

//指定方位画默认宽度为1的线条
- (void)drawLineWithPosition:(JCLinePosition)linePosition withLineLength:(CGFloat)lineLength {
    self.drawPosition = linePosition;
    [self setJCLineLength:lineLength];
    [self setNeedsDisplay];
}


#pragma mark Getter/Setter

- (void)setDrawPosition:(JCLinePosition)drawPosition {
    [self jc_retainAssociatedObject:[NSNumber numberWithInt:drawPosition] forKey:"jc_DrawPosition"];
}

- (JCLinePosition)drawPosition {
    return [[self jc_getAssociatedObjectForKey:"jc_DrawPosition"] integerValue];
}

- (void)setJCLineLength:(CGFloat)lineLength {
    [self jc_retainAssociatedObject:[NSNumber numberWithFloat:lineLength] forKey:"jc_LineLength"];
}

- (CGFloat)getJCLineLength {
    return [[self jc_getAssociatedObjectForKey:"jc_LineLength"] floatValue];
}

- (void)setLineColor:(UIColor *)lineColor {
    [self jc_retainAssociatedObject:lineColor forKey:"jc_LineColor"];
}

- (UIColor *)lineColor {
    [self jc_getAssociatedObjectForKey:"jc_LineColor"];
}

@end
