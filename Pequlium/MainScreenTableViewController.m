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
    self.headerView.currentBudgetOnDayLabel.text = [[Manager sharedInstance] updateTextBalanceLabel];
    [self.tableView reloadData];
    
    [self recalculationEveryMonth];
    [self newYear];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startTimer];

}

- (void)viewDidLoad {
    [self xibInHeaderToTableView];
    [self customise];
    [[Manager sharedInstance] customBtnOnKeyboardFor:self.headerView.processOfSpendingMoneyTextField nameOfAction:@selector(addBtnFromKeyboardClicked:)];
    [self.headerView.processOfSpendingMoneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self updateSwitchViewDay];
    [self updateSwitchViewMonth];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recalculationEveryMonth)
                                                 name:@"NotificationRecalculationEveryMonth"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTextCurrentBudgetOnDayLabel)
                                                 name:@"updateTextCurrentBudgetOnDayLabel"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    NSNumber *mutableBudgetOnDayWithSpendNumberFromDict = [dict objectForKey:@"mutableBudgetOnDay"];
    self.headerView.currentBudgetOnDayLabel.text = [NSString stringWithFormat:@"%.2f", [mutableBudgetOnDayWithSpendNumberFromDict doubleValue]];
}

- (void)recalculationEveryDay {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

    if ([[Manager sharedInstance] differenceDay] != 0) {
        
        NSDictionary *dict = [userDefault objectForKey:@"budgetOnCurrentDay"];
        NSNumber *mutableBudgetWithSpendNumber = [dict objectForKey:@"mutableBudgetOnDay"];
        
        //обнуление bool для negativebalance
        [userDefault setBool:NO forKey:@"callOneTime"];
        //обнуление bool для negativebalance dailyBudgetWillBeLabel
        [userDefault setBool:NO forKey:@"callOneTimeToLable"];
        [userDefault setBool:NO forKey:@"dailyBudgetTomorrowBoolLabel"];
        
        if ([mutableBudgetWithSpendNumber doubleValue] > 0 && [userDefault boolForKey:@"callOneTimeDay"]) {
            if ([userDefault boolForKey:@"transferMoneyToNextDaySettingsDay"]) {
                NSDictionary *budgetOnCurrentDay = [userDefault objectForKey:@"budgetOnCurrentDay"];
                double mutableBudgetOnDay = [userDefault doubleForKey:@"budgetOnDay"] + [mutableBudgetWithSpendNumber doubleValue];
                budgetOnCurrentDay = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate new], @"dayWhenSpend", [NSNumber numberWithDouble:mutableBudgetOnDay], @"mutableBudgetOnDay", nil];
                [userDefault setObject:budgetOnCurrentDay forKey:@"budgetOnCurrentDay"];
            } else if ([userDefault boolForKey:@"amountOnDailyBudgetSettingsDay"]) {
                NSDictionary *budgetOnCurrentDay = [userDefault objectForKey:@"budgetOnCurrentDay"];
                double divided = [mutableBudgetWithSpendNumber doubleValue] / [[Manager sharedInstance] daysToStartNewMonth];
                double amountBudgetOnDay = [userDefault doubleForKey:@"budgetOnDay"] + divided;
                [userDefault setObject:[NSNumber numberWithDouble:amountBudgetOnDay] forKey:@"budgetOnDay"];
                double recalculationBudgetOnDay = [[userDefault objectForKey:@"budgetOnDay"] doubleValue];
                budgetOnCurrentDay = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate new], @"dayWhenSpend", [NSNumber numberWithDouble:recalculationBudgetOnDay], @"mutableBudgetOnDay",  nil];
                [userDefault setObject:budgetOnCurrentDay forKey:@"budgetOnCurrentDay"];
            }
        }
        
        if ([mutableBudgetWithSpendNumber doubleValue] < 0) {
            if ([userDefault boolForKey:@"dailyBudgetTomorrowCountedBool"]) {
                NSDictionary *budgetOnCurrentDay = [userDefault objectForKey:@"budgetOnCurrentDay"];
                double budgetOnDay = [userDefault doubleForKey:@"dailyBudgetTomorrowCounted"];
                budgetOnCurrentDay = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate new], @"dayWhenSpend", [NSNumber numberWithDouble:budgetOnDay], @"mutableBudgetOnDay", nil];
                [userDefault setObject:budgetOnCurrentDay forKey:@"budgetOnCurrentDay"];
                
                double budgetOnDayInDailyBudgetTomorrowCounted = [userDefault doubleForKey:@"budgetOnDay"];
                [userDefault setDouble:budgetOnDayInDailyBudgetTomorrowCounted forKey:@"dailyBudgetTomorrowCounted"];

                [userDefault setBool:NO forKey:@"dailyBudgetTomorrowCountedBool"];
                [userDefault setBool:NO forKey:@"dailyBudgetTomorrowBool"];
                
            } else {
                NSDictionary *budgetOnCurrentDay = [userDefault objectForKey:@"budgetOnCurrentDay"];
                double budgetOnDay = [userDefault doubleForKey:@"budgetOnDay"];
                budgetOnCurrentDay = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate new], @"dayWhenSpend", [NSNumber numberWithDouble:budgetOnDay], @"mutableBudgetOnDay", nil];
                [userDefault setObject:budgetOnCurrentDay forKey:@"budgetOnCurrentDay"];
                [userDefault setBool:NO forKey:@"dailyBudgetTomorrowBool"];
            }
        }
        [userDefault synchronize];
    }
}

- (void)resetBoolOfNegativeBalanceInEndOfMonth {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setBool:NO forKey:@"callOneTime"];
    [userDefaults setBool:NO forKey:@"callOneTimeToLable"];
    [userDefaults setBool:NO forKey:@"dailyBudgetTomorrowBoolLabel"];
    
    [userDefaults setBool:NO forKey:@"dailyBudgetTomorrowCountedBool"];
    [userDefaults setBool:NO forKey:@"dailyBudgetTomorrowBool"];
    
    [userDefaults synchronize];
}

- (void)recalculationEveryMonth {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *resetDateEveryMonth = [userDefaults objectForKey:@"resetDateEveryMonth"];
    
    if ([[NSDate date] compare:resetDateEveryMonth] == NSOrderedDescending) {
        NSString *emptyBudgetToMoneyBox = @"0";
        
        BOOL callOneTimeMonth = [userDefaults boolForKey:@"callOneTimeMonth"];
        
        if (!callOneTimeMonth) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
            MonthEndViewController *monthEndViewControllerVC = [storyboard instantiateViewControllerWithIdentifier:@"MonthEndViewController"];
            [self.navigationController pushViewController:monthEndViewControllerVC animated:NO];
        }
        [[Manager sharedInstance] resetData];
        
       if  ([userDefaults boolForKey:@"transferMoneyNextDaySettingsMonth"]) {
            
            if ([userDefaults boolForKey:@"withPercent"]) {
                double moneyToMoneyBox = [[userDefaults objectForKey:@"monthPercent"] doubleValue] + [[userDefaults objectForKey:@"moneyBox"] doubleValue];
                [userDefaults setObject:[NSNumber numberWithDouble:moneyToMoneyBox] forKey:@"moneyBox"];
            }
            [[Manager sharedInstance]  workWithHistoryOfSave:emptyBudgetToMoneyBox nameOfPeriod:[[Manager sharedInstance] stringForHistorySaveOfMonthDict]];
           
           NSDictionary *budgetOnCurrentDay = [userDefaults objectForKey:@"budgetOnCurrentDay"];
           
           double mutableBudgetOnDay = [[userDefaults objectForKey:@"stableBudgetOnDay"] doubleValue] + [[userDefaults objectForKey:@"mutableMonthDebit" ] doubleValue];
           
           budgetOnCurrentDay = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate new], @"dayWhenSpend", [NSNumber numberWithDouble:mutableBudgetOnDay], @"mutableBudgetOnDay", nil];
           [userDefaults setObject:budgetOnCurrentDay forKey:@"budgetOnCurrentDay"];
           
           [userDefaults setObject:nil forKey:@"historySpendOfMonth"];
           
           NSNumber *stableBudgetOnDay = [userDefaults objectForKey:@"stableBudgetOnDay"];
           [userDefaults setObject:stableBudgetOnDay forKey:@"budgetOnDay"];
           [userDefaults setDouble:[stableBudgetOnDay doubleValue] forKey:@"dailyBudgetTomorrowCounted"];
           
           double monthDebitWithBalanceMutableMonthDebit = [userDefaults doubleForKey:@"monthDebit"] + [userDefaults doubleForKey:@"mutableMonthDebit"];
           
           [userDefaults setDouble:monthDebitWithBalanceMutableMonthDebit forKey:@"mutableMonthDebit"];
           
        }
        
        else if ([userDefaults boolForKey:@"amountDailyBudgetSettingsMonth"]) {
            
            if ([userDefaults objectForKey:@"withPercent"]) {
                double moneyToMoneyBox = [[userDefaults objectForKey:@"monthPercent"] doubleValue] + [[userDefaults objectForKey:@"moneyBox"] doubleValue];
                [userDefaults setObject:[NSNumber numberWithDouble:moneyToMoneyBox] forKey:@"moneyBox"];
            }
            [[Manager sharedInstance] workWithHistoryOfSave:emptyBudgetToMoneyBox nameOfPeriod:[[Manager sharedInstance] stringForHistorySaveOfMonthDict]];

            NSDictionary *budgetOnCurrentDay = [userDefaults objectForKey:@"budgetOnCurrentDay"];
            double divided = [[userDefaults objectForKey:@"mutableMonthDebit"] doubleValue] / [[Manager sharedInstance] daysToStartNewMonth];
            double amountBudgetOnDay = [userDefaults doubleForKey:@"stableBudgetOnDay"] + divided;
            [userDefaults setObject:[NSNumber numberWithDouble:amountBudgetOnDay] forKey:@"budgetOnDay"];
            
            double recalculationBudgetOnDay = [[userDefaults objectForKey:@"budgetOnDay"] doubleValue];
            
            budgetOnCurrentDay = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate new], @"dayWhenSpend", [NSNumber numberWithDouble:recalculationBudgetOnDay], @"mutableBudgetOnDay",  nil];
            [userDefaults setObject:budgetOnCurrentDay forKey:@"budgetOnCurrentDay"];
            
            [userDefaults setObject:nil forKey:@"historySpendOfMonth"];
            [userDefaults setDouble:recalculationBudgetOnDay forKey:@"dailyBudgetTomorrowCounted"];
            double monthDebitWithBalanceMutableMonthDebit = [userDefaults doubleForKey:@"monthDebit"] + [userDefaults doubleForKey:@"mutableMonthDebit"];
            [userDefaults setDouble:monthDebitWithBalanceMutableMonthDebit forKey:@"mutableMonthDebit"];
            [userDefaults synchronize];
        }
        
        else if ([userDefaults boolForKey:@"moneyBoxSettingsMonth"]) {
            
            if ([userDefaults boolForKey:@"withPercent"]) {
                double moneyToMoneyBox = [[userDefaults objectForKey:@"mutableMonthDebit"] doubleValue] + [[userDefaults objectForKey:@"monthPercent"] doubleValue] + [[userDefaults objectForKey:@"moneyBox"] doubleValue];
                [userDefaults setObject:[NSNumber numberWithDouble:moneyToMoneyBox] forKey:@"moneyBox"];
            } else {
                double moneyToMoneyBox = [[userDefaults objectForKey:@"mutableMonthDebit"] doubleValue] + [[userDefaults objectForKey:@"moneyBox"] doubleValue];
                [userDefaults setObject:[NSNumber numberWithDouble:moneyToMoneyBox] forKey:@"moneyBox"];
            }
            
            NSNumber *mutableMonthDebit = [userDefaults objectForKey:@"mutableMonthDebit"];
            [[Manager sharedInstance] workWithHistoryOfSave:mutableMonthDebit nameOfPeriod:[[Manager sharedInstance] stringForHistorySaveOfMonthDict]];
            
            //массив для подсчета отложенного бюджета за год
            NSMutableArray *arrForHistorySaveOfMonthMoneyDebit = [[userDefaults objectForKey:@"historySaveOfMonthMoneyDebit"] mutableCopy];
            if (arrForHistorySaveOfMonthMoneyDebit == nil) {
                arrForHistorySaveOfMonthMoneyDebit = [NSMutableArray array];
            }
            [arrForHistorySaveOfMonthMoneyDebit addObject:mutableMonthDebit];
            [userDefaults setObject:arrForHistorySaveOfMonthMoneyDebit forKey:@"historySaveOfMonthMoneyDebit"];
            
            double monthDebit = [userDefaults doubleForKey:@"monthDebit"];
            [userDefaults setDouble:monthDebit forKey:@"mutableMonthDebit"];
            
            [[Manager sharedInstance] resetUserDefData:[userDefaults objectForKey:@"stableBudgetOnDay"]];
            
            NSNumber *stableBudgetOnDay = [userDefaults objectForKey:@"stableBudgetOnDay"];
            [userDefaults setDouble:[stableBudgetOnDay doubleValue] forKey:@"dailyBudgetTomorrowCounted"];
        }
        [self resetBoolOfNegativeBalanceInEndOfMonth];
    } else {
        [self recalculationEveryDay];
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
        double sumOfSaveMoneForYear = 0.0;
        for (NSNumber* budgetInArray in historySaveOfMonthMoneyDebit) {
            sumOfSaveMoneForYear = sumOfSaveMoneForYear + [budgetInArray doubleValue];
        }
        [[Manager sharedInstance] workWithHistoryOfSave:[NSNumber numberWithDouble:sumOfSaveMoneForYear] nameOfPeriod:[NSString stringWithFormat:@"%ld", yearOfCurrDateInt]];
        
        [userDefaults setObject:nil forKey:@"historySaveOfMonthMoneyDebit"];
        [userDefaults setInteger:yearOfCurrDate forKey:@"Year"];
    }
    
    [userDefaults synchronize];
}

- (void)negativeBalance {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    NSNumber *mutableBudgetWithSpendNumber = [dict objectForKey:@"mutableBudgetOnDay"];
    if ([mutableBudgetWithSpendNumber doubleValue] < 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        NegativeBalanceViewController *negativeBalanceViewControllerVC = [storyboard instantiateViewControllerWithIdentifier:@"NegativeBalanceViewController"];
        [self.navigationController pushViewController:negativeBalanceViewControllerVC animated:YES];
    }
}



//добавление xib в tableview header
- (void)xibInHeaderToTableView {
    
    self.headerView = (MainScreenHeaderView*)[[[NSBundle mainBundle] loadNibNamed:@"MainScreenHeaderXib" owner:self options:nil]objectAtIndex:0];
    self.tableView.tableHeaderView = self.headerView;
    
    //[self.tableView.tableHeaderView setFrame:CGRectMake(self.tableView.tableHeaderView.frame.origin.x, self.tableView.tableHeaderView.frame.origin.y, 13, 134)];

}

#pragma mark - Timer
- (void)startTimer{
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:8.0
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
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if ([self.headerView.processOfSpendingMoneyTextField.text length] <= 0 || [self.headerView.processOfSpendingMoneyTextField.text  isEqual: @"-0"]) {
        
        NSString *error = @"Введите сумму";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ошибка!" message:error preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else if (fabs([self.headerView.processOfSpendingMoneyTextField.text doubleValue]) > [[userDefault objectForKey:@"mutableMonthDebit"] doubleValue]) {
        NSString *error = @"Введенная вами сумма превышает ваш месячный баланс";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ошибка" message:error preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        [self cleanupProcessOfSpendingMoneyTextField];
        
    } else {
        
        double currentSpend = [self.headerView.processOfSpendingMoneyTextField.text doubleValue];
        NSNumber *currentSpendNumber = [NSNumber numberWithDouble:currentSpend];
        
        NSMutableArray *historySpendOfMonth = [NSMutableArray arrayWithArray:[userDefault objectForKey:@"historySpendOfMonth"]];
        if (historySpendOfMonth == nil) {
            historySpendOfMonth = [NSMutableArray array];
        }
        
        //работа с таблицей (история)
        NSMutableDictionary *dictWithDateAndSum = [NSMutableDictionary new];
        [dictWithDateAndSum setObject:currentSpendNumber forKey: @"currentSpendNumber"];
        [dictWithDateAndSum setObject:[NSDate date] forKey:@"currentDateOfSpend"];
        [historySpendOfMonth addObject:dictWithDateAndSum];
        [userDefault setObject:historySpendOfMonth forKey:@"historySpendOfMonth"];
        [userDefault synchronize];
        self.arrayForTable = historySpendOfMonth;
        self.reverseArrayForTable = [[[self.arrayForTable reverseObjectEnumerator] allObjects] mutableCopy];
        [self.tableView reloadData];
        
        //работа с бюджетом на день
        NSMutableDictionary *budgetOnCurrentDay = [[userDefault objectForKey:@"budgetOnCurrentDay"]mutableCopy];
        NSNumber *mutableBudgetOnDay = [budgetOnCurrentDay objectForKey:@"mutableBudgetOnDay"];
        double mutableBudgetOnDayWithSpend = [mutableBudgetOnDay doubleValue] - fabs(currentSpend);
        NSNumber *mutableBudgetOnDayWithSpendNumber = [NSNumber numberWithDouble:mutableBudgetOnDayWithSpend];
        [budgetOnCurrentDay setObject:mutableBudgetOnDayWithSpendNumber forKey:@"mutableBudgetOnDay"];
        [userDefault setObject:budgetOnCurrentDay  forKey:@"budgetOnCurrentDay"];
        [userDefault synchronize];
        
        double mutableMonthDebitWithSpend = [userDefault doubleForKey:@"mutableMonthDebit"] - fabs([self.headerView.processOfSpendingMoneyTextField.text doubleValue]);
        [userDefault setDouble:mutableMonthDebitWithSpend forKey:@"mutableMonthDebit"];
        
        [userDefault setDouble:fabs([self.headerView.processOfSpendingMoneyTextField.text doubleValue]) forKey:@"processOfSpendingMoneyTextField"];
        
        self.headerView.currentBudgetOnDayLabel.text = [[Manager sharedInstance] updateTextBalanceLabel];
        [self negativeBalance];
        [self cleanupProcessOfSpendingMoneyTextField];
    }
}

- (void)cleanupProcessOfSpendingMoneyTextField {
    //при нажатии на кнопку Add очищаем textfield и ставим lable в изначальные значения Альфы
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

- (void)updateSwitchViewDay {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"transferMoneyToNextDaySettingsDay"]) {
        [userDefaults setBool:YES forKey:@"transferMoneyToNextDaySettingsDay"];
        [userDefaults setBool:NO forKey:@"amountOnDailyBudgetSettingsDay"];
    } else if ([userDefaults boolForKey:@"amountOnDailyBudgetSettingsDay"]) {
        [userDefaults setBool:YES forKey:@"amountOnDailyBudgetSettingsDay"];
        [userDefaults setBool:NO forKey:@"transferMoneyToNextDaySettingsDay"];
    }
    [userDefaults synchronize];
}

- (void)updateSwitchViewMonth {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"transferMoneyNextDaySettingsMonth"]) {
        [userDefaults setBool:YES forKey:@"transferMoneyNextDaySettingsMonth"];
        [userDefaults setBool:NO forKey:@"amountDailyBudgetSettingsMonth"];
        [userDefaults setBool:NO forKey:@"moneyBoxSettingsMonth"];
    } else if ([userDefaults boolForKey:@"amountDailyBudgetSettingsMonth"]) {
        [userDefaults setBool:YES forKey:@"amountDailyBudgetSettingsMonth"];
        [userDefaults setBool:NO forKey:@"transferMoneyNextDaySettingsMonth"];
        [userDefaults setBool:NO forKey:@"moneyBoxSettingsMonth"];
    } else if ([userDefaults boolForKey:@"moneyBoxSettingsMonth"]) {
        [userDefaults setBool:YES forKey:@"moneyBoxSettingsMonth"];
        [userDefaults setBool:NO forKey:@"transferMoneyNextDaySettingsMonth"];
        [userDefaults setBool:NO forKey:@"amountDailyBudgetSettingsMonth"];
    }
    [userDefaults synchronize];
}


@end
