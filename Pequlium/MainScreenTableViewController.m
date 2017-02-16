//
//  MainScreenTableViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 14.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "MainScreenTableViewController.h"
#import "MainScreenHeaderView.h"
#import "Manager.h"
#import "MainScreenTableViewCell.h"
#import "DayEndViewController.h"
#import "MonthEndViewController.h"
#import "NegativeBalanceViewController.h"


@interface MainScreenTableViewController () <UITextFieldDelegate>
@property (strong, nonatomic) MainScreenHeaderView *headerView;
@property (strong, nonatomic) Manager *manager;
@property (strong, nonatomic) NSMutableArray *arrayForTable;
@property (strong, nonatomic) NSTimer *updateTimer;
@property (strong, nonatomic) NSNumber *currentSpendNumber;
@end

@implementation MainScreenTableViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.headerView.processOfSpendingMoneyTextField becomeFirstResponder];

    self.arrayForTable = [self.manager getHistorySpendOfMonth];
    [self callMonthEndDayEndControllers];
    [self.manager recalculationEveryMonth];
    self.headerView.currentBudgetOnDayLabel.text = [self.manager updateTextBalanceLabel];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [Manager sharedInstance];
    [self xibInHeaderToTableView];
    [self customise];
    [self.manager customBtnOnKeyboardFor:self.headerView.processOfSpendingMoneyTextField nameOfAction:@selector(addBtnFromKeyboardClicked:)];
    [self.headerView.processOfSpendingMoneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTextCurrentBudgetOnDayLabel)
                                                 name:@"updateTextCurrentBudgetOnDayLabel"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callMonthEndDayEndControllers)
                                                 name:@"callMonthEndDayEndControllers"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopTimer];
    [self.headerView.processOfSpendingMoneyTextField resignFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateTextCurrentBudgetOnDayLabel" object:nil];
}

- (void)callMonthEndDayEndControllers {
    if ([[NSDate date] compare:[self.manager getResetDateEveryMonth]] == NSOrderedDescending) {
        if (![self.manager getCallOneTimeMonth]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
            MonthEndViewController *monthEndViewControllerVC = [storyboard instantiateViewControllerWithIdentifier:@"MonthEndViewController"];
            [self.navigationController pushViewController:monthEndViewControllerVC animated:YES];
        }
    } else {
        if ([self.manager differenceDay] != 0 && ![self.manager getCallOneTimeDay]) {
            if ([self.manager getBudgetOnCurrentDayMoneyDouble] > 0) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
                DayEndViewController *dayEndViewControllerVC = [storyboard instantiateViewControllerWithIdentifier:@"DayEndViewController"];
                [self.navigationController pushViewController:dayEndViewControllerVC animated:YES];
            }
        }
    }
}

- (void) reloadDateInTableView {
    [self.tableView reloadData];
}

- (void)customise {
    self.navigationItem.hidesBackButton = YES;
    self.headerView.processOfSpendingMoneyTextField.delegate = self;
    [self.headerView.processOfSpendingMoneyTextField becomeFirstResponder];
    [self.headerView.iSpendTextLabel setAlpha:0];
    self.headerView.processOfSpendingMoneyTextField.tintColor = [UIColor clearColor];
}

- (void)updateTextCurrentBudgetOnDayLabel {
    self.headerView.currentBudgetOnDayLabel.text = [NSString stringWithFormat:@"%.2f", [self.manager getBudgetOnCurrentDayMoneyDouble]];
}

- (void)negativeBalance {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    NegativeBalanceViewController *negativeBalanceViewControllerVC = [storyboard instantiateViewControllerWithIdentifier:@"NegativeBalanceViewController"];
    negativeBalanceViewControllerVC.valueFromKeyboard = fabs([self.currentSpendNumber doubleValue]);
    [self.navigationController pushViewController:negativeBalanceViewControllerVC animated:YES];
}

//добавление xib в tableview header
- (void)xibInHeaderToTableView {
    self.headerView = (MainScreenHeaderView*)[[[NSBundle mainBundle] loadNibNamed:@"MainScreenHeaderXib" owner:self options:nil]objectAtIndex:0];
    self.tableView.tableHeaderView = self.headerView;
    [self autoresizeXib];
}

- (void)autoresizeXib {
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat height = CGRectGetHeight(screen);
    
    if (height > 480.f && height <= 568.f) {
        [self.tableView.tableHeaderView setFrame:CGRectMake(self.tableView.tableHeaderView.frame.origin.x, self.tableView.tableHeaderView.frame.origin.y, self.tableView.tableHeaderView.frame.size.width, 243.f)];
    } else if (height > 568.f && height <= 667.f) {
        [self.tableView.tableHeaderView setFrame:CGRectMake(self.tableView.tableHeaderView.frame.origin.x, self.tableView.tableHeaderView.frame.origin.y, self.tableView.tableHeaderView.frame.size.width, 343.f)];
    } else if (height > 667.f && height <= 736.f) {
        [self.tableView.tableHeaderView setFrame:CGRectMake(self.tableView.tableHeaderView.frame.origin.x, self.tableView.tableHeaderView.frame.origin.y, self.tableView.tableHeaderView.frame.size.width, 400.f)];
    }
}

#pragma mark - Timer -

- (void)startTimer {
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                    target:self
                                                  selector:@selector(reloadDateInTableView)
                                                  userInfo:nil
                                                   repeats:YES];
}

- (void)stopTimer{
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}

#pragma mark - UIScrollViewDelegat -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < - 64 ) {
        [self.headerView.processOfSpendingMoneyTextField becomeFirstResponder];
    }
    else if (scrollView.contentOffset.y > 41 ) {
        [self.headerView.processOfSpendingMoneyTextField resignFirstResponder];
    }
}

#pragma mark - Work with TextFieldKeyboard and Custom Button "Add" -

- (IBAction)addBtnFromKeyboardClicked:(id)sender {
    [self checkTextField];
}

- (void)checkTextField {
    if ([self.headerView.processOfSpendingMoneyTextField.text length] <= 0 || [self.headerView.processOfSpendingMoneyTextField.text  isEqual: @"-0"]) {
        
        NSString *error = @"Введите корректную сумму";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ошибка!" message:error preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else if (fabs([self.headerView.processOfSpendingMoneyTextField.text doubleValue]) > [self.manager getMutableMonthDebit]) {
        
        NSString *error = @"Введенная вами сумма превышает ваш месячный финансовый остаток";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ошибка" message:error preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];

    } else {
        
        self.currentSpendNumber = [self.manager numFromStringDecimal:self.headerView.processOfSpendingMoneyTextField.text];
        double mutableBudgetOnDay = [self.manager getBudgetOnCurrentDayMoneyDouble] - fabs([self.currentSpendNumber doubleValue]);
        
        if (mutableBudgetOnDay < 0) {
            [self negativeBalance];
        } else {
            [self.manager setHistorySpendOfMonth:self.currentSpendNumber andDate:[NSDate date]];
            self.arrayForTable = [self.manager getHistorySpendOfMonth];
            [self.tableView reloadData];
            
            [self.manager operationMinWithBudget:fabs([self.currentSpendNumber doubleValue])];
            
            self.headerView.currentBudgetOnDayLabel.text = [self.manager updateTextBalanceLabel];
        }
    }
    [self cleanupProcessOfSpendingMoneyTextField];
}

- (void)cleanupProcessOfSpendingMoneyTextField {
    //при нажатии на кнопку Add очищаем textfield и ставим lable в изначальное значения Альфы
    self.headerView.processOfSpendingMoneyTextField.text = @"";
    if ([self.headerView.processOfSpendingMoneyTextField.text  isEqual: @""]) {
        [self.headerView.iSpendTextLabel setAlpha:0];
        [self.headerView.startEnterLabel setAlpha:1];
    }
}

#pragma mark - UITextFieldDelegate -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя_-+=!№;%:?@#$^&*() ";
    NSCharacterSet *acceptedInput = [NSCharacterSet characterSetWithCharactersInString:str];
    if ([[string componentsSeparatedByCharactersInSet:acceptedInput] count] > 1){
        return NO;
    } else {
        return YES;
    }
}

//работа с лейблами находящимися в UITextField и знак минус
-(void)textFieldDidChange:(UITextField *)textField {
    if ([textField.text length] > 0) {
        NSString *firstLetter = [textField.text substringToIndex:1];
        if (![firstLetter isEqualToString:@"-"]) {
            textField.text = [NSString stringWithFormat:@"%s%@", "-", textField.text];
        }
    }
    if ([textField.text length] > 0) {
        [self.headerView.startEnterLabel setAlpha:0];
        [self.headerView.iSpendTextLabel setAlpha:1];
    } else {
        [self.headerView.startEnterLabel setAlpha:1];
        [self.headerView.iSpendTextLabel setAlpha:0];
    }
}

#pragma mark - Table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayForTable count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainScreenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseId" forIndexPath:indexPath];
    NSDictionary *tempDataOfSpend = [self.arrayForTable objectAtIndex:indexPath.row];
    
    NSDate *date = [tempDataOfSpend objectForKey:@"currentDateOfSpend"];
    cell.howLongAgoSpandMoneyLabel.text = [self.manager workWithDateForMainTable:date];
    
    NSNumber *spend = [tempDataOfSpend objectForKey:@"currentSpendNumber"];
    cell.howMuchMoneySpendLabel.text = [NSString stringWithFormat:@"%.2f", [spend doubleValue]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.arrayForTable removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.manager setHistorySpendOfMonthArray:self.arrayForTable];
        [tableView reloadData];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Удалить";
}


@end
