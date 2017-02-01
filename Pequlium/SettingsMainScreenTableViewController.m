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
#import "MonthDebitViewController.h"

@interface SettingsMainScreenTableViewController () <SettingsMainScreenHeaderViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) SettingsMainScreenHeaderView *headerView;
@property (strong, nonatomic) NSArray *textForCell;
@end

@implementation SettingsMainScreenTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self xibInHeaderToTableView];
    self.tableView.tableFooterView = [UIView new];
    self.textForCell = @[@"Дневной остаток", @"Ежемесячный остаток", @"Разрешить уведомления", @"Изменить месячный баланс", @"Отзыв", @"О приложении"];
    self.headerView.enterMoneyTextField.delegate = self;
    [[Manager sharedInstance] customButtonsOnKeyboardFor:self.headerView.enterMoneyTextField addAction:@selector(addButtonTextField) cancelAction:@selector(cancelButtonTextField)];
    [self.headerView.enterMoneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)xibInHeaderToTableView {
    //добавление xib в tableview header
    self.headerView = (SettingsMainScreenHeaderView*)[[[NSBundle mainBundle] loadNibNamed:@"SettingsMainScreenHeader" owner:self options:nil] objectAtIndex:0];
    self.headerView.delegate = self;
    self.tableView.tableHeaderView = self.headerView;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd MMMM"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    NSString *dateString = [dateFormatter stringFromDate:[[Manager sharedInstance] getResetDateEveryMonth]];
    
    self.headerView.summaToNewMonthLabel.text = [NSString stringWithFormat:@"Сумма до %@", dateString];
    self.headerView.howMuchMoneyToNewMonthLabel.text = [NSString stringWithFormat:@"%2.f", [[Manager sharedInstance] getMutableMonthDebit]];
    [self.headerView.moneyBoxButton setTitle:[NSString stringWithFormat:@"%2.f", [[Manager sharedInstance] getMoneyBox]] forState:UIControlStateNormal];
}

#pragma mark - actions buttons on UIToolbar UITextField -

- (void)addButtonTextField {
    
    if ([self.headerView.enterMoneyTextField.text length] == 0 || [self.headerView.enterMoneyTextField.text  isEqual: @"+0"]) {
        NSString *error = @"Введите сумму или нажмите кнопку Cancel";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ошибка" message:error preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {

        [[Manager sharedInstance] setMutableMonthDebit:[[Manager sharedInstance] getMutableMonthDebit] + [self.headerView.enterMoneyTextField.text doubleValue]];
        
        self.headerView.howMuchMoneyToNewMonthLabel.text = [NSString stringWithFormat:@"%2.f", [[Manager sharedInstance] getMutableMonthDebit]];
        double divided = [self.headerView.enterMoneyTextField.text doubleValue] / [[Manager sharedInstance] daysToStartNewMonth];
        double newBudgetOnDay = [[Manager sharedInstance] getBudgetOnDay] + divided;
        [[Manager sharedInstance] setBudgetOnDay:newBudgetOnDay];
        
        if ([[Manager sharedInstance] getDailyBudgetTomorrowCounted]) {
            double newDailyBudgetTomorrowCounted = [[Manager sharedInstance] getDailyBudgetTomorrowCounted] + divided;
            [[Manager sharedInstance] setDailyBudgetTomorrowCounted:newDailyBudgetTomorrowCounted];
        }

        //animation
        [UIView animateWithDuration:0.5 animations:^{
            self.headerView.textFieldHeightConstraint.constant = -70.f;
            [self.headerView layoutIfNeeded];
            [self.headerView.settingsLabel setAlpha:1];
            [self.headerView.enterMoneyTextField resignFirstResponder];
            self.headerView.enterMoneyTextField.text = @"";
            [self.headerView.addMoneyButton setTitleColor:[UIColor colorWithRed:0.f / 255.f
                                                                          green:153.f / 255.f
                                                                           blue:255.f / 255.f
                                                                          alpha:1.f] forState:UIControlStateNormal];
        }];
    }
}

- (void)cancelButtonTextField {
    [UIView animateWithDuration:0.5 animations:^{
        self.headerView.textFieldHeightConstraint.constant = -70.f;
        [self.headerView layoutIfNeeded];
        [self.headerView.settingsLabel setAlpha:1];
        [self.headerView.enterMoneyTextField resignFirstResponder];
        self.headerView.enterMoneyTextField.text = @"";
        [self.headerView.addMoneyButton setTitleColor:[UIColor colorWithRed:0.f / 255.f
                                                                      green:153.f / 255.f
                                                                       blue:255.f / 255.f
                                                                      alpha:1.f] forState:UIControlStateNormal];
    }];
}

#pragma mark - Header view delegate -

- (void)tappedAddMoneyButton {
    [UIView animateWithDuration:0.5 animations:^{
        self.headerView.textFieldHeightConstraint.constant = +70.f;
        [self.headerView layoutIfNeeded];
        [self.headerView.settingsLabel setAlpha:0];
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
        case 3:
            [self monthDebitVC];
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

- (void)monthDebitVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    MonthDebitViewController *monthDebitViewController = [storyboard instantiateViewControllerWithIdentifier:@"MonthDebitViewController"];
    [self.navigationController pushViewController:monthDebitViewController animated:YES];
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

-(void)textFieldDidChange:(UITextField *)textField {
    if ([textField.text length] > 0) {
        NSString *firstLetter = [textField.text substringToIndex:1];
        if (![firstLetter isEqualToString:@"+"]) {
            textField.text = [NSString stringWithFormat:@"%s%@", "+", textField.text];
        }
    }
    if ([textField.text length] > 0) {
        [self.headerView.addMoneyButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    }
}

@end
