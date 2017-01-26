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
#import "Manager.h"

@interface SettingsMainScreenTableViewController () <SettingsMainScreenHeaderViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) SettingsMainScreenHeaderView *headerView;
@property (strong, nonatomic) NSArray *textForCell;
@end

@implementation SettingsMainScreenTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self xibInHeaderToTableView];
    self.tableView.tableFooterView = [UIView new];
    self.textForCell = @[@"Дневной остаток", @"Ежемесячный остаток", @"Разрешить уведомления", @"Отзыв", @"О приложении"];
    
    [[Manager sharedInstance] customBtnOnKeyboardFor:self.headerView.enterMoneyTextField nameOfAction:@selector(checkTextField)];
    [self.headerView.enterMoneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //self.headerView.enterMoneyTextField.tintColor = [UIColor clearColor];//убираем мигающий курсор
}

- (void)xibInHeaderToTableView {
    //добавление xib в tableview header
    self.headerView = (SettingsMainScreenHeaderView*)[[[NSBundle mainBundle] loadNibNamed:@"SettingsMainScreenHeader" owner:self options:nil]objectAtIndex:0];
    self.headerView.delegate = self;
    self.tableView.tableHeaderView = self.headerView;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd MMMM"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    NSString *dateString = [dateFormatter stringFromDate:[userDefaults objectForKey:@"resetDateEveryMonth"]];
    
    self.headerView.summaToNewMonthLabel.text = [NSString stringWithFormat:@"Сумма до %@", dateString];
    self.headerView.howMuchMoneyToNewMonthLabel.text = [NSString stringWithFormat:@"%2.f", [userDefaults doubleForKey:@"mutableMonthDebit"]];
    [self.headerView.moneyBoxButton setTitle:[NSString stringWithFormat:@"%2.f", [[userDefaults objectForKey:@"moneyBox"] doubleValue]] forState:UIControlStateNormal];
}

- (void)checkTextField {
    [UIView animateWithDuration:0.5f animations:^{
        self.headerView.textFieldHeightConstraint.constant = -100.f;
        [self.view layoutIfNeeded];
        [self.headerView.enterMoneyTextField resignFirstResponder];
    }];
}

- (void)tappedAddMoneyButton {
    [UIView animateWithDuration:0.5f animations:^{
        self.headerView.textFieldHeightConstraint.constant = +100.f;
        [self.view layoutIfNeeded];
        [self.headerView.enterMoneyTextField becomeFirstResponder];
    }];
    
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

#pragma mark - UITextFieldDelegate -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя_-=!№;%:?@#$^&*() ";
    NSCharacterSet *acceptedInput = [NSCharacterSet characterSetWithCharactersInString:str];
    if ([[string componentsSeparatedByCharactersInSet:acceptedInput] count] > 1){
        return NO;
    } else {
        return YES;
    }
}

//работа с лейблами находящимися в UITextField и знак плюс [self.headerView.enterMoneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

-(void)textFieldDidChange:(UITextField *)textField {
    if ([textField.text length] > 0) {
        NSString *firstLetter = [textField.text substringToIndex:1];
        if (![firstLetter isEqualToString:@"+"]) {
            textField.text = [NSString stringWithFormat:@"%s%@", "+", textField.text];
        }
    }
    if ([textField.text length] > 0) {
        [self.headerView.addMoneyButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    } else {
        [self.headerView.addMoneyButton setTitleColor:[UIColor colorWithRed:0.f / 255.f
                                                                      green:153.f / 255.f
                                                                       blue:255.f / 255.f
                                                                      alpha:1.f] forState:UIControlStateNormal];
        
    }
}



@end
