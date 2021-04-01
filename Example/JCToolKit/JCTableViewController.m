//
//  JCTableViewController.m
//  JCToolKit Example
//
//  Created by Jam Jia on 4/1/21.
//  Copyright © 2021 Jam Jia. All rights reserved.
//

#import "JCTableViewController.h"
#import "JCMasExampleTableViewController.h"
#import "JCTagViewController.h"

@interface JCTableViewController ()

@property (nonatomic, strong) NSArray *examples;

@end

@implementation JCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.examples = @[
        @{
            @"title":@"Masonry",
            @"instance":[[JCMasExampleTableViewController alloc] init]
        },
        @{
            @"title":@"TagView",
            @"instance":[[JCTagViewController alloc] init]
        }
    ];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.examples.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"masonry" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.examples[indexPath.row][@"title"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = self.examples[indexPath.row][@"instance"];
    [viewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
