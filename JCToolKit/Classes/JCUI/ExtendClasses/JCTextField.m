//
//  JCTextField.m
//  JCFindHouse
//
//  Created by 贾淼 on 14-8-2.
//  Copyright (c) 2014年 Hannover. All rights reserved.
//

#import "JCTextField.h"

@interface JCTextField ()

@property (nonatomic, assign) BOOL isDrawLine;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) JCLinePosition drawPosition;
@property (nonatomic, strong) UIColor *lineColor;

@end

@implementation JCTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isDrawLine = NO;
        _lineWidth = 0.0f;
        _lineColor = [UIColor colorWithWhite:198.0/255.0 alpha:1.0f];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _isDrawLine = NO;
        _lineWidth = 0.0f;
        _lineColor = [UIColor colorWithWhite:198.0/255.0 alpha:1.0f];
    }
    
    return self;
}

- (void)drawLineWithPosition:(JCLinePosition)linePosition withLineLength:(CGFloat)lineLength {
    if (linePosition == JCLineNone) {
        return;
    }
    _drawPosition = linePosition;
    _lineWidth = lineLength;
    [self setNeedsDisplay];
}

- (void)drawLineWidth:(CGFloat)lineWidth withCornerRadius:(CGFloat)cornerRadius
{
    _isDrawLine = YES;
    self.layer.cornerRadius = cornerRadius;
    _lineWidth = lineWidth*0.5;
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    if (_isDrawLine)
    {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadius];
        
        [[UIColor clearColor] setFill];
        [path fillWithBlendMode:kCGBlendModeColor alpha:1];
        [_lineColor setStroke];
        path.lineWidth = _lineWidth;
        
        [path addClip];
        [path stroke];
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Retain屏幕画1像素
    CGFloat bottomInset = 0.25;
    CGContextSaveGState(context);
    // draw
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    
    if (_drawPosition & JCLineHeader) {
        CGFloat xOffset = (rect.size.width - _lineWidth);
        CGContextMoveToPoint(context, xOffset, bottomInset);
        CGContextAddLineToPoint(context, CGRectGetWidth(rect), bottomInset);
    }

    if (_drawPosition & JCLineBottom) {
        CGFloat xOffset = (rect.size.width - _lineWidth);
        CGContextMoveToPoint(context, xOffset+5, CGRectGetHeight(rect)-bottomInset);
        CGContextAddLineToPoint(context, CGRectGetWidth(rect)-10, CGRectGetHeight(rect)-bottomInset);
    }
    
    if (_drawPosition & JCLineLeft) {
        CGFloat yOffset = (rect.size.height - _lineWidth);
        CGContextMoveToPoint(context, 0.25f, yOffset);
        CGContextAddLineToPoint(context, 0.25f, CGRectGetHeight(rect));
    }
    
    if (_drawPosition & JCLineRight) {
        CGFloat yOffset = (rect.size.height - _lineWidth);
        CGContextMoveToPoint(context, CGRectGetWidth(rect)-0.25, yOffset);
        CGContextAddLineToPoint(context, CGRectGetWidth(rect)-0.25, CGRectGetHeight(rect));
    }
    
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}


@end
