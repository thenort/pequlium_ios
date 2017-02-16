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

@property (assign, nonatomic) double mutableBudgetOnDay;
@property (strong, nonatomic) Manager *manager;
@end

@implementation NegativeBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [Manager sharedInstance];
    self.navigationItem.hidesBackButton = YES;
    
    
    self.mutableBudgetOnDay = [self.manager getBudgetOnCurrentDayMoneyDouble] - self.valueFromKeyboard;
    self.negativeBalanceLabel.text = [NSString stringWithFormat:@"%.2f", self.mutableBudgetOnDay];
    
    [self allocationDailyBudgetOnMonthInfo];
    [self dailyBudgetWillBeTomorrowInfo];
}

- (void)allocationDailyBudgetOnMonthInfo {
    if (![self.manager getCallFirstTimeInfoToLable]) {
        double divided = fabs(self.mutableBudgetOnDay) / [self.manager daysToStartNewMonth];
        self.dailyBudgetWillBeLabel.text = [NSString stringWithFormat:@"%.2f", [self.manager getBudgetOnDay] - divided];
        [self.manager setCallFirstTimeInfoToLable:YES];
    } else {
        double divided = self.valueFromKeyboard / [self.manager daysToStartNewMonth];
        self.dailyBudgetWillBeLabel.text = [NSString stringWithFormat:@"%.2f", [self.manager getBudgetOnDay] - divided];
    }
}

- (IBAction)allocationDailyBudgetOnMonth:(id)sender {
    
    if ([self.dailyBudgetWillBeLabel.text doubleValue] > 0) {
        [self.manager setIsAllocationDailyBudgetOnMonth:YES];
        
        [self.manager setHistorySpendOfMonth:[NSNumber numberWithDouble:(self.valueFromKeyboard * -1)] andDate:[NSDate date]];
        [self.manager operationMinWithBudget:self.valueFromKeyboard];
        
        if (![self.manager getCallOneTime]) {
            double divided = [self.manager getBudgetOnCurrentDayMoneyDouble] / [self.manager daysToStartNewMonth];
            [self.manager setBudgetOnDay:[self.manager getBudgetOnDay] - fabs(divided)];
            
            if ([self.manager getDailyBudgetTomorrowCounted]) {
                [self.manager setDailyBudgetTomorrowCounted:[self.manager getDailyBudgetTomorrowCounted] - fabs(divided)];
            }
            
            [self.manager setCallOneTime:YES];
        } else {
            double divided = self.valueFromKeyboard / [self.manager daysToStartNewMonth];
            [self.manager setBudgetOnDay:[self.manager getBudgetOnDay] - divided];
            
            if ([self.manager getDailyBudgetTomorrowCounted]) {
                [self.manager setDailyBudgetTomorrowCounted:[self.manager getDailyBudgetTomorrowCounted] - divided];
            }
        }
        [self popVC];
    } else {
        NSString *error = @"Введенная вами сумма превышает ваш дневной бюджет. Нажмите: Потратить меньше завтра. Или введите меньшую сумму.";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ошибка!" message:error preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)dailyBudgetWillBeTomorrowInfo {
    
    if (![self.manager getCallFirstTimeInfoToLableTwo]) {
        
        double dailyBudgetWillBeTomorrow = [self.manager getBudgetOnDay] - fabs(self.mutableBudgetOnDay);
        
        if (dailyBudgetWillBeTomorrow <= 0) {
            self.dailyBudgetWillBeTomorrowLabel.text = @"0";
        } else {
            self.dailyBudgetWillBeTomorrowLabel.text = [NSString stringWithFormat:@"%.2f", dailyBudgetWillBeTomorrow];
        }

        [self.manager setCallFirstTimeInfoToLableTwo:YES];
        
    } else {
        if (![self.manager getDailyBudgetTomorrowCounted]) {
             double dailyBudgetWillBeTomorrow = [self.manager getBudgetOnDay] - self.valueFromKeyboard;
            if (dailyBudgetWillBeTomorrow <= 0) {
                self.dailyBudgetWillBeTomorrowLabel.text = @"0";
            } else {
                self.dailyBudgetWillBeTomorrowLabel.text = [NSString stringWithFormat:@"%.2f", dailyBudgetWillBeTomorrow];
            }
            
        } else {
            double dailyBudgetWillBeTomorrow = [self.manager getDailyBudgetTomorrowCounted] - self.valueFromKeyboard;
            
            if (dailyBudgetWillBeTomorrow <= 0) {
                self.dailyBudgetWillBeTomorrowLabel.text = @"0";
            } else {
                self.dailyBudgetWillBeTomorrowLabel.text = [NSString stringWithFormat:@"%.2f", dailyBudgetWillBeTomorrow];
            }
        }
    }
}


- (IBAction)dailyBudgetWillBeTomorrow:(id)sender {
    if ([self.dailyBudgetWillBeTomorrowLabel.text doubleValue] > 0) {
        [self.manager setCallOneTime:YES];
        [self.manager setDailyBudgetTomorrowCountedBool:YES];
        
        [self.manager setHistorySpendOfMonth:[NSNumber numberWithDouble:(self.valueFromKeyboard * -1)] andDate:[NSDate date]];
        [self.manager operationMinWithBudget:self.valueFromKeyboard];
        if (![self.manager getIsAllocationDailyBudgetOnMonth]) {
            [self.manager setDailyBudgetTomorrowCounted:[self.manager getBudgetOnDay] - fabs([self.manager getBudgetOnCurrentDayMoneyDouble])];
            [self.manager setIsAllocationDailyBudgetOnMonth:YES];
        } else {
            if (![self.manager getDailyBudgetTomorrowCounted]) {
                [self.manager setDailyBudgetTomorrowCounted:[self.manager getBudgetOnDay] - self.valueFromKeyboard];
            } else {
                [self.manager setDailyBudgetTomorrowCounted:[self.manager getDailyBudgetTomorrowCounted] - self.valueFromKeyboard];
            }
        }
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

    if ([self.manager getBudgetOnCurrentDayMoneyDouble] > 0) {
        [self.manager setCallFirstTimeInfoToLable:NO];
        [self.manager setCallFirstTimeInfoToLableTwo:NO];
    }

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
