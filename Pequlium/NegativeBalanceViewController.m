//
//  NegativeBalanceViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 14.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "NegativeBalanceViewController.h"
#import "MainScreenTableViewController.h"
#import "Manager.h"

@interface NegativeBalanceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *negativeBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyBudgetWillBeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyBudgetWillBeTomorrowLabel;
@end

@implementation NegativeBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.negativeBalanceLabel.text = [[Manager sharedInstance] updateTextBalanceLabel];
    [self infoToDailyBudgetWillBeLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)infoToDailyBudgetWillBeLabel {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *budgetOnCurrentDay = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    BOOL callOneTimeBool = [userDefaults boolForKey:@"callOneTimeToLable"];
    if (!callOneTimeBool) {
        double divided = [[budgetOnCurrentDay objectForKey:@"mutableBudgetOnDay"] doubleValue] / [[Manager sharedInstance] daysToStartNewMonth] ;
        double recalculationBudgetOnDay = [userDefaults doubleForKey:@"budgetOnDay"] - fabs(divided);
        self.dailyBudgetWillBeLabel.text = [NSString stringWithFormat:@"Дневной бюджет будет %.2f", recalculationBudgetOnDay];
        
        BOOL callOneTime = YES;
        [userDefaults setBool:callOneTime forKey:@"callOneTimeToLable"];
    } else {
        double divided = [userDefaults doubleForKey:@"processOfSpendingMoneyTextField"] / [[Manager sharedInstance] daysToStartNewMonth];
        double recalculationBudgetOnDay = [userDefaults doubleForKey:@"budgetOnDay"] - fabs(divided);
        self.dailyBudgetWillBeLabel.text = [NSString stringWithFormat:@"Дневной бюджет будет %.2f", recalculationBudgetOnDay];
    }
}

- (IBAction)dailyBudgetCounted:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL dailyBudgetTomorrowBool = YES;
    [userDefaults setBool:dailyBudgetTomorrowBool forKey:@"dailyBudgetTomorrowBool"];
    
    NSDictionary *budgetOnCurrentDay = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    BOOL callOneTimeBool = [userDefaults boolForKey:@"callOneTime"];
    if (!callOneTimeBool) {
        double divided = [[budgetOnCurrentDay objectForKey:@"mutableBudgetOnDay"] doubleValue] / [[Manager sharedInstance] daysToStartNewMonth] ;
        double recalculationBudgetOnDay = [userDefaults doubleForKey:@"budgetOnDay"] - fabs(divided);
        [userDefaults setDouble:recalculationBudgetOnDay forKey:@"budgetOnDay"];
        BOOL callOneTime = YES;
        [userDefaults setBool:callOneTime forKey:@"callOneTime"];
    } else {
        double divided = [userDefaults doubleForKey:@"processOfSpendingMoneyTextField"] / [[Manager sharedInstance] daysToStartNewMonth];
        double recalculationBudgetOnDay = [userDefaults doubleForKey:@"budgetOnDay"] - fabs(divided);
        [userDefaults setDouble:recalculationBudgetOnDay forKey:@"budgetOnDay"];
    }
    [userDefaults synchronize];
    [self pushVC];
}

- (void)infoToDailyBudgetWillBeTomorrowLabel {
    
}


- (IBAction)dailyBudgetTomorrowCounted:(id)sender {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL callOneTime = YES;
    [userDefaults setBool:callOneTime forKey:@"callOneTime"];
    
    //если да то бюджет на завтра будет...
    BOOL dailyBudgetTomorrowCountedBool = YES;
    [userDefaults setBool:dailyBudgetTomorrowCountedBool forKey:@"dailyBudgetTomorrowCountedBool"];
    
    NSDictionary *budgetOnCurrentDay = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    BOOL dailyBudgetTomorrowBool = [userDefaults boolForKey:@"dailyBudgetTomorrowBool"];
    if (!dailyBudgetTomorrowBool) {
        
        double recalculationBudgetOnTomorrow = [[userDefaults objectForKey:@"budgetOnDay"] doubleValue] - fabs([[budgetOnCurrentDay objectForKey:@"mutableBudgetOnDay"] doubleValue]) ;
        
        [userDefaults setDouble:recalculationBudgetOnTomorrow forKey:@"dailyBudgetTomorrowCounted"];
        NSLog(@"callback 1.1");
        BOOL callOneTimeTomorrowBool = YES;
        [userDefaults setBool:callOneTimeTomorrowBool forKey:@"dailyBudgetTomorrowBool"];
    } else {
        if (![userDefaults doubleForKey:@"dailyBudgetTomorrowCounted"]) {
            double recalculationBudgetOnTomorrow = [[userDefaults objectForKey:@"budgetOnDay"]  doubleValue] - fabs([userDefaults doubleForKey:@"processOfSpendingMoneyTextField"]);
            [userDefaults setDouble:recalculationBudgetOnTomorrow forKey:@"dailyBudgetTomorrowCounted"];
        } else {
            double recalculationBudgetOnTomorrow = [userDefaults doubleForKey:@"dailyBudgetTomorrowCounted"] - fabs([userDefaults doubleForKey:@"processOfSpendingMoneyTextField"]);
            NSLog(@"callback 2.1");
            [userDefaults setDouble:recalculationBudgetOnTomorrow forKey:@"dailyBudgetTomorrowCounted"];
        }
    }
    [userDefaults synchronize];
    [self pushVC];
}

- (IBAction)mistakeEnterDifferentAmount:(id)sender {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSMutableArray *historySpendOfMonth = [[userDefaults objectForKey:@"historySpendOfMonth"]mutableCopy];
    NSDictionary *lastDictInHistorySpendOfMonth = [historySpendOfMonth lastObject];
    double currentSpend = fabs([[lastDictInHistorySpendOfMonth objectForKey:@"currentSpendNumber"] doubleValue]);
    
    double mutableMonthDebitWithReturn = [userDefaults doubleForKey:@"mutableMonthDebit"] + currentSpend;
    [userDefaults setDouble:mutableMonthDebitWithReturn forKey:@"mutableMonthDebit"];
    
    NSMutableDictionary *budgetOnCurrentDay = [[userDefaults objectForKey:@"budgetOnCurrentDay"]mutableCopy];
    double mutableDayDebitWithReturn = [[budgetOnCurrentDay objectForKey:@"mutableBudgetOnDay"] doubleValue] + currentSpend;
    NSNumber *mutableDayDebitWithReturnNumber = [NSNumber numberWithDouble:mutableDayDebitWithReturn];
    [budgetOnCurrentDay setObject:mutableDayDebitWithReturnNumber forKey:@"mutableBudgetOnDay"];
    [userDefaults setObject:budgetOnCurrentDay forKey:@"budgetOnCurrentDay"];
    [userDefaults synchronize];
    
    if ([[budgetOnCurrentDay objectForKey:@"mutableBudgetOnDay"] doubleValue] > 0) {
        BOOL callOneTime = NO;
        [userDefaults setBool:callOneTime forKey:@"callOneTimeToLable"];
    }
    
    [historySpendOfMonth removeLastObject];
    [userDefaults setObject:historySpendOfMonth forKey:@"historySpendOfMonth"];
    
    [self pushVC];
    
}

- (void)pushVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    MainScreenTableViewController *mainScreenTableViewVC = [storyboard instantiateViewControllerWithIdentifier:@"MainScreenTableViewController"];
    [self.navigationController pushViewController:mainScreenTableViewVC animated:YES];
}

@end
