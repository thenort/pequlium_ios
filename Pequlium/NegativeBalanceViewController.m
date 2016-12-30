//
//  NegativeBalanceViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 14.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "NegativeBalanceViewController.h"
#import "Manager.h"

@interface NegativeBalanceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *negativeBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyBudgetWillBeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyBudgetWillBeTomorrowLabel;
@end

@implementation NegativeBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.hidesBackButton = YES;
    self.negativeBalanceLabel.text = [[Manager sharedInstance] updateTextBalanceLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dailyBudgetCounted:(id)sender {
    
    
}

- (IBAction)dailyBudgetTomorrowCounted:(id)sender {
    
    
}

- (IBAction)mistakeEnterDifferentAmount:(id)sender {
    
    
}


@end
