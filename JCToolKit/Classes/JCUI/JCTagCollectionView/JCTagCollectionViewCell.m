//
//  JCTagCollectionViewCell.m
//  DemoCollectionView
//
//  Created by Jam on 16/4/20.
//  Copyright © 2016年 Jam. All rights reserved.
//

#import "JCTagCollectionViewCell.h"

@implementation JCTagCollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.layer.masksToBounds = YES;
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat width = scale > 0.0 ? 1.0 / scale : 1.0;
    self.layer.borderWidth = width;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_titleLabel];
    
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLabel]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_titleLabel)];
    NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLabel]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_titleLabel)];
    
    [self.contentView addConstraints:constraint_H];
    [self.contentView addConstraints:constraint_V];
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    self.titleLabel.text = @"";
}

@end
