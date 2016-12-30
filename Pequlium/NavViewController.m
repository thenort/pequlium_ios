//
//  NavViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 26.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "NavViewController.h"
#import "FirstViewController.h"
#import "MainScreenTableViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double monthDebit = [userDefaults doubleForKey:@"monthDebit"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    if (monthDebit == 0) {
       FirstViewController  *firstViewVC = [storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
        self.viewControllers = @[firstViewVC];
    } else {
        MainScreenTableViewController *mainScreenTableVC = [storyboard instantiateViewControllerWithIdentifier:@"MainScreenTableViewController"];
        self.viewControllers = @[mainScreenTableVC];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
