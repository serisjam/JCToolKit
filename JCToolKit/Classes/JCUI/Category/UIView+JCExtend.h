//
//  UIView+JCExtend.h
//  Pods
//
//  Created by 贾淼 on 17/2/8.
//
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS (NSUInteger, JCLinePosition){
    JCLineNone = 0,
    JCLineHeader = 1 << 0,
    JCLineBottom = 1 << 1,
    JCLineLeft = 1 << 2,
    JCLineRight = 1 << 3
};

@interface UIView (JCExtend)

@property (nonatomic, assign) BOOL isDrawLine;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) JCLinePosition drawPosition;
@property (nonatomic, strong) UIColor *lineColor;

//指定方位画默认宽度为1的线条
- (void)drawLineWithPosition:(JCLinePosition)linePosition withLineLength:(CGFloat)lineLength;

//画边框带圆角
- (void)drawLineWidth:(CGFloat)lineWidth withCornerRadius:(CGFloat)cornerRadius;
- (void)setLineColor:(UIColor *)lineColor;

@end
