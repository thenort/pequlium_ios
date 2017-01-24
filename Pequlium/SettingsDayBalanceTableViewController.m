//
//  SettingsDayBalanceTableViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 05.01.17.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

#import "SettingsDayBalanceTableViewController.h"


@interface SettingsDayBalanceTableViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *transferMoneyToNextDaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *amountOnDailyBudgetSwitch;
@end

@implementation SettingsDayBalanceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = btnBack;
    [self updateSwitchView];
}

#pragma mark - Work with Switch -

- (void)updateSwitchView {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"transferMoneyToNextDaySettingsDay"]) {
        self.transferMoneyToNextDaySwitch.on = YES;
    } else if ([userDefaults boolForKey:@"amountOnDailyBudgetSettingsDay"]) {
        self.amountOnDailyBudgetSwitch.on = YES;
    }
    [userDefaults synchronize];
}

- (IBAction)pressedTransferMoneyToNextDaySwitch:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([self.transferMoneyToNextDaySwitch isOn]) {
        [self.amountOnDailyBudgetSwitch setOn:NO animated:YES];
        [userDefaults setBool:YES forKey:@"transferMoneyToNextDaySettingsDay"];
        [userDefaults setBool:NO forKey:@"amountOnDailyBudgetSettingsDay"];
    } else {
        if (![userDefaults boolForKey:@"amountOnDailyBudgetSettingsDay"]) {
            self.transferMoneyToNextDaySwitch.on = YES;
        }
    }
    [userDefaults synchronize];
}

- (IBAction)pressedAmountOnDailyBudgetSwitch:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([self.amountOnDailyBudgetSwitch isOn]) {
        [self.transferMoneyToNextDaySwitch setOn:NO animated:YES];
        [userDefaults setBool:YES forKey:@"amountOnDailyBudgetSettingsDay"];
        [userDefaults setBool:NO forKey:@"transferMoneyToNextDaySettingsDay"];
    } else {
        if (![userDefaults boolForKey:@"transferMoneyToNextDaySettingsDay"]) {
            self.amountOnDailyBudgetSwitch.on = YES;
        }
    }
    [userDefaults synchronize];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


@end
