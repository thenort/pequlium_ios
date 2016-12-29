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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
