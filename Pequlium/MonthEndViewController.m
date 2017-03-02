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
@property (strong, nonatomic) Manager *manager;
@end

@implementation MonthEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [Manager sharedInstance];
    self.navigationItem.hidesBackButton = YES;
    self.balanceEndMonth.text = [NSString stringWithFormat:@"%.2f", [self.manager getMutableMonthDebit]];
}

- (void)callOneTimeMonthBool {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL callOneTimeMonth = YES;
    [userDefaults setBool:callOneTimeMonth forKey:@"callOneTimeMonth"];
    [userDefaults synchronize];
}

- (IBAction)moveBalanceOnToday:(id)sender {
    [self callOneTimeMonthBool];
    
    if ([self.manager getChangeAllStableDebitBool]) {
        [self.manager setAllStableDebit];
    }
    
    [self.manager setBudgetOnDay:[self.manager getStableBudgetOnDay]];
    [self.manager setBudgetOnCurrentDay:[self.manager getMutableMonthDebit] + [self.manager getBudgetOnDay] dayWhenSpend:[NSDate date]];
    [self.manager setMutableMonthDebit:[self.manager getMonthDebit] + [self.manager getMutableMonthDebit]];
    [self.manager setDailyBudgetTomorrowCounted: [self.manager getBudgetOnDay]];
    
    [self.manager workWithHistoryOfSave:@"0" nameOfPeriod:[self.manager stringForHistorySaveOfMonthDict]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:@"historySpendOfMonth"];
    //Bool value for switch in settings 1
    [userDefaults setBool:YES forKey:@"transferMoneyNextDaySettingsMonth"];
    [userDefaults synchronize];
    
    [self popVC];
}

- (IBAction)amountOnDailyBudget:(id)sender {
    [self callOneTimeMonthBool];
    
    if ([self.manager getChangeAllStableDebitBool]) {
        [self.manager setAllStableDebit];
    }

    double divided = [self.manager getMutableMonthDebit] / [self.manager daysToStartNewMonth];
    double amountBudget = [self.manager getStableBudgetOnDay] + divided;
    
    [self.manager setBudgetOnDay:amountBudget];
    [self.manager setBudgetOnCurrentDay:amountBudget dayWhenSpend:[NSDate date]];
    [self.manager setMutableMonthDebit: [self.manager getMonthDebit] + [self.manager getMutableMonthDebit]];
    [self.manager setDailyBudgetTomorrowCounted:[self.manager getBudgetOnDay]];
    
    [self.manager workWithHistoryOfSave:@"0" nameOfPeriod:[self.manager stringForHistorySaveOfMonthDict]];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:@"historySpendOfMonth"];
    //Bool value for switch in settings 2
    [userDefaults setBool:YES forKey:@"amountDailyBudgetSettingsMonth"];
    [userDefaults synchronize];
    
    [self popVC];
}

- (IBAction)saveMoney:(id)sender {
    [self callOneTimeMonthBool];

    if ([self.manager getChangeAllStableDebitBool]) {
        [self.manager setAllStableDebit];
    }
     
    [self.manager setMoneyBox:[self.manager getMoneyBox] + [self.manager getMutableMonthDebit]];
    [self.manager workWithHistoryOfSave:[self.manager getMutableMonthDebitNumber] nameOfPeriod:[self.manager stringForHistorySaveOfMonthDict]];

    //массив для подсчета отложенного бюджета за год
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arrForHistorySaveOfMonthMoneyDebit = [[userDefaults objectForKey:@"historySaveOfMonthMoneyDebit"] mutableCopy];
    if (arrForHistorySaveOfMonthMoneyDebit == nil) {
        arrForHistorySaveOfMonthMoneyDebit = [NSMutableArray array];
    }
    [arrForHistorySaveOfMonthMoneyDebit addObject:[self.manager getMutableMonthDebitNumber]];
    [userDefaults setObject:arrForHistorySaveOfMonthMoneyDebit forKey:@"historySaveOfMonthMoneyDebit"];
    [userDefaults synchronize];
    //
    
    //перерасчет дневного стабильного бюджета
    if ([self.manager getWithPercent]) {
        [self.manager setBudgetOnDay:[self.manager getMonthDebit] / [self.manager daysInCurrentMonth]];
    } else {
        [self.manager setBudgetOnDay:fabs(([self.manager getMonthDebit] - [self.manager getMonthPercent]) / [self.manager daysInCurrentMonth])];
    }

    [self.manager setBudgetOnDay:[self.manager getStableBudgetOnDay]];
    [self.manager setBudgetOnCurrentDay:[self.manager getBudgetOnDay] dayWhenSpend:[NSDate date]];
    [self.manager setMutableMonthDebit:[self.manager getMonthDebit]];
    [self.manager setDailyBudgetTomorrowCounted:[self.manager getBudgetOnDay]];
    
    [userDefaults setObject:nil forKey:@"historySpendOfMonth"];
    //Bool value for switch in settings 3
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
