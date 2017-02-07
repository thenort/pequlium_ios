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
    self.navigationItem.hidesBackButton = YES;
}

- (void)callOneTimeDayBool {
    [self.manager setCallOneTimeDay:YES];
}

- (IBAction)moveBalanceOnToday:(id)sender {
    [self callOneTimeDayBool];
    [self.manager moveBalanceOnTodayDayEnd];
    //значение для switch в настройках дня 1 пункта
    [self.manager setTransferMoneyToNextDaySettingsDay:YES];
    [self popVC];
}

- (IBAction)amountOnDailyBudget:(id)sender {
    [self callOneTimeDayBool];
    [self.manager amountOnDailyBudgetDayEnd];
    //значение для switch в настройках дня 2 пункта
    [self.manager setAmountOnDailyBudgetSettingsDay:YES];
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
