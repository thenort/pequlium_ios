//
//  NavViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 26.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "NavViewController.h"
#import "ViewController.h"
#import "MainScreenTableViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double monthDebit = [userDefaults doubleForKey:@"monthDebit"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    if (monthDebit == 0) {
       ViewController  *viewVC = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        self.viewControllers = @[viewVC];
    } else {
        MainScreenTableViewController *mainScreenTableVC = [storyboard instantiateViewControllerWithIdentifier:@"MainScreenTableViewController"];
        self.viewControllers = @[mainScreenTableVC];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
