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



@interface MainScreenTableViewController () <UITextFieldDelegate>
@property (strong, nonatomic) MainScreenHeaderView *headerView;
@property (strong, nonatomic) NSArray *arrayForTable;
@end

@implementation MainScreenTableViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;//прячем кнопку назад на navBar
    [self recalculationEveryMonth];
    [self xibInHeaderToTableView];

    self.headerView.processOfSpendingMoneyTextField.delegate = self;
    [self.headerView.processOfSpendingMoneyTextField becomeFirstResponder];
    [[Manager sharedInstance] customBtnOnKeyboardFor:self.headerView.processOfSpendingMoneyTextField nameOfAction:@selector(addBtnFromKeyboardClicked:)];
    [self.headerView.iSpendTextLabel setAlpha:0];
    self.headerView.processOfSpendingMoneyTextField.tintColor = [UIColor clearColor];//убираем мигающий курсор
    [self.headerView.processOfSpendingMoneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.arrayForTable = [userDefault objectForKey:@"historySpendOfMonth"];
    
    self.headerView.currentBudgetOnDayLabel.text = [NSString stringWithFormat:@"%.2f", [userDefault doubleForKey:@"budgetOnDay"]];
    ////-------////
    NSDictionary *dict = [userDefault objectForKey:@"budgetOnCurrentDay"];
    NSNumber *mutableBudgetOnDayWithSpendNumberFromDict = [dict objectForKey:@"mutableBudgetOnDay"];
    self.headerView.currentBudgetOnDayLabel.text = [NSString stringWithFormat:@"%@", mutableBudgetOnDayWithSpendNumberFromDict];
}


- (BOOL)recalculationEveryDay {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *budgetOnCurrentDay = [userDefault objectForKey:@"budgetOnCurrentDay"];
    
    NSDate *dateFromDict = [budgetOnCurrentDay objectForKey:@"dayWhenSpend"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay fromDate:dateFromDict toDate:[NSDate date] options:0];
    
    if (difference.day != 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        DayEndViewController *DayEndViewControllerVC = [storyboard instantiateViewControllerWithIdentifier:@"DayEndViewController"];
        [self.navigationController presentViewController:DayEndViewControllerVC animated:NO completion:nil];
        
        
        double budgetOnDay = [userDefault doubleForKey:@"budgetOnDay"];
        budgetOnCurrentDay = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"dayWhenSpend", [NSNumber numberWithDouble:budgetOnDay], @"mutableBudgetOnDay", nil];
        return false;
    }
    return true;
}

- (void)recalculationEveryMonth {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *resetDateEveryMonth = [userDefaults objectForKey:@"resetDateEveryMonth"];
    if ([[NSDate date] compare:resetDateEveryMonth] == NSOrderedDescending) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        MonthEndViewController *monthEndViewControllerVC = [storyboard instantiateViewControllerWithIdentifier:@"MonthEndViewController"];
        [self.navigationController pushViewController:monthEndViewControllerVC animated:NO];
        
        [[Manager sharedInstance] resetData];
    } else {
        [self recalculationEveryDay];
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
    if (scrollView.contentOffset.y < -80) {
        [self.headerView.processOfSpendingMoneyTextField becomeFirstResponder];
    }
    else if (scrollView.contentOffset.y > -60) {
        [self.headerView.processOfSpendingMoneyTextField resignFirstResponder];
    }
}

#pragma mark - Work with TextFieldKeyboard and Custom Button "Add" -

//вызов функции при нажатии на созданую кнопку Add
- (IBAction)addBtnFromKeyboardClicked:(id)sender {
    [self checkTextField];
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
        
        //работа с таблицtй (история)
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
        
        NSDictionary *dict = [userDefault objectForKey:@"budgetOnCurrentDay"];
        NSNumber *mutableBudgetOnDayWithSpendNumberFromDict = [dict objectForKey:@"mutableBudgetOnDay"];
        self.headerView.currentBudgetOnDayLabel.text = [NSString stringWithFormat:@"%@", mutableBudgetOnDayWithSpendNumberFromDict];
        
        //при нажатии на кнопку Add очищаем textfield и ставим lable в изначальные значения Альфы
        self.headerView.processOfSpendingMoneyTextField.text = @"";
        if ([self.headerView.processOfSpendingMoneyTextField.text  isEqual: @""]) {
            [self.headerView.iSpendTextLabel setAlpha:0];
            [self.headerView.startEnterLabel setAlpha:1];
        }
    }
}



#pragma mark - UITextFieldDelegate -

#define ACCEPTABLE_CHARECTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя_-+=!№;%:?@#$^&*() "

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *acceptedInput = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS];
    if ([[string componentsSeparatedByCharactersInSet:acceptedInput] count] > 1){
        return NO;
    }
    else{
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }
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
