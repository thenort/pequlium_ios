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

- (IBAction)addBtnFromKeyboardClicked:(id)sender {
    
    [self checkTextField];
    
}

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

- (void)checkTextField {
    
    if ([self.monthDebitTextField.text length] <= 0) {
        
        NSString *error = @"Введите сумму";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ошибка!" message:error preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [[Manager sharedInstance] saveInData:self.monthDebitTextField.text withKey:@"monthDebit"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        CalculationViewController *calculationVC = [storyboard instantiateViewControllerWithIdentifier:@"CalculationViewController"];
        [self.navigationController pushViewController:calculationVC animated:YES];
        
    }
    
}

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
