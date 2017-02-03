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
@property (strong, nonatomic) NSMutableArray *reverseArrayForTable;
@property (strong, nonatomic) NSTimer* updateTimer;
@end

@implementation MainScreenTableViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.arrayForTable = [[userDefaults objectForKey:@"historySpendOfMonth"] mutableCopy];
    self.reverseArrayForTable = [[[self.arrayForTable reverseObjectEnumerator] allObjects] mutableCopy];
    [self recalculationEveryMonth];
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
                                             selector:@selector(recalculationEveryMonth)
                                                 name:@"NotificationRecalculationEveryMonth"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTextCurrentBudgetOnDayLabel)
                                                 name:@"updateTextCurrentBudgetOnDayLabel"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopTimer];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotificationRecalculationEveryMonth" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateTextCurrentBudgetOnDayLabel" object:nil];
}

- (void) reloadDateInTableView {
    [self.tableView reloadData];
}

- (void)customise {
    self.navigationItem.hidesBackButton = YES;//прячем кнопку назад на navBar
    self.headerView.processOfSpendingMoneyTextField.delegate = self;
    [self.headerView.processOfSpendingMoneyTextField becomeFirstResponder];
    [self.headerView.iSpendTextLabel setAlpha:0];
    self.headerView.processOfSpendingMoneyTextField.tintColor = [UIColor clearColor];//убираем мигающий курсор
}

- (void)updateTextCurrentBudgetOnDayLabel {
    self.headerView.currentBudgetOnDayLabel.text = [NSString stringWithFormat:@"%.2f", [self.manager getBudgetOnCurrentDayMoneyDouble]];
}

- (void)recalculationEveryDay {
    
    if ([self.manager differenceDay] != 0) {
        
        [self.manager resetBoolOfNegativeBalanceEndDay];
        
        if ([self.manager getBudgetOnCurrentDayMoneyDouble] > 0 && [self.manager getCallOneTimeDay]) {
            
            if ([self.manager getTransferMoneyToNextDaySettingsDay]) {
                [self.manager setBudgetOnCurrentDay:[self.manager getBudgetOnDay] + [self.manager getBudgetOnCurrentDayMoneyDouble] dayWhenSpend:[NSDate date]];
            } else if ([self.manager getAmountOnDailyBudgetSettingsDay] && [self.manager getCallOneTimeDay]) {
                double divided = [self.manager getBudgetOnCurrentDayMoneyDouble] / [self.manager daysToStartNewMonth];
                double amountBudgetOnDay = [self.manager getBudgetOnDay] + divided;
                [self.manager setBudgetOnDay:amountBudgetOnDay];
                [self.manager setBudgetOnCurrentDay:amountBudgetOnDay dayWhenSpend:[NSDate date]];
            }
        }
        
        if ([self.manager getBudgetOnCurrentDayMoneyDouble] < 0) {
            
            if ([self.manager getDailyBudgetTomorrowCountedBool]) {
                [self.manager setBudgetOnCurrentDay:[self.manager getDailyBudgetTomorrowCounted] dayWhenSpend:[NSDate date]];
                [self.manager setDailyBudgetTomorrowCounted:[self.manager getBudgetOnDay]];
                [self.manager setDailyBudgetTomorrowCountedBool:NO];
                [self.manager setDailyBudgetTomorrowBool:NO];
            } else {
                [self.manager setBudgetOnCurrentDay:[self.manager getBudgetOnDay] dayWhenSpend:[NSDate date]];
                [self.manager setDailyBudgetTomorrowBool:NO];
            }
        }
    }
}

- (void)recalculationEveryMonth {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([[NSDate date] compare:[self.manager getResetDateEveryMonth]] == NSOrderedDescending) {
        
        const NSString *emptyBudgetToMoneyBox = @"0";
        
        if (![self.manager getCallOneTimeMonth]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
            MonthEndViewController *monthEndViewControllerVC = [storyboard instantiateViewControllerWithIdentifier:@"MonthEndViewController"];
            [self.navigationController pushViewController:monthEndViewControllerVC animated:NO];
        }
        
        [self.manager resetDate];//update date
        
        if ([self.manager getChangeAllStableDebitBool]) {
            [self.manager setAllStableDebit];
        } else {
            [self.manager setStableBudgetOnDay:[self.manager getMonthDebit] / [self.manager daysInCurrentMonth]];
        }
        
        if ([self.manager getTransferMoneyNextDaySettingsMonth] && [self.manager getCallOneTimeMonth]) {
            
            if ([self.manager getWithPercent]) {
                [self.manager setMoneyBox:[self.manager getMonthPercent] + [self.manager getMoneyBox]];
            }
            
            [self.manager setBudgetOnCurrentDay:[self.manager getStableBudgetOnDay] + [self.manager getMutableMonthDebit] dayWhenSpend:[NSDate date]];
            [self.manager setBudgetOnDay:[self.manager getStableBudgetOnDay]];
            [self.manager setDailyBudgetTomorrowCounted:[self.manager getStableBudgetOnDay]];
            [self.manager setMutableMonthDebit:[self.manager getMonthDebit] + [self.manager getMutableMonthDebit]];
            
            [self.manager workWithHistoryOfSave:emptyBudgetToMoneyBox nameOfPeriod:[self.manager stringForHistorySaveOfMonthDict]];
            [userDefaults setObject:nil forKey:@"historySpendOfMonth"];
            [userDefaults synchronize];
            
        } else if ([self.manager getAmountDailyBudgetSettingsMonth] && [self.manager getCallOneTimeMonth]) {
            
            if ([self.manager getWithPercent]) {
                [self.manager setMoneyBox:[self.manager getMonthPercent] + [self.manager getMoneyBox]];
            }
            
            double divided = [self.manager getMutableMonthDebit] / [self.manager daysToStartNewMonth];
            double amountBudgetOnDay = [self.manager getStableBudgetOnDay] + divided;
            [self.manager setBudgetOnDay:amountBudgetOnDay];
            [self.manager setBudgetOnCurrentDay:amountBudgetOnDay dayWhenSpend:[NSDate date]];
            [self.manager setDailyBudgetTomorrowCounted:amountBudgetOnDay];
            [self.manager setMutableMonthDebit:[self.manager getMonthDebit] + [self.manager getMutableMonthDebit]];
            
            [self.manager workWithHistoryOfSave:emptyBudgetToMoneyBox nameOfPeriod:[self.manager stringForHistorySaveOfMonthDict]];
            [userDefaults setObject:nil forKey:@"historySpendOfMonth"];
            [userDefaults synchronize];
            
        } else if ([self.manager getMoneyBoxSettingsMonth] && [self.manager getCallOneTimeMonth]) {
            
            if ([self.manager getWithPercent]) {
                [self.manager setMoneyBox:[self.manager getMutableMonthDebit] + [self.manager getMonthPercent] + [self.manager getMoneyBox]];
            } else {
                [self.manager setMoneyBox:[self.manager getMutableMonthDebit] + [self.manager getMoneyBox]];
            }
            
            //массив для подсчета отложенного бюджета за год
            NSMutableArray *arrForHistorySaveOfMonthMoneyDebit = [[userDefaults objectForKey:@"historySaveOfMonthMoneyDebit"] mutableCopy];
            if (arrForHistorySaveOfMonthMoneyDebit == nil) {
                arrForHistorySaveOfMonthMoneyDebit = [NSMutableArray array];
            }
            [arrForHistorySaveOfMonthMoneyDebit addObject:[self.manager getMutableMonthDebitNumber]];
            [userDefaults setObject:arrForHistorySaveOfMonthMoneyDebit forKey:@"historySaveOfMonthMoneyDebit"];
            //
            
            [self.manager workWithHistoryOfSave:[self.manager getMutableMonthDebitNumber] nameOfPeriod:[self.manager stringForHistorySaveOfMonthDict]];
            [userDefaults setObject:nil forKey:@"historySpendOfMonth"];
            
            [self.manager setBudgetOnDay:[self.manager getStableBudgetOnDay]];
            [self.manager setBudgetOnCurrentDay:[self.manager getBudgetOnDay] dayWhenSpend:[NSDate date]];
            [self.manager setMutableMonthDebit:[self.manager getMonthDebit]];
            [self.manager setDailyBudgetTomorrowCounted:[self.manager getBudgetOnDay]];
            [userDefaults synchronize];
        }
        [self.manager resetBoolOfNegativeBalanceEndMonth];
    } else {
        [self recalculationEveryDay];
        [self newYear];
    }
}

//для подсчета скопленного бюджета за год (копилка)
- (void)newYear {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults integerForKey:@"Year"]) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *currDate = [NSDate date];
        NSInteger yearOfCurrDate = [calendar component:NSCalendarUnitYear fromDate:currDate];
        [userDefaults setInteger:yearOfCurrDate forKey:@"Year"];
    }
    NSInteger yearOfCurrDateInt = [userDefaults integerForKey:@"Year"];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger yearOfCurrDate = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    
    if (yearOfCurrDateInt < yearOfCurrDate) {
        NSArray *historySaveOfMonthMoneyDebit = [[userDefaults objectForKey:@"historySaveOfMonthMoneyDebit"] mutableCopy];
        double sumOfSaveMoneyForYear = 0.0;
        for (NSNumber* budgetInArray in historySaveOfMonthMoneyDebit) {
            sumOfSaveMoneyForYear = sumOfSaveMoneyForYear + [budgetInArray doubleValue];
        }
        [self.manager workWithHistoryOfSave:[NSNumber numberWithDouble:sumOfSaveMoneyForYear] nameOfPeriod:[NSString stringWithFormat:@"%ld", yearOfCurrDateInt]];
        
        [userDefaults setObject:nil forKey:@"historySaveOfMonthMoneyDebit"];
        [userDefaults setInteger:yearOfCurrDate forKey:@"Year"];
    }
    
    [userDefaults synchronize];
}

- (void)negativeBalance {
    if ([self.manager getBudgetOnCurrentDayMoneyDouble] < 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        NegativeBalanceViewController *negativeBalanceViewControllerVC = [storyboard instantiateViewControllerWithIdentifier:@"NegativeBalanceViewController"];
        [self.navigationController pushViewController:negativeBalanceViewControllerVC animated:YES];
    }
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
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                    target:self
                                                  selector:@selector(reloadDateInTableView)
                                                  userInfo:nil
                                                   repeats:YES];
}

- (void)stopTimer{
    [_updateTimer invalidate];
    _updateTimer = nil;
}
#pragma mark - UIScrollViewDelegat -

//когда клавиатура выезжает
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < - 64 ) {
        [self.headerView.processOfSpendingMoneyTextField becomeFirstResponder];
        
    }
    else if (scrollView.contentOffset.y > 41 ) {
        [self.headerView.processOfSpendingMoneyTextField resignFirstResponder];
        
    }
}

#pragma mark - Work with TextFieldKeyboard and Custom Button "Add" -

//вызов функции при нажатии на созданую кнопку Add
- (IBAction)addBtnFromKeyboardClicked:(id)sender {
    [self checkTextField];
}

- (void)checkTextField {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
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
        
        [self cleanupProcessOfSpendingMoneyTextField];
        
    } else {
        
        NSNumberFormatter* numberFormatter = [NSNumberFormatter new];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *currentSpendNumber = [numberFormatter numberFromString:self.headerView.processOfSpendingMoneyTextField.text];

        NSMutableArray *historySpendOfMonth = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"historySpendOfMonth"]];
        if (historySpendOfMonth == nil) {
            historySpendOfMonth = [NSMutableArray array];
        }
        //tableview (history)
        NSMutableDictionary *dictWithDateAndSum = [NSMutableDictionary new];
        [dictWithDateAndSum setObject:currentSpendNumber forKey: @"currentSpendNumber"];
        [dictWithDateAndSum setObject:[NSDate date] forKey:@"currentDateOfSpend"];
        [historySpendOfMonth addObject:dictWithDateAndSum];
        [userDefaults setObject:historySpendOfMonth forKey:@"historySpendOfMonth"];
        [userDefaults synchronize];
        
        self.arrayForTable = historySpendOfMonth;
        self.reverseArrayForTable = [[[self.arrayForTable reverseObjectEnumerator] allObjects] mutableCopy];
        [self.tableView reloadData];

        //работа с бюджетом на день
        NSMutableDictionary *budgetOnCurrentDay = [[[Manager sharedInstance] getBudgetOnCurrentDay] mutableCopy];
        [budgetOnCurrentDay setObject: [NSNumber numberWithDouble:[self.manager getBudgetOnCurrentDayMoneyDouble] - fabs([currentSpendNumber doubleValue])] forKey:@"mutableBudgetOnDay"];
        [userDefaults setObject:budgetOnCurrentDay  forKey:@"budgetOnCurrentDay"];
        
        //work with mutableMonthdebit
        [self.manager setMutableMonthDebit:[self.manager getMutableMonthDebit] - fabs([currentSpendNumber doubleValue])];
        
        [userDefaults setDouble:fabs([currentSpendNumber doubleValue]) forKey:@"processOfSpendingMoneyTextField"];
        [userDefaults synchronize];
        
        self.headerView.currentBudgetOnDayLabel.text = [self.manager updateTextBalanceLabel];
        [self negativeBalance];
        [self cleanupProcessOfSpendingMoneyTextField];
    }
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
    NSDictionary *tempDataOfSpend = [self.reverseArrayForTable objectAtIndex:indexPath.row];
    
    NSDate *date = [tempDataOfSpend objectForKey:@"currentDateOfSpend"];
    cell.howLongAgoSpandMoneyLabel.text = [[Manager sharedInstance] workWithDateForMainTable:date];
    
    NSNumber *spend = [tempDataOfSpend objectForKey:@"currentSpendNumber"];
    cell.howMuchMoneySpendLabel.text = [NSString stringWithFormat:@"%.2f", [spend doubleValue]];
 
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.arrayForTable removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
        self.reverseArrayForTable = [[[self.arrayForTable reverseObjectEnumerator] allObjects] mutableCopy];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.arrayForTable forKey:@"historySpendOfMonth"];
        [userDefaults synchronize];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Удалить";
}


@end
