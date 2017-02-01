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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.monthDebitTextField becomeFirstResponder];
    [[Manager sharedInstance] customBtnOnKeyboardFor:self.monthDebitTextField nameOfAction:@selector(addBtnFromKeyboardClicked:)];
}


#pragma mark - Custom Button Add -

//вызов функции при нажатии на созданую кнопку Add
- (IBAction)addBtnFromKeyboardClicked:(id)sender {
    [self checkTextField];
}



#pragma mark - Work with UITextField -


- (void)checkTextField {
    
    if ([self.monthDebitTextField.text length] <= 0 || [self.monthDebitTextField.text isEqual: @"0"]) {
        
        NSString *error = @"Введите корректную сумму";
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
        
        
        if (![[Manager sharedInstance] getMonthDebit]) {
            [[Manager sharedInstance] setMonthDebit:monthDebit];
            [[Manager sharedInstance] setMutableMonthDebit:monthDebit];
            [[Manager sharedInstance] setMonthPercent:monthDebitWithEightPercent];

            [[Manager sharedInstance] setResetDateEveryMonth:[NSDate date]];
            [[Manager sharedInstance] resetDate];
        } else {
            [[Manager sharedInstance] setNewMonthDebit:monthDebit];
            [[Manager sharedInstance] setNewMonthPercent:monthDebitWithEightPercent];
        }

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        CalculationViewController *calculationVC = [storyboard instantiateViewControllerWithIdentifier:@"CalculationViewController"];
        calculationVC.budgetOnDay = [NSString stringWithFormat:@"%.2f", budgetOnDay];
        calculationVC.budgetOnDayWithSaving = [NSString stringWithFormat:@"%.2f", budgetOnDayWithEconomy];
        calculationVC.moneySavingYear = [NSString stringWithFormat:@"%.2f", moneySavingInYear];
        [self.navigationController pushViewController:calculationVC animated:YES];
        
    }
}


#pragma mark - UITextFieldDelegate -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя_-+=!№;%:?@#$^&*() ";
    NSCharacterSet *acceptedInput = [NSCharacterSet characterSetWithCharactersInString:str];
    if ([[string componentsSeparatedByCharactersInSet:acceptedInput] count] > 1){
        return NO;
    }
    else{
        return YES;
    }
}


@end
