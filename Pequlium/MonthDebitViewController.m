//
//  MonthlyIncomeViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 14.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "MonthDebitViewController.h"
#import "CalculationViewController.h"
#import "Manager.h"

@interface MonthDebitViewController ()
@property (weak, nonatomic) IBOutlet UITextField *monthDebitTextField;
@end

@implementation MonthDebitViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.monthDebitTextField becomeFirstResponder];
    [[Manager sharedInstance] customBtnOnKeyboardFor:self.monthDebitTextField nameOfAction:@selector(addBtnFromKeyboardClicked:)];
    [[Manager sharedInstance] resetData];
}

#pragma mark - Custom Button Add -

//вызов функции при нажатии на созданую кнопку Add
- (IBAction)addBtnFromKeyboardClicked:(id)sender {
    [self checkTextField];
    
}

#pragma mark - Work with UITextField -
//проверка пустое полу или нет (если нет - сохраняем инфу в базу)
- (void)checkTextField {
    
    if ([self.monthDebitTextField.text length] <= 0 || [self.monthDebitTextField.text  isEqual: @"0"]) {
        
        NSString *error = @"Введите сумму";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ошибка!" message:error preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        double monthDebit = [self.monthDebitTextField.text doubleValue];
        double budgetOnDay = monthDebit / [[Manager sharedInstance] daysInCurrentMonth];
        double monthDebitWithEightPercent = (monthDebit / 100) * 8;
        double budgetOnDayWithEconomy = (monthDebit - monthDebitWithEightPercent) / [[Manager sharedInstance] daysInCurrentMonth];
        double moneySavingInYear = monthDebitWithEightPercent * 12;
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setDouble:monthDebit forKey:@"monthDebit"];
        
        NSDate *currDate = [NSDate date];
        [userDefault setObject:currDate forKey:@"dateWhenCreateMonthDebit"];
        
        [userDefault setDouble:[self.monthDebitTextField.text doubleValue] forKey:@"muttableMonthDebit"];
        
        
        NSDate *resetDate = [NSDate date];
        [userDefault setObject:resetDate forKey:@"resetDateEveryMonth"];
        
        [userDefault synchronize];
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        CalculationViewController *calculationVC = [storyboard instantiateViewControllerWithIdentifier:@"CalculationViewController"];
        calculationVC.budgetOnDay = [NSString stringWithFormat:@"%.2f", budgetOnDay];
        calculationVC.budgetOnDayWithSaving = [NSString stringWithFormat:@"%.2f", budgetOnDayWithEconomy];
        calculationVC.moneySavingYear = [NSString stringWithFormat:@"%.2f", moneySavingInYear];
        [self.navigationController pushViewController:calculationVC animated:YES];
        
    }
}
#pragma mark - UITextFieldDelegate -

#define ACCEPTABLE_CHARECTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя_-+=!№;%:?@#$^&*() "

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *acceptedInput = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS];
    if ([[string componentsSeparatedByCharactersInSet:acceptedInput] count] > 1){
        return NO;
    }
    else{
        return YES;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
