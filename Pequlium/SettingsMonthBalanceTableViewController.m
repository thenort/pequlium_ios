//
//  SettingsMonthBalanceTableViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 05.01.17.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

#import "SettingsMonthBalanceTableViewController.h"


@interface SettingsMonthBalanceTableViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *transferMoneyNextDaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *amountDailyBudgetSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *moneyBoxSwitch;
@end

@implementation SettingsMonthBalanceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = btnBack;
    self.tableView.tableFooterView = [UIView new];
    
    [self updateSwitchView];
    
    
}

- (void)updateSwitchView {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"transferMoneyNextDaySettingsMonth"]) {
        self.transferMoneyNextDaySwitch.on = YES;
    } else if ([userDefaults boolForKey:@"amountDailyBudgetSettingsMonth"]) {
        self.amountDailyBudgetSwitch.on = YES;
    } else if ([userDefaults boolForKey:@"moneyBoxSettingsMonth"]) {
        self.moneyBoxSwitch.on = YES;
    }
}

- (IBAction)pressedTransferMoneyNextDaySwitch:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([self.transferMoneyNextDaySwitch isOn]) {
        [self.amountDailyBudgetSwitch setOn:NO animated:YES];
        [self.moneyBoxSwitch setOn:NO animated:YES];
        [userDefaults setBool:YES forKey:@"transferMoneyNextDaySettingsMonth"];
        [userDefaults setBool:NO forKey:@"amountDailyBudgetSettingsMonth"];
        [userDefaults setBool:NO forKey:@"moneyBoxSettingsMonth"];
    } else {
        if (![userDefaults boolForKey:@"amountDailyBudgetSettingsMonth"] || ![userDefaults boolForKey:@"moneyBoxSettingsMonth"]) {
            self.transferMoneyNextDaySwitch.on = YES;
        }
    }
    
    [userDefaults synchronize];
}

- (IBAction)pressedAmountDailyBudgetSwitch:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([self.amountDailyBudgetSwitch isOn]) {
        [self.transferMoneyNextDaySwitch setOn:NO animated:YES];
        [self.moneyBoxSwitch setOn:NO animated:YES];
        [userDefaults setBool:YES forKey:@"amountDailyBudgetSettingsMonth"];
        [userDefaults setBool:NO forKey:@"transferMoneyNextDaySettingsMonth"];
        [userDefaults setBool:NO forKey:@"moneyBoxSettingsMonth"];
    } else {
        if (![userDefaults boolForKey:@"transferMoneyNextDaySettingsMonth"] || ![userDefaults boolForKey:@"moneyBoxSettingsMonth"]) {
            self.amountDailyBudgetSwitch.on = YES;
        }
    }
    
    [userDefaults synchronize];
}

- (IBAction)pressedMoneyBoxSwitch:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([self.moneyBoxSwitch isOn]) {
        [self.transferMoneyNextDaySwitch setOn:NO animated:YES];
        [self.amountDailyBudgetSwitch setOn:NO animated:YES];
        [userDefaults setBool:NO forKey:@"amountDailyBudgetSettingsMonth"];
        [userDefaults setBool:NO forKey:@"transferMoneyNextDaySettingsMonth"];
        [userDefaults setBool:YES forKey:@"moneyBoxSettingsMonth"];
    } else {
        if (![userDefaults boolForKey:@"transferMoneyNextDaySettingsMonth"] || ![userDefaults boolForKey:@"amountDailyBudgetSettingsMonth"]) {
            self.moneyBoxSwitch.on = YES;
        }
    }
    
    [userDefaults synchronize];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

@end
