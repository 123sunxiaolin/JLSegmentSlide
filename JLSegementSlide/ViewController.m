//
//  ViewController.m
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/9.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import "ViewController.h"
#import "LanguageCenterViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)jumpButtonClicked:(id)sender {
    LanguageCenterViewController *vc = [[LanguageCenterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
