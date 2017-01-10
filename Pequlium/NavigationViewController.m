//
//  NavigationViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 10.01.17.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

#import "NavigationViewController.h"
#import "FirstViewController.h"
#import "MainScreenTableViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double monthDebit = [userDefaults doubleForKey:@"monthDebit"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    if (!monthDebit) {
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
