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
    self.arrayForTable = [[userDefaults objectForKey:@""] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.arrayForTable count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoneyBoxHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moneyCell" forIndexPath:indexPath];
    NSDictionary *tempDataOfSave = [self.arrayForTable objectAtIndex:indexPath.row];
    
    NSString *stringDate = [tempDataOfSave objectForKey:@""];
    
    
    NSNumber *save = [tempDataOfSave objectForKey:@""];
    
    return cell;
}



@end
