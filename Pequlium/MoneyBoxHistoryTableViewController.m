//
//  MoneyBoxHistoryTableViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 13.01.17.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

#import "MoneyBoxHistoryTableViewController.h"
#import "MoneyBoxHistoryTableViewCell.h"

@interface MoneyBoxHistoryTableViewController ()
@property (strong, nonatomic) NSArray *arrayForTable;
@property (strong, nonatomic) NSArray *reverseArrayForTable;
@end

@implementation MoneyBoxHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = btnBack;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.arrayForTable = [[userDefaults objectForKey:@"historySaveOfMonth"] mutableCopy];
    self.reverseArrayForTable = [[self.arrayForTable reverseObjectEnumerator] allObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayForTable count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoneyBoxHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moneyCell" forIndexPath:indexPath];
    NSDictionary *tempDataOfSave = [self.reverseArrayForTable objectAtIndex:indexPath.row];
    
    NSString *stringPeriod = [tempDataOfSave objectForKey:@"currentMonthPeriod"];
    cell.nameOfMonth.text = [NSString stringWithFormat:@"%@", stringPeriod];
    NSNumber *saveMoney = [tempDataOfSave objectForKey:@"currentMutableMonthDebit"];
    cell.moneySave.text = [NSString stringWithFormat:@"%.2f", [saveMoney doubleValue]];
    
    return cell;
}



@end
