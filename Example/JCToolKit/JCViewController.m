//
//  JCViewController.m
//  JCToolKit
//
//  Created by 贾淼 on 12/14/2016.
//  Copyright (c) 2016 贾淼. All rights reserved.
//

#import "JCViewController.h"
#import <JCToolKit/JCToolKit.h>

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#endif

#if __has_include(<MBProgressHUD/MBProgressHUD.h>)
#import <MBProgressHUD/MBProgressHUD.h>
#endif

@interface JCViewController ()

@property (weak, nonatomic) IBOutlet UITextView *requestTextView;

@end

@implementation JCViewController

- (MBProgressHUD *)loadingHud
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Set MBProgressHUDBackgroundStyleBlur.
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.alpha = 0.85f;
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image1 = [[UIImage imageNamed:@"ic_vidoe-loading1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image2 = [[UIImage imageNamed:@"ic_vidoe-loading2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image3 = [[UIImage imageNamed:@"ic_vidoe-loading3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image1];
    [imageView setAnimationImages:@[image1, image2, image3]];
    [imageView setAnimationDuration:0.8f];
    [imageView startAnimating];
    hud.customView = imageView;
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // label white color
    hud.label.textColor = [UIColor whiteColor];
    // Optional label text.
    hud.label.text = @"正在加载";

    return hud;
}

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

- (IBAction)onClickRequestNetwork:(id)sender {

    JCRequestObj *requestObj = [[JCRequestObj alloc] init];
    requestObj.hostName = @"https://httpbin.org";
    requestObj.path = @"get";
    requestObj.paramsDic = @{@"text":@"content type ios"};

    jc_weakSelf;
    MBProgressHUD *hud = [self loadingHud];
    [[JCRequestProxy sharedInstance] httpGetWithRequest:requestObj entityClass:nil withCompleteBlock:^(JCNetworkResponse *response) {
        if (response.status == JCNetworkResponseStatusSuccess) {
            NSLog(@"%@", response.content);
            [selfWeak.requestTextView setText:[NSString stringWithFormat:@"%@", response.content]];
        }
        [hud hideAnimated:YES];
    }];
}

@end
