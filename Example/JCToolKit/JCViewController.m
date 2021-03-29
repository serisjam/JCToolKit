//
//  JCViewController.m
//  JCToolKit
//
//  Created by 贾淼 on 12/14/2016.
//  Copyright (c) 2016 贾淼. All rights reserved.
//

#import "JCViewController.h"
#import <JCToolKit/JCToolKit.h>

@interface JCViewController ()

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

    [self testForTagView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	NSLog(@"viewwillappear");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self jcNetworkRequest];
}

- (void)jcNetworkRequest
{
    JCRequestObj *requestObj = [[JCRequestObj alloc] init];
    requestObj.hostName = @"https://httpbin.org";
    requestObj.path = @"get";
    requestObj.paramsDic = @{@"text":@"content type ios"};

    [[JCRequestProxy sharedInstance] httpGetWithRequest:requestObj entityClass:nil withCompleteBlock:^(JCNetworkResponse *response) {
        if (response.status == JCNetworkResponseStatusSuccess) {
            NSLog(@"%@", response.content);
        }
    }];
}

- (void)testForTagView
{
    JCTagCollectionView *tagView = [[JCTagCollectionView alloc] initWithFrame:CGRectMake(0, 120, 320, 80)];
    [tagView setBackgroundColor:[UIColor cyanColor]];
    tagView.tags = @[@"标签1", @"标签2", @"苏州", @"乌鲁木齐市", @"美国加利福利亚州"];

    [self.view addSubview:tagView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
