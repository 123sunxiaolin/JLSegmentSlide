//
//  JLContentTableViewController.m
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/18.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import "JLContentTableViewController.h"

@interface JLContentTableViewController ()

@end

@implementation JLContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (UIScrollView *)scrollView {
    return self.tableView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"IndexPath ---------%@", @(indexPath.row)];
    return cell;
}

@end
