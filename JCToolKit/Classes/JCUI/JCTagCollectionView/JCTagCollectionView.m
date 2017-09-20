//
//  JCTagCollectionView.m
//  DemoCollectionView
//
//  Created by Jam on 16/4/20.
//  Copyright © 2016年 Jam. All rights reserved.
//

#import "JCTagCollectionView.h"
#import "JCCollectionViewFlowLayout.h"
#import "JCTagCollectionViewCell.h"

@interface JCTagCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

static NSString * const reuseIdentifier = @"tagCollectionViewCell";

@implementation JCTagCollectionView

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
    
    self.tagBackGroundColor = [UIColor clearColor];
    self.tagBorderColor = [UIColor lightGrayColor];
    self.tagSelectBorderColor = [UIColor colorWithRed:21/255.0 green:169/255.0 blue:188/255.0 alpha:1];
    self.tagColor = [UIColor colorWithWhite:125.0/255.0 alpha:1.0f];
    self.tagSelectColor = [UIColor colorWithRed:21/255.0 green:169/255.0 blue:188/255.0 alpha:1];
    self.tagCornerRadius = 10.0f;
    
    self.canSelect = YES;
    
    self.tags = [NSMutableArray array];
    _selectTags = [NSMutableArray array];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[JCCollectionViewFlowLayout alloc] init]];
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView registerClass:[JCTagCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];

    [self addSubview:self.collectionView];
    
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_collectionView)];
    NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_collectionView)];
    
    [self addConstraints:constraint_H];
    [self addConstraints:constraint_V];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JCTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = self.tagBackGroundColor;
    cell.layer.borderColor = self.tagBorderColor.CGColor;
    cell.layer.cornerRadius = self.tagCornerRadius;
    
    if ([_selectTags containsObject:self.tags[indexPath.row]]) {
        cell.layer.borderColor = self.tagSelectBorderColor.CGColor;
        [cell.titleLabel setTextColor:self.tagSelectColor];
    } else {
        cell.layer.borderColor = self.tagBorderColor.CGColor;
        [cell.titleLabel setTextColor:self.tagColor];
    }
    
    [cell.titleLabel setText:self.tags[indexPath.row]];
    
    return cell;
}

#pragma mark UICollectionDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.canSelect;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JCTagCollectionViewCell *selectCell = (JCTagCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([_selectTags containsObject:self.tags[indexPath.row]]) {
        selectCell.layer.borderColor = self.tagBorderColor.CGColor;
        [selectCell.titleLabel setTextColor:self.tagColor];
        [_selectTags removeObject:self.tags[indexPath.row]];
    } else {
        selectCell.layer.borderColor = self.tagSelectBorderColor.CGColor;
        [selectCell.titleLabel setTextColor:self.tagSelectColor];
        [_selectTags addObject:self.tags[indexPath.row]];
    }
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JCCollectionViewFlowLayout *layout = (JCCollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    
    CGRect frame = [self.tags[indexPath.item] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    
    return CGSizeMake(frame.size.width + 20.0f, layout.itemSize.height);
}

@end
