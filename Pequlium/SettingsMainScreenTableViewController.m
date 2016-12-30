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

@interface SettingsMainScreenTableViewController ()
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
    SettingsMainScreenHeaderView *headerView = [[SettingsMainScreenHeaderView alloc]initWithDate:[userDefaults objectForKey:@"resetDateEveryMonth"] lastMoney:[userDefaults doubleForKey:@"mutableMonthDebit"]];
    self.tableView.tableHeaderView = headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
}


@end
