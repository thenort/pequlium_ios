//
//  CalculationViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 20.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "CalculationViewController.h"
#import "Manager.h"
#import "MainScreenTableViewController.h"

@interface CalculationViewController ()
@end

@implementation CalculationViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.budgetOnDayLabel.text = self.budgetOnDay;
    self.budgetOnDayWithSavingLabel.text = self.budgetOnDayWithSaving;
    self.moneySavingYearLabel.text = self.moneySavingYear;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}


- (IBAction)budgetWithSavingMoney:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    MainScreenTableViewController *mainScreenTableViewVC = [storyboard instantiateViewControllerWithIdentifier:@"MainScreenTableViewController"];
    [self.navigationController pushViewController:mainScreenTableViewVC animated:YES];
    [self writeInDict:self.budgetOnDayWithSavingLabel.text];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    double moneyBox = [[userdefaults objectForKey:@"monthPercent"] doubleValue];
    [userdefaults setObject:[NSNumber numberWithDouble:moneyBox] forKey:@"moneyBox"];
    
    double monthDebit = [[userdefaults objectForKey:@"monthDebit"] doubleValue] - [[userdefaults objectForKey:@"monthPercent"] doubleValue];
    [userdefaults setObject:[NSNumber numberWithDouble:monthDebit] forKey:@"monthDebit"];
    double mutableMonthDebit = [[userdefaults objectForKey:@"mutableMonthDebit"]  doubleValue] - [[userdefaults objectForKey:@"monthPercent"] doubleValue];
    [userdefaults setObject:[NSNumber numberWithDouble:mutableMonthDebit] forKey:@"mutableMonthDebit"];
    
    [userdefaults setBool:YES forKey:@"withPercent"];
    [userdefaults synchronize];
}

- (IBAction)budgetWithNonSavingMoney:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    MainScreenTableViewController *mainScreenTableViewVC = [storyboard instantiateViewControllerWithIdentifier:@"MainScreenTableViewController"];
    [self.navigationController pushViewController:mainScreenTableViewVC animated:YES];
    
    [self writeInDict:self.budgetOnDayLabel.text];
}

- (void)writeInDict:(NSString*) budgetOnDay {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *budgetOnDayNumber = [NSNumber numberWithDouble:[budgetOnDay doubleValue]];
    NSDictionary *budgetOnCurrentDay = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"dayWhenSpend", budgetOnDayNumber, @"mutableBudgetOnDay", nil];
    [userDefaults setObject:budgetOnDayNumber forKey:@"budgetOnDay"];
    [userDefaults setObject:budgetOnCurrentDay forKey:@"budgetOnCurrentDay"];
    
    [userDefaults setObject:budgetOnDayNumber forKey:@"stableBudgetOnDay"];
    
    
    [userDefaults synchronize];
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
