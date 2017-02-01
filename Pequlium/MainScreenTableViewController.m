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
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self xibInHeaderToTableView];
    [self customise];
    [[Manager sharedInstance] customBtnOnKeyboardFor:self.headerView.processOfSpendingMoneyTextField nameOfAction:@selector(addBtnFromKeyboardClicked:)];
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
    self.headerView.currentBudgetOnDayLabel.text = [NSString stringWithFormat:@"%.2f", [[Manager sharedInstance] getBudgetOnCurrentDayMoneyDouble]];
}

- (void)resetBoolOfNegativeBalanceEveryDay {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //обнуление bool для negativebalance
    [userDefault setBool:NO forKey:@"callOneTime"];
    //обнуление bool для negativebalance dailyBudgetWillBeLabel
    [userDefault setBool:NO forKey:@"callOneTimeToLable"];
    [userDefault setBool:NO forKey:@"dailyBudgetTomorrowBoolLabel"];
    [userDefault synchronize];
}

- (void)recalculationEveryDay {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

    if ([[Manager sharedInstance] differenceDay] != 0) {
        
        NSDictionary *dict = [userDefault objectForKey:@"budgetOnCurrentDay"];
        NSNumber *mutableBudgetWithSpendNumber = [dict objectForKey:@"mutableBudgetOnDay"];
        
        [self resetBoolOfNegativeBalanceEveryDay];
        
        if ([mutableBudgetWithSpendNumber doubleValue] > 0 && [userDefault boolForKey:@"callOneTimeDay"]) {
            if ([userDefault boolForKey:@"transferMoneyToNextDaySettingsDay"]) {
                NSDictionary *budgetOnCurrentDay = [userDefault objectForKey:@"budgetOnCurrentDay"];
                double mutableBudgetOnDay = [userDefault doubleForKey:@"budgetOnDay"] + [mutableBudgetWithSpendNumber doubleValue];
                budgetOnCurrentDay = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate new], @"dayWhenSpend", [NSNumber numberWithDouble:mutableBudgetOnDay], @"mutableBudgetOnDay", nil];
                [userDefault setObject:budgetOnCurrentDay forKey:@"budgetOnCurrentDay"];
            } else if ([userDefault boolForKey:@"amountOnDailyBudgetSettingsDay"] && [userDefault boolForKey:@"callOneTimeDay"]) {
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

- (void)resetBoolOfNegativeBalanceEndMonth {
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
        [[Manager sharedInstance] resetDate];
        
        if ([[Manager sharedInstance] getChangeAllStableDebitBool]) {
            [[Manager sharedInstance] setAllStableDebit];
        }
        
        if  ([userDefaults boolForKey:@"transferMoneyNextDaySettingsMonth"] && [userDefaults boolForKey:@"callOneTimeMonth"]) {
            
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
        
        else if ([userDefaults boolForKey:@"amountDailyBudgetSettingsMonth"]  && [userDefaults boolForKey:@"callOneTimeMonth"]) {
            
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
        
        else if ([userDefaults boolForKey:@"moneyBoxSettingsMonth"]  && [userDefaults boolForKey:@"callOneTimeMonth"]) {
            
            if ([userDefaults boolForKey:@"withPercent"]) {
                double moneyToMoneyBox = [[userDefaults objectForKey:@"mutableMonthDebit"] doubleValue] + [[userDefaults objectForKey:@"monthPercent"] doubleValue] + [[userDefaults objectForKey:@"moneyBox"] doubleValue];
                [userDefaults setObject:[NSNumber numberWithDouble:moneyToMoneyBox] forKey:@"moneyBox"];
            } else {
                double moneyToMoneyBox = [[userDefaults objectForKey:@"mutableMonthDebit"] doubleValue] + [[userDefaults objectForKey:@"moneyBox"] doubleValue];
                [userDefaults setObject:[NSNumber numberWithDouble:moneyToMoneyBox] forKey:@"moneyBox"];
            }
            
            NSNumber *mutableMonthDebit = [[Manager sharedInstance] getMutableMonthDebitNumber];
            [[Manager sharedInstance] workWithHistoryOfSave:mutableMonthDebit nameOfPeriod:[[Manager sharedInstance] stringForHistorySaveOfMonthDict]];
            
            //массив для подсчета отложенного бюджета за год
            NSMutableArray *arrForHistorySaveOfMonthMoneyDebit = [[userDefaults objectForKey:@"historySaveOfMonthMoneyDebit"] mutableCopy];
            if (arrForHistorySaveOfMonthMoneyDebit == nil) {
                arrForHistorySaveOfMonthMoneyDebit = [NSMutableArray array];
            }
            [arrForHistorySaveOfMonthMoneyDebit addObject:mutableMonthDebit];
            [userDefaults setObject:arrForHistorySaveOfMonthMoneyDebit forKey:@"historySaveOfMonthMoneyDebit"];
            
            [[Manager sharedInstance] setMutableMonthDebit:[[Manager sharedInstance] getMonthDebit]];
            [[Manager sharedInstance] resetUserDefData:[NSNumber numberWithDouble:[[Manager sharedInstance] getStableBudgetOnDay]]];
            
            [userDefaults setDouble:[[Manager sharedInstance] getStableBudgetOnDay] forKey:@"dailyBudgetTomorrowCounted"];
            [userDefaults synchronize];
        }
        [self resetBoolOfNegativeBalanceEndMonth];
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
        [[Manager sharedInstance] workWithHistoryOfSave:[NSNumber numberWithDouble:sumOfSaveMoneyForYear] nameOfPeriod:[NSString stringWithFormat:@"%ld", yearOfCurrDateInt]];
        
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

//добавление xib в tableview header
- (void)xibInHeaderToTableView {
    self.headerView = (MainScreenHeaderView*)[[[NSBundle mainBundle] loadNibNamed:@"MainScreenHeaderXib" owner:self options:nil]objectAtIndex:0];
    self.tableView.tableHeaderView = self.headerView;
    [self autoresizeXib];
}


#pragma mark - Timer

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
        
    } else if (fabs([self.headerView.processOfSpendingMoneyTextField.text doubleValue]) > [[userDefaults objectForKey:@"mutableMonthDebit"] doubleValue]) {
        
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
        [budgetOnCurrentDay setObject: [NSNumber numberWithDouble:[[Manager sharedInstance] getBudgetOnCurrentDayMoneyDouble] - fabs([currentSpendNumber doubleValue])] forKey:@"mutableBudgetOnDay"];
        [userDefaults setObject:budgetOnCurrentDay  forKey:@"budgetOnCurrentDay"];
        //work with mutableMonthdebit
        [[Manager sharedInstance] setMutableMonthDebit:[[Manager sharedInstance] getMutableMonthDebit] - fabs([currentSpendNumber doubleValue])];
        
        [userDefaults setDouble:fabs([currentSpendNumber doubleValue]) forKey:@"processOfSpendingMoneyTextField"];
        [userDefaults synchronize];
        
        self.headerView.currentBudgetOnDayLabel.text = [[Manager sharedInstance] updateTextBalanceLabel];
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
