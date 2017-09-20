//
//  JCTagCollectionView.h
//  DemoCollectionView
//
//  Created by Jam on 16/4/20.
//  Copyright © 2016年 Jam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCTagCollectionView : UIView

@property (nonatomic, strong) UIColor *tagBackGroundColor;
@property (nonatomic, strong) UIColor *tagBorderColor;
@property (nonatomic, strong) UIColor *tagSelectBorderColor;
@property (nonatomic, strong) UIColor *tagColor;
@property (nonatomic, strong) UIColor *tagSelectColor;
@property (nonatomic, assign) CGFloat tagCornerRadius;

@property (nonatomic, assign) BOOL canSelect;

@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong, readonly) NSMutableArray *selectTags;

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

@end
