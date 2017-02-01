//
//  MonthEndViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 14.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "MonthEndViewController.h"
#import "MainScreenTableViewController.h"
#import "Manager.h"

@interface MonthEndViewController ()
@property (weak, nonatomic) IBOutlet UILabel *balanceEndMonth;
@property (strong, nonatomic) NSNumber *mutableMonthDebit;
@end

@implementation MonthEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.mutableMonthDebit = [userDefaults objectForKey:@"mutableMonthDebit"];
    self.balanceEndMonth.text = [NSString stringWithFormat:@"%.2f", [self.mutableMonthDebit doubleValue]];
}

- (void)callOneTimeMonthBool {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL callOneTimeMonth = YES;
    [userDefaults setBool:callOneTimeMonth forKey:@"callOneTimeMonth"];
    [userDefaults synchronize];
}

- (IBAction)moveBalanceOnToday:(id)sender {
    [self callOneTimeMonthBool];
    
    if ([[Manager sharedInstance] getChangeAllStableDebitBool]) {
        [[Manager sharedInstance] setAllStableDebit];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double moneyOnTodayWithSpendMutMonthDebid = [self.mutableMonthDebit doubleValue] + [[userDefaults objectForKey:@"stableBudgetOnDay"] doubleValue];
    [[Manager sharedInstance] resetUserDefData:[NSNumber numberWithDouble:moneyOnTodayWithSpendMutMonthDebid]];
    double monthDebitWithBalanceMutableMonthDebit = [userDefaults doubleForKey:@"monthDebit"] + [self.mutableMonthDebit doubleValue];
    
    [userDefaults setDouble:monthDebitWithBalanceMutableMonthDebit forKey:@"mutableMonthDebit"];
    [[Manager sharedInstance] workWithHistoryOfSave:@"0" nameOfPeriod:[[Manager sharedInstance] stringForHistorySaveOfMonthDict]];
    
    double budgetOnDay = [[userDefaults objectForKey:@"budgetOnDay"] doubleValue];
    [userDefaults setDouble:budgetOnDay forKey:@"dailyBudgetTomorrowCounted"];
    
    //значение для switch в настройках дня 1 пункта
    [userDefaults setBool:YES forKey:@"transferMoneyNextDaySettingsMonth"];
    [userDefaults synchronize];
    
    [self popVC];
}

- (IBAction)amountOnDailyBudget:(id)sender {
    [self callOneTimeMonthBool];
    
    if ([[Manager sharedInstance] getChangeAllStableDebitBool]) {
        [[Manager sharedInstance] setAllStableDebit];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double divided = [self.mutableMonthDebit doubleValue] / [[Manager sharedInstance] daysToStartNewMonth];
    double amountBudget = [[userDefaults objectForKey:@"stableBudgetOnDay"] doubleValue] + divided;
    
    [userDefaults setObject:[NSNumber numberWithDouble:amountBudget] forKey:@"budgetOnDay"];
    
    NSDictionary *budgetOnCurrentDay = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    
    budgetOnCurrentDay = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"dayWhenSpend", [NSNumber numberWithDouble:amountBudget], @"mutableBudgetOnDay", nil];
    [userDefaults setObject:budgetOnCurrentDay forKey:@"budgetOnCurrentDay"];
    
    [userDefaults setObject:nil forKey:@"historySpendOfMonth"];
    
    double monthDebitWithBalanceMutableMonthDebit = [userDefaults doubleForKey:@"monthDebit"] + [self.mutableMonthDebit doubleValue];
    [userDefaults setDouble:monthDebitWithBalanceMutableMonthDebit forKey:@"mutableMonthDebit"];
    
    double budgetOnDay = [[userDefaults objectForKey:@"budgetOnDay"] doubleValue];
    [userDefaults setDouble:budgetOnDay forKey:@"dailyBudgetTomorrowCounted"];
    
    [[Manager sharedInstance] workWithHistoryOfSave:@"0" nameOfPeriod:[[Manager sharedInstance] stringForHistorySaveOfMonthDict]];
    //значение для switch в настройках дня 2 пункта
    [userDefaults setBool:YES forKey:@"amountDailyBudgetSettingsMonth"];
    [userDefaults synchronize];
    
    [self popVC];
}

- (IBAction)saveMoney:(id)sender {
    [self callOneTimeMonthBool];
    
    if ([[Manager sharedInstance] getChangeAllStableDebitBool]) {
        [[Manager sharedInstance] setAllStableDebit];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double moneyBox = [[userDefaults objectForKey:@"moneyBox"] doubleValue] + [self.mutableMonthDebit doubleValue];
    [userDefaults setObject:[NSNumber numberWithDouble:moneyBox] forKey:@"moneyBox"];

    [[Manager sharedInstance] workWithHistoryOfSave:self.mutableMonthDebit nameOfPeriod:[[Manager sharedInstance] stringForHistorySaveOfMonthDict]];

    ////--------///массив для подсчета отложенного бюджета за год
    NSMutableArray *arrForHistorySaveOfMonthMoneyDebit = [[userDefaults objectForKey:@"historySaveOfMonthMoneyDebit"] mutableCopy];
    if (arrForHistorySaveOfMonthMoneyDebit == nil) {
        arrForHistorySaveOfMonthMoneyDebit = [NSMutableArray array];
    }
    [arrForHistorySaveOfMonthMoneyDebit addObject:self.mutableMonthDebit];
    [userDefaults setObject:arrForHistorySaveOfMonthMoneyDebit forKey:@"historySaveOfMonthMoneyDebit"];
    
    double monthDebit = [userDefaults doubleForKey:@"monthDebit"];
    [userDefaults setDouble:monthDebit forKey:@"mutableMonthDebit"];
    ////--------///
    
    [[Manager sharedInstance] resetUserDefData:[userDefaults objectForKey:@"stableBudgetOnDay"]];
    
    double budgetOnDay = [[userDefaults objectForKey:@"stableBudgetOnDay"] doubleValue];
    [userDefaults setDouble:budgetOnDay forKey:@"dailyBudgetTomorrowCounted"];
    //значение для switch в настройках дня 3 пункта
    [userDefaults setBool:YES forKey:@"moneyBoxSettingsMonth"];
    [userDefaults synchronize];
    
    [self popVC];
}


- (void)popVC {
    UIViewController* popVC;
    for (UIViewController* vC in self.navigationController.viewControllers) {
        if ([vC isKindOfClass:[MainScreenTableViewController class]]) {
            popVC = vC;
            break;
        }
    }
    if (popVC) {
        [self.navigationController popToViewController:popVC animated:YES];
    }
    
}


@end
