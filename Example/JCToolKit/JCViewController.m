//
//  JCViewController.m
//  JCToolKit
//
//  Created by 贾淼 on 12/14/2016.
//  Copyright (c) 2016 贾淼. All rights reserved.
//

#import "JCViewController.h"
#import <JCToolKit/JCToolKit.h>

@interface JCViewController () < CALayerDelegate >

@property (nonatomic, strong) NSString *target;

@end

@implementation JCViewController

+ (void)load
{
	[JCViewController jc_hookSelector:@selector(viewWillAppear:) withExcuteOption:JCAOPExecuteOptionBefore usingBlock:^(JCAOPInfo *aopInfo) {
		NSLog(@"Befor View Controller %@ arguments: %@", aopInfo.instance, aopInfo.arguments);
	}];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
		[self jc_hookSelector:@selector(viewWillAppear:) withExcuteOption:JCAOPExecuteOptionAfter usingBlock:^(JCAOPInfo *aopInfo) {
			NSLog(@"After View Controller %@ arguments: %@", aopInfo.instance, aopInfo.arguments);
		}];
    }
	
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	NSLog(@"viewwillappear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
