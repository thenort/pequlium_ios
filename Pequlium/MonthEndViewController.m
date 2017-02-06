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
    [self.manager setCallOneTimeMonth:YES];
}

- (IBAction)moveBalanceOnToday:(id)sender {
    [self callOneTimeMonthBool];
    
    if ([self.manager getChangeAllStableDebitBool]) {
        [self.manager setAllStableDebit];
    } else {
        [self.manager setStableBudgetOnDay:[self.manager getMonthDebit] / [self.manager daysInCurrentMonth]];
    }
    [self.manager moveBalanceOnTodayMonthEnd];
    //Bool value for switch in settings 1
    [self.manager setTransferMoneyNextDaySettingsMonth:YES];
    
    [self goToVC];
}

- (IBAction)amountOnDailyBudget:(id)sender {
    [self callOneTimeMonthBool];
    
    if ([self.manager getChangeAllStableDebitBool]) {
        [self.manager setAllStableDebit];
    } else {
        [self.manager setStableBudgetOnDay:[self.manager getMonthDebit] / [self.manager daysInCurrentMonth]];
    }
    [self.manager amountOnDailyBudgetMonthEnd];

    //Bool value for switch in settings 2
    [self.manager setAmountDailyBudgetSettingsMonth:YES];
    
    [self goToVC];
}

- (IBAction)saveMoney:(id)sender {
    [self callOneTimeMonthBool];

    if ([self.manager getChangeAllStableDebitBool]) {
        [self.manager setAllStableDebit];
    } else {
        [self.manager setStableBudgetOnDay:[self.manager getMonthDebit] / [self.manager daysInCurrentMonth]];
    }
    
    [self.manager setMoneyBox:[self.manager getMutableMonthDebit] + [self.manager getMoneyBox]];
    [self.manager saveMoneyMonthEnd];
    //Bool value for switch in settings 3
    [self.manager setMoneyBoxSettingsMonth:YES];
    
    [self goToVC];
}

- (void)goToVC {
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
    MainScreenTableViewController *mainScreenTableViewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainScreenTableViewController"];
    [nav pushViewController:mainScreenTableViewVC animated:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

/*
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
*/


@end
