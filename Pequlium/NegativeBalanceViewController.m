//
//  NegativeBalanceViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 14.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "NegativeBalanceViewController.h"
#import "MainScreenTableViewController.h"
#import "Manager.h"

@interface NegativeBalanceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *negativeBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyBudgetWillBeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyBudgetWillBeTomorrowLabel;
@end

@implementation NegativeBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.negativeBalanceLabel.text = [[Manager sharedInstance] updateTextBalanceLabel];
    [self infoToDailyBudgetWillBeLabel];
    [self infoToDailyBudgetWillBeTomorrowLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)infoToDailyBudgetWillBeLabel {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *budgetOnCurrentDay = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    BOOL callOneTimeBool = [userDefaults boolForKey:@"callOneTimeToLable"];
    if (!callOneTimeBool) {
        double divided = [[budgetOnCurrentDay objectForKey:@"mutableBudgetOnDay"] doubleValue] / [[Manager sharedInstance] daysToStartNewMonth] ;
        double recalculationBudgetOnDay = [userDefaults doubleForKey:@"budgetOnDay"] - fabs(divided);
        self.dailyBudgetWillBeLabel.text = [NSString stringWithFormat:@"%.2f", recalculationBudgetOnDay];
        
        BOOL callOneTime = YES;
        [userDefaults setBool:callOneTime forKey:@"callOneTimeToLable"];
    } else {
        double divided = [userDefaults doubleForKey:@"processOfSpendingMoneyTextField"] / [[Manager sharedInstance] daysToStartNewMonth];
        double recalculationBudgetOnDay = [userDefaults doubleForKey:@"budgetOnDay"] - fabs(divided);
        self.dailyBudgetWillBeLabel.text = [NSString stringWithFormat:@"%.2f", recalculationBudgetOnDay];
    }
}

- (IBAction)dailyBudgetCounted:(id)sender {
    if ([self.dailyBudgetWillBeLabel.text doubleValue] > 0) {
        
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        BOOL dailyBudgetTomorrowBool = YES;
        [userDefaults setBool:dailyBudgetTomorrowBool forKey:@"dailyBudgetTomorrowBool"];
        
        NSDictionary *budgetOnCurrentDay = [userDefaults objectForKey:@"budgetOnCurrentDay"];
        BOOL callOneTimeBool = [userDefaults boolForKey:@"callOneTime"];
        if (!callOneTimeBool) {
            double divided = [[budgetOnCurrentDay objectForKey:@"mutableBudgetOnDay"] doubleValue] / [[Manager sharedInstance] daysToStartNewMonth] ;
            double recalculationBudgetOnDay = [userDefaults doubleForKey:@"budgetOnDay"] - fabs(divided);
            [userDefaults setDouble:recalculationBudgetOnDay forKey:@"budgetOnDay"];
            
            if ([userDefaults doubleForKey:@"dailyBudgetTomorrowCounted"]) {
                double recDailyBudgetTomorrowCounted = [userDefaults doubleForKey:@"dailyBudgetTomorrowCounted"] - fabs(divided);
                [userDefaults setObject:[NSNumber numberWithDouble:recDailyBudgetTomorrowCounted] forKey:@"dailyBudgetTomorrowCounted"];
            }
            
            BOOL callOneTime = YES;
            [userDefaults setBool:callOneTime forKey:@"callOneTime"];
        } else {
            double divided = [userDefaults doubleForKey:@"processOfSpendingMoneyTextField"] / [[Manager sharedInstance] daysToStartNewMonth];
            double recalculationBudgetOnDay = [userDefaults doubleForKey:@"budgetOnDay"] - fabs(divided);
            
            if ([userDefaults doubleForKey:@"dailyBudgetTomorrowCounted"]) {
                double recDailyBudgetTomorrowCounted = [userDefaults doubleForKey:@"dailyBudgetTomorrowCounted"] - fabs(divided);
                [userDefaults setObject:[NSNumber numberWithDouble:recDailyBudgetTomorrowCounted] forKey:@"dailyBudgetTomorrowCounted"];
            }
            
            [userDefaults setDouble:recalculationBudgetOnDay forKey:@"budgetOnDay"];
        }
        [userDefaults synchronize];
        [self popVC];
    } else {
        NSString *error = @"Введенная вами сумма превышает ваш дневной бюджет. Нажмите: Потратить меньше завтра. Или введите меньшую сумму.";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ошибка!" message:error preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];

    }
}

- (void)infoToDailyBudgetWillBeTomorrowLabel {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *budgetOnCurrentDay = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    BOOL dailyBudgetTomorrowBoolLabel = [userDefaults boolForKey:@"dailyBudgetTomorrowBoolLabel"];
    if (!dailyBudgetTomorrowBoolLabel) {
        
        double recalculationBudgetOnTomorrow = [[userDefaults objectForKey:@"budgetOnDay"] doubleValue] - fabs([[budgetOnCurrentDay objectForKey:@"mutableBudgetOnDay"] doubleValue]) ;

        if (recalculationBudgetOnTomorrow <= 0) {
            self.dailyBudgetWillBeTomorrowLabel.text = @"0";
        } else {
            self.dailyBudgetWillBeTomorrowLabel.text = [NSString stringWithFormat:@"%.2f", recalculationBudgetOnTomorrow];
        }

        BOOL callOneTimeTomorrowBool = YES;
        [userDefaults setBool:callOneTimeTomorrowBool forKey:@"dailyBudgetTomorrowBoolLabel"];
    } else {
        if (![userDefaults doubleForKey:@"dailyBudgetTomorrowCounted"]) {
            double recalculationBudgetOnTomorrow = [[userDefaults objectForKey:@"budgetOnDay"]  doubleValue] - fabs([userDefaults doubleForKey:@"processOfSpendingMoneyTextField"]);
            if (recalculationBudgetOnTomorrow <= 0) {
                self.dailyBudgetWillBeTomorrowLabel.text = @"0";
            } else {
                self.dailyBudgetWillBeTomorrowLabel.text = [NSString stringWithFormat:@"%.2f", recalculationBudgetOnTomorrow];
            }
        } else {
            double recalculationBudgetOnTomorrow = [userDefaults doubleForKey:@"dailyBudgetTomorrowCounted"] - fabs([userDefaults doubleForKey:@"processOfSpendingMoneyTextField"]);
            if (recalculationBudgetOnTomorrow <= 0) {
                self.dailyBudgetWillBeTomorrowLabel.text = @"0";
            } else {
                self.dailyBudgetWillBeTomorrowLabel.text = [NSString stringWithFormat:@"%.2f", recalculationBudgetOnTomorrow];
            }
        }
    }
}


- (IBAction)dailyBudgetTomorrowCounted:(id)sender {
    if ([self.dailyBudgetWillBeTomorrowLabel.text doubleValue] > 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL callOneTime = YES;
        [userDefaults setBool:callOneTime forKey:@"callOneTime"];
        
        //если да то бюджет на завтра будет...
        BOOL dailyBudgetTomorrowCountedBool = YES;
        [userDefaults setBool:dailyBudgetTomorrowCountedBool forKey:@"dailyBudgetTomorrowCountedBool"];
        
        NSDictionary *budgetOnCurrentDay = [userDefaults objectForKey:@"budgetOnCurrentDay"];
        BOOL dailyBudgetTomorrowBool = [userDefaults boolForKey:@"dailyBudgetTomorrowBool"];
        if (!dailyBudgetTomorrowBool) {
            
            double recalculationBudgetOnTomorrow = [[userDefaults objectForKey:@"budgetOnDay"] doubleValue] - fabs([[budgetOnCurrentDay objectForKey:@"mutableBudgetOnDay"] doubleValue]) ;
            
            [userDefaults setDouble:recalculationBudgetOnTomorrow forKey:@"dailyBudgetTomorrowCounted"];
            BOOL callOneTimeTomorrowBool = YES;
            [userDefaults setBool:callOneTimeTomorrowBool forKey:@"dailyBudgetTomorrowBool"];
        } else {
            if (![userDefaults doubleForKey:@"dailyBudgetTomorrowCounted"]) {
                double recalculationBudgetOnTomorrow = [[userDefaults objectForKey:@"budgetOnDay"]  doubleValue] - fabs([userDefaults doubleForKey:@"processOfSpendingMoneyTextField"]);
                [userDefaults setDouble:recalculationBudgetOnTomorrow forKey:@"dailyBudgetTomorrowCounted"];
            } else {
                double recalculationBudgetOnTomorrow = [userDefaults doubleForKey:@"dailyBudgetTomorrowCounted"] - fabs([userDefaults doubleForKey:@"processOfSpendingMoneyTextField"]);
                [userDefaults setDouble:recalculationBudgetOnTomorrow forKey:@"dailyBudgetTomorrowCounted"];
            }
        }
        [userDefaults synchronize];
        [self popVC];
    } else {
        NSString *error = @"Введенная вами сумма превышает ваш бюджет на завтра. Нажмите: Пересчитать дневной бюджет. Или введите меньшую сумму.";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ошибка!" message:error preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}

- (IBAction)mistakeEnterDifferentAmount:(id)sender {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSMutableArray *historySpendOfMonth = [[userDefaults objectForKey:@"historySpendOfMonth"]mutableCopy];
    NSDictionary *lastDictInHistorySpendOfMonth = [historySpendOfMonth lastObject];
    double currentSpend = fabs([[lastDictInHistorySpendOfMonth objectForKey:@"currentSpendNumber"] doubleValue]);
    
    double mutableMonthDebitWithReturn = [userDefaults doubleForKey:@"mutableMonthDebit"] + currentSpend;
    [userDefaults setDouble:mutableMonthDebitWithReturn forKey:@"mutableMonthDebit"];
    
    NSMutableDictionary *budgetOnCurrentDay = [[userDefaults objectForKey:@"budgetOnCurrentDay"]mutableCopy];
    double mutableDayDebitWithReturn = [[budgetOnCurrentDay objectForKey:@"mutableBudgetOnDay"] doubleValue] + currentSpend;
    NSNumber *mutableDayDebitWithReturnNumber = [NSNumber numberWithDouble:mutableDayDebitWithReturn];
    [budgetOnCurrentDay setObject:mutableDayDebitWithReturnNumber forKey:@"mutableBudgetOnDay"];
    [userDefaults setObject:budgetOnCurrentDay forKey:@"budgetOnCurrentDay"];
    
    NSNumber *number = 0;
    [userDefaults setObject:number forKey:@"processOfSpendingMoneyTextField"];
    
    
    
    if ([[budgetOnCurrentDay objectForKey:@"mutableBudgetOnDay"] doubleValue] > 0) {
        BOOL callOneTime = NO;
        [userDefaults setBool:callOneTime forKey:@"callOneTimeToLable"];
        BOOL dailyBudgetTomorrowBoolLabel = NO;
        [userDefaults setBool:dailyBudgetTomorrowBoolLabel forKey:@"dailyBudgetTomorrowBoolLabel"];
    }
    
    [historySpendOfMonth removeLastObject];
    [userDefaults setObject:historySpendOfMonth forKey:@"historySpendOfMonth"];
    [userDefaults synchronize];
    [self popVC];
    
}

- (void)popVC {
    UIViewController* popVC;
    for (UIViewController* vC in self.navigationController.viewControllers) {
        if ([vC isKindOfClass:[MainScreenTableViewController class]]) {
            popVC = vC;
            break;
        }
    }
    if (popVC) {
        [self.navigationController popToViewController:popVC animated:YES];
    }
    
}


@end
