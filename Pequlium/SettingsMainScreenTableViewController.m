//
//  SettingsMainScreenTableViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 14.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "SettingsMainScreenTableViewController.h"
#import "SettingsMainScreenHeaderView.h"
#import "SettingsMainScreenTableViewCell.h"
#import "SettingsDayBalanceTableViewController.h"
#import "SettingsMonthBalanceTableViewController.h"
#import "ResolutionTableViewController.h"
#import "MoneyBoxHistoryTableViewController.h"

@interface SettingsMainScreenTableViewController () <SettingsMainScreenHeaderViewDelegate>
@property (strong, nonatomic) NSArray *textForCell;
@end

@implementation SettingsMainScreenTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self xibInHeaderToTableView];
    self.tableView.tableFooterView = [UIView new];
    self.textForCell = @[@"Дневной остаток", @"Ежемесячный остаток", @"Разрешить уведомления", @"Отзыв", @"О приложении"];
}

- (void)xibInHeaderToTableView {
    //добавление xib в tableview header
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    SettingsMainScreenHeaderView *headerView = [[SettingsMainScreenHeaderView alloc] initWithDate:[userDefaults objectForKey:@"resetDateEveryMonth"] lastMoney:[userDefaults doubleForKey:@"mutableMonthDebit"] moneyBox:[[userDefaults objectForKey:@"moneyBox"] doubleValue]];
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
    
}

#pragma mark - Header view delegate -

- (void)tappedMoneyBox {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    MoneyBoxHistoryTableViewController *moneyBoxHistoryTableViewControllerVC = [storyboard instantiateViewControllerWithIdentifier:@"MoneyBoxHistoryTableViewController"];
    [self.navigationController pushViewController:moneyBoxHistoryTableViewControllerVC animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textForCell.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsMainScreenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellReuseIdentifier" forIndexPath:indexPath];
    cell.textForCellInSettingsMainScreenTableViewController.text = self.textForCell[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self settingsDayBalanceVC];
            break;
        case 1:
            [self settingsMonthBalanceVC];
            break;
        case 2:
            [self resolutonVC];
            break;
        default:
            break;
    }
}

- (void)settingsDayBalanceVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    SettingsDayBalanceTableViewController *settingsDayBalanceVC = [storyboard instantiateViewControllerWithIdentifier:@"SettingsDayBalanceTableViewController"];
    [self.navigationController pushViewController:settingsDayBalanceVC animated:YES];
}

- (void)settingsMonthBalanceVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    SettingsMonthBalanceTableViewController *settingsMonthBalanceVC = [storyboard instantiateViewControllerWithIdentifier:@"SettingsMonthBalanceTableViewController"];
    [self.navigationController pushViewController:settingsMonthBalanceVC animated:YES];
}

- (void)resolutonVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    ResolutionTableViewController *resolutionVC = [storyboard instantiateViewControllerWithIdentifier:@"ResolutionTableViewController"];
    [self.navigationController pushViewController:resolutionVC animated:YES];
}

@end
