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
@end

@implementation MainScreenTableViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self recalculationEveryMonth];
    [self xibInHeaderToTableView];
    [self customise];
    [[Manager sharedInstance] customBtnOnKeyboardFor:self.headerView.processOfSpendingMoneyTextField nameOfAction:@selector(addBtnFromKeyboardClicked:)];
    [self.headerView.processOfSpendingMoneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.arrayForTable = [[userDefaults objectForKey:@"historySpendOfMonth"]mutableCopy];
    self.headerView.currentBudgetOnDayLabel.text = [[Manager sharedInstance] updateTextBalanceLabel];
    [self updateSwitchViewDay];
    [self updateSwitchViewMonth];
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
                budgetOnCurrentDay = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"dayWhenSpend", [NSNumber numberWithDouble:mutableBudgetOnDay], @"mutableBudgetOnDay", nil];
                [userDefault setObject:budgetOnCurrentDay forKey:@"budgetOnCurrentDay"];
            } else if ([userDefault boolForKey:@"amountOnDailyBudgetSettingsDay"]) {
                NSDictionary *budgetOnCurrentDay = [userDefault objectForKey:@"budgetOnCurrentDay"];
                double divided = [mutableBudgetWithSpendNumber doubleValue] / [[Manager sharedInstance] daysInCurrentMonth];
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
                budgetOnCurrentDay = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"dayWhenSpend", [NSNumber numberWithDouble:budgetOnDay], @"mutableBudgetOnDay", nil];
                [userDefault setObject:budgetOnCurrentDay forKey:@"budgetOnCurrentDay"];
                
                double budgetOnDayInDailyBudgetTomorrowCounted = [userDefault doubleForKey:@"budgetOnDay"];
                [userDefault setDouble:budgetOnDayInDailyBudgetTomorrowCounted forKey:@"dailyBudgetTomorrowCounted"];

                [userDefault setBool:NO forKey:@"dailyBudgetTomorrowCountedBool"];
                [userDefault setBool:NO forKey:@"dailyBudgetTomorrowBool"];
                
            } else {
                NSDictionary *budgetOnCurrentDay = [userDefault objectForKey:@"budgetOnCurrentDay"];
                double budgetOnDay = [userDefault doubleForKey:@"budgetOnDay"];
                budgetOnCurrentDay = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"dayWhenSpend", [NSNumber numberWithDouble:budgetOnDay], @"mutableBudgetOnDay", nil];
                [userDefault setObject:budgetOnCurrentDay forKey:@"budgetOnCurrentDay"];
                [userDefault setBool:NO forKey:@"dailyBudgetTomorrowBool"];
            }
        }
        [userDefault synchronize];
    }
}

- (void)recalculationEveryMonth {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *resetDateEveryMonth = [userDefaults objectForKey:@"resetDateEveryMonth"];
    
    if ([[NSDate date] compare:resetDateEveryMonth] == NSOrderedDescending) {
        BOOL callOneTimeMonth = [userDefaults boolForKey:@"callOneTimeMonth"];
        if (!callOneTimeMonth) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
            MonthEndViewController *monthEndViewControllerVC = [storyboard instantiateViewControllerWithIdentifier:@"MonthEndViewController"];
            [self.navigationController pushViewController:monthEndViewControllerVC animated:NO];
        }
        /*
        //прошлый месяц
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [NSDateComponents new];
        comps.month = -1;
        NSDate *date = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
        NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:date];
        
        NSInteger monthNumber = [components month];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
        NSString *monthName = [[df standaloneMonthSymbols] objectAtIndex:(monthNumber - 1)];
        NSString *monthNameBig = [NSString stringWithFormat:@"%@%@",[[monthName substringToIndex:1] uppercaseString],[monthName substringFromIndex:1]];
        */
        
        /*
        //работа с таблицей (история)
        NSMutableArray *historySaveOfMonth = [NSMutableArray arrayWithArray:[userDefaults objectForKey:@"historySaveOfMonth"]];
        if (historySaveOfMonth == nil) {
            historySaveOfMonth = [NSMutableArray array];
        }
        NSMutableDictionary *dictWithDateAndSum = [NSMutableDictionary new];
        if ([userDefaults boolForKey:@"withPercent"]) {
            double mutableMonthDebit = [[userDefaults objectForKey:@"mutableMonthDebit"] doubleValue] + [[userDefaults objectForKey:@"monthPercent"] doubleValue];
            [dictWithDateAndSum setObject:[NSNumber numberWithDouble:mutableMonthDebit] forKey: @"currentMutableMonthDebit"];
        } else {
            NSNumber *mutableMonthDebit = [userDefaults objectForKey:@"mutableMonthDebit"];
            [dictWithDateAndSum setObject:mutableMonthDebit forKey: @"currentMutableMonthDebit"];
        }
        [dictWithDateAndSum setObject:monthNameBig forKey:@"currentMonthOfSave"];
        [historySaveOfMonth addObject:dictWithDateAndSum];
        [userDefaults setObject:historySaveOfMonth forKey:@"historySaveOfMonth"];
        [userDefaults synchronize];
        */
        
        [[Manager sharedInstance] resetData];

        
    } else {
        [self recalculationEveryDay];
    }
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
}

#pragma mark - UIScrollViewDelegat -

//когда клавиатура выезжает
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < - 57 ) {
        [self.headerView.processOfSpendingMoneyTextField becomeFirstResponder];
    }
    else if (scrollView.contentOffset.y > - 57 ) {
        [self.headerView.processOfSpendingMoneyTextField resignFirstResponder];
    }
}

#pragma mark - Work with TextFieldKeyboard and Custom Button "Add" -

//вызов функции при нажатии на созданую кнопку Add
- (IBAction)addBtnFromKeyboardClicked:(id)sender {
    [self checkTextField];
    [self negativeBalance];
}

- (void)checkTextField {
    
    if ([self.headerView.processOfSpendingMoneyTextField.text length] <= 0 || [self.headerView.processOfSpendingMoneyTextField.text  isEqual: @"-0"]) {
        
        NSString *error = @"Введите сумму";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ошибка!" message:error preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        double currentSpend = [self.headerView.processOfSpendingMoneyTextField.text doubleValue];
        NSNumber *currentSpendNumber = [NSNumber numberWithDouble:currentSpend];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
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
        //при нажатии на кнопку Add очищаем textfield и ставим lable в изначальные значения Альфы
        self.headerView.processOfSpendingMoneyTextField.text = @"";
        if ([self.headerView.processOfSpendingMoneyTextField.text  isEqual: @""]) {
            [self.headerView.iSpendTextLabel setAlpha:0];
            [self.headerView.startEnterLabel setAlpha:1];
        }
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
    cell.howLongAgoSpandMoneyLabel.text = [[Manager sharedInstance] formatDate:date];
    
    NSNumber *spend = [tempDataOfSpend objectForKey:@"currentSpendNumber"];
    cell.howMuchMoneySpendLabel.text = [NSString stringWithFormat:@"%.2f", [spend doubleValue]];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.arrayForTable removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
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
