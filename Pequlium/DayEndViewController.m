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
@property (strong, nonatomic) Manager *manager;
@end

@implementation DayEndViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [Manager sharedInstance];
    self.balanceEndDay.text = [NSString stringWithFormat:@"%.2f", [[Manager sharedInstance] getBudgetOnCurrentDayMoneyDouble]];
}

- (void)callOneTimeDayBool {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL callOneTimeDay = YES;
    [userDefaults setBool:callOneTimeDay forKey:@"callOneTimeDay"];
    [userDefaults synchronize];
}

- (IBAction)moveBalanceOnToday:(id)sender {
    [self callOneTimeDayBool];
    
    [self.manager setBudgetOnCurrentDay:[self.manager getBudgetOnDay] + [self.manager getBudgetOnCurrentDayMoneyDouble] dayWhenSpend:[NSDate date]];
    
    //значение для switch в настройках дня 1 пункта
    [self.manager setTransferMoneyToNextDaySettingsDay:YES];
    [self goToVC];
}

- (IBAction)amountOnDailyBudget:(id)sender {
    [self callOneTimeDayBool];
    
    double divided = [self.manager getBudgetOnCurrentDayMoneyDouble] / [self.manager daysToStartNewMonth];
    double amountBudgetOnDay = [self.manager getBudgetOnDay] + divided;
    [self.manager setBudgetOnDay:amountBudgetOnDay];
    [self.manager setBudgetOnCurrentDay:amountBudgetOnDay dayWhenSpend:[NSDate date]];
    
    //значение для switch в настройках дня 2 пункта
    [self.manager setAmountOnDailyBudgetSettingsDay:YES];
    [self goToVC];
}

- (void)goToVC {
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
    MainScreenTableViewController *mainScreenTableViewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainScreenTableViewController"];
    [nav pushViewController:mainScreenTableViewVC animated:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
