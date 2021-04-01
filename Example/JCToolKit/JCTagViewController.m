//
//  JCTagViewController.m
//  JCToolKit Example
//
//  Created by Jam Jia on 4/1/21.
//  Copyright © 2021 Jam Jia. All rights reserved.
//

#import "JCTagViewController.h"
#import <JCToolKit/JCToolKit.h>

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#endif
@interface JCTagViewController ()

@end

@implementation JCTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view setBackgroundColor:[UIColor whiteColor]];

    UIView *superview = self.view;

    UIView *view1 = [[UIView alloc] init];
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    view1.backgroundColor = [UIColor greenColor];
    [superview addSubview:view1];

    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);

    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview).with.insets(padding);
    }];

    JCTagCollectionView *tagView = [[JCTagCollectionView alloc] init];
    tagView.tags = @[@"标签1", @"标签2", @"苏州", @"乌鲁木齐市", @"美国加利福利亚州"];
    [self.view addSubview:tagView];

    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24);
        make.left.equalTo(superview.mas_left);
        make.height.mas_equalTo(80);
        make.right.equalTo(superview.mas_right);
    }];
}

@end
