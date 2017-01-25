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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

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

- (IBAction)moveBalanceOnToday:(id)sender {
    [self callOneTimeDayBool];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    double mutableBalanceOnToday = [[userDefaults objectForKey:@"budgetOnDay"] doubleValue] + [self.mutableBudgetOnDayWithSpendNumberFromDict doubleValue];
    
    NSDictionary *dict = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"dayWhenSpend", [NSNumber numberWithDouble: mutableBalanceOnToday], @"mutableBudgetOnDay", nil];
    [userDefaults setObject:dict forKey:@"budgetOnCurrentDay"];
    //значение для switch в настройках дня 1пункта
    [userDefaults setBool:YES forKey:@"transferMoneyToNextDaySettingsDay"];
    [userDefaults synchronize];
    [self goToVC];
}

- (IBAction)amountOnDailyBudget:(id)sender {
    [self callOneTimeDayBool];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double divided = [self.mutableBudgetOnDayWithSpendNumberFromDict doubleValue] / [[Manager sharedInstance] daysToStartNewMonth];
    double amountBudgetOnDay = [[userDefaults objectForKey:@"budgetOnDay"] doubleValue] + divided;
    [userDefaults setObject:[NSNumber numberWithDouble:amountBudgetOnDay] forKey:@"budgetOnDay"];
    double recalculationBudgetOnDay = [[userDefaults objectForKey:@"budgetOnDay"] doubleValue];
    
    NSDictionary *dict = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"dayWhenSpend", [NSNumber numberWithDouble: recalculationBudgetOnDay], @"mutableBudgetOnDay", nil];
    [userDefaults setObject:dict forKey:@"budgetOnCurrentDay"];
    //значение для switch в настройках дня 2пункта
    [userDefaults setBool:YES forKey:@"amountOnDailyBudgetSettingsDay"];
    [userDefaults synchronize];
    [self goToVC];
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

- (void)goToVC {
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
    MainScreenTableViewController *mainScreenTableViewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainScreenTableViewController"];
    [nav pushViewController:mainScreenTableViewVC animated:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
