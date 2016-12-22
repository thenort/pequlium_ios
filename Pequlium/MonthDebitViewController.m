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
    [self customBtnOnKeyboard];
    [self customNavigationController];
    
}
#pragma mark - Custom Button Add -

//вызов функции при нажатии на созданую кнопку Add
- (IBAction)addBtnFromKeyboardClicked:(id)sender {
    [self checkTextField];
}

//создание кнопки над клавиатурой
- (void)customBtnOnKeyboard {
    
    UIToolbar *ViewForDoneButtonOnKeyboard = [[UIToolbar alloc] init];
    [ViewForDoneButtonOnKeyboard sizeToFit];
    UIBarButtonItem *btnAddOnKeyboard = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                 style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(addBtnFromKeyboardClicked:)];
    [ViewForDoneButtonOnKeyboard setItems:@[btnAddOnKeyboard]];
    self.monthDebitTextField.inputAccessoryView = ViewForDoneButtonOnKeyboard;
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
        
        [[Manager sharedInstance] saveInDataFromTextField:self.monthDebitTextField.text withKey:@"monthDebit"];
        [[Manager sharedInstance]calculationBudget];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        CalculationViewController *calculationVC = [storyboard instantiateViewControllerWithIdentifier:@"CalculationViewController"];
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
#pragma mark - Custom NavigationController -

- (void)customNavigationController {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
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
