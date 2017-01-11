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
    
}

- (IBAction)pressedTransferMoneyNextDaySwitch:(id)sender {
    
    
}

- (IBAction)pressedAmountDailyBudgetSwitch:(id)sender {
    
    
}

- (IBAction)pressedMoneyBoxSwitch:(id)sender {
    
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

@end
