//
//  JCCollectionViewFlowLayout.m
//  DemoCollectionView
//
//  Created by Jam on 16/4/20.
//  Copyright © 2016年 Jam. All rights reserved.
//

#import "JCCollectionViewFlowLayout.h"

@interface JCCollectionViewFlowLayout ()

@property (nonatomic, weak) id<UICollectionViewDelegateFlowLayout> delegate;

@property (nonatomic, strong) NSMutableArray *itemAttributes;

@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation JCCollectionViewFlowLayout

- (id)init {
    self = [super init];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    
    self.minimumLineSpacing = 10.0f;
    self.minimumInteritemSpacing = 10.0f;
    self.itemSize = CGSizeMake(100.0f, 22.0f);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    
    self.itemAttributes = [NSMutableArray array];
}

- (void)prepareLayout {
    [super prepareLayout];
    
    [self.itemAttributes removeAllObjects];
    
    self.contentHeight = self.sectionInset.top + self.itemSize.height;
    
    CGFloat originX = self.sectionInset.left;
    CGFloat originY = self.sectionInset.top;
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger index = 0; index < itemCount; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        CGSize itemSize = [self itemSizeWithIndexPath:indexPath];
        
        if ((originX + itemSize.width + self.sectionInset.right/2) > self.collectionView.frame.size.width) {
            originX = self.sectionInset.left;
            originY += itemSize.height + self.minimumLineSpacing;
            
            self.contentHeight += itemSize.height + self.minimumLineSpacing;
        }
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(originX, originY, itemSize.width, itemSize.height);
        [self.itemAttributes addObject:attributes];
        
        originX += itemSize.width + self.minimumInteritemSpacing;
    }
    
    self.contentHeight += self.sectionInset.bottom;
}


- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.itemAttributes;
}

- (id<UICollectionViewDelegateFlowLayout>)delegate
{
    if (!_delegate) {
        _delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    }
    
    return _delegate;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    
    return NO;
}

- (CGSize)itemSizeWithIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        return [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    
    return self.itemSize;
}

@end
