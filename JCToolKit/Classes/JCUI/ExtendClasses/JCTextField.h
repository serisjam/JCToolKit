//
//  JCTextField.h
//  JCFindHouse
//
//  Created by 贾淼 on 14-8-2.
//  Copyright (c) 2014年 Hannover. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS (NSUInteger, JCLinePosition){
    JCLineNone = 0,
    JCLineHeader = 1 << 0,
    JCLineBottom = 1 << 1,
    JCLineLeft = 1 << 2,
    JCLineRight = 1 << 3
};

@interface JCTextField : UITextField

- (void)drawOnePixLineWithLocation:(JCLinePosition)lineLocation andHeaderLength:(CGFloat)headerLength andBottomLength:(CGFloat)bottomLength andLeftLength:(CGFloat)leftLength andRightLength:(CGFloat)rightLength;

//为那个方位画默认宽度为1的线条
- (void)drawLineWithPosition:(JCLinePosition)linePosition withLineLength:(CGFloat)lineLength;

//画边框带圆角
- (void)drawLineWidth:(CGFloat)lineWidth withCornerRadius:(CGFloat)cornerRadius;
- (void)setLineColor:(UIColor *)lineColor;

@end
