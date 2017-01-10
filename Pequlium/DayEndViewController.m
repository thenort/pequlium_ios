//
//  DayEndViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 14.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "DayEndViewController.h"
#import "MainScreenTableViewController.h"
#import "Manager.h"

@interface DayEndViewController ()
@property (weak, nonatomic) IBOutlet UILabel *balanceEndDay;
@property (strong, nonatomic) NSNumber *mutableBudgetOnDayWithSpendNumberFromDict;
@end

@implementation DayEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    self.mutableBudgetOnDayWithSpendNumberFromDict = [dict objectForKey:@"mutableBudgetOnDay"];
    self.balanceEndDay.text = [NSString stringWithFormat:@"%.2f", [self.mutableBudgetOnDayWithSpendNumberFromDict doubleValue]];
}

- (void)callOneTimeDayBool {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL callOneTimeDay = YES;
    [userDefaults setBool:callOneTimeDay forKey:@"callOneTimeDay"];
    [userDefaults synchronize];
}

- (void)goToVC {
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
    MainScreenTableViewController *mainScreenTableViewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainScreenTableViewController"];
    [nav pushViewController:mainScreenTableViewVC animated:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)moveBalanceOnToday:(id)sender {
    //[self callOneTimeDayBool];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    double mutableBalanceOnToday = [[userDefaults objectForKey:@"budgetOnDay"] doubleValue] + [self.mutableBudgetOnDayWithSpendNumberFromDict doubleValue];
    
    NSDictionary *dict = [userDefaults objectForKey:@"budgetOnCurrentDay"];

    dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"dayWhenSpend", [NSNumber numberWithDouble: mutableBalanceOnToday], @"mutableBudgetOnDay", nil];
    [userDefaults setObject:dict forKey:@"budgetOnCurrentDay"];

    [userDefaults synchronize];
    [self goToVC];
}

- (IBAction)amountOnDailyBudget:(id)sender {
    //[self callOneTimeDayBool];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double divided = [self.mutableBudgetOnDayWithSpendNumberFromDict doubleValue] / [[Manager sharedInstance] daysToStartNewMonth];
    double recalculationBudgetOnDay = [[userDefaults objectForKey:@"budgetOnDay"] doubleValue] + divided;
    NSDictionary *dict = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"dayWhenSpend", [NSNumber numberWithDouble: recalculationBudgetOnDay], @"mutableBudgetOnDay", nil];
    [userDefaults setObject:dict forKey:@"budgetOnCurrentDay"];
    
    [userDefaults synchronize];
    [self goToVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
