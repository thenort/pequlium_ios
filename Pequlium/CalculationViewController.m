//
//  CalculationViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 20.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "CalculationViewController.h"
#import "Manager.h"
#import "MainScreenTableViewController.h"

@interface CalculationViewController ()
@property (strong, nonatomic) Manager *manager;
@end

@implementation CalculationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.budgetOnDayLabel.text = self.budgetOnDay;
    self.budgetOnDayWithSavingLabel.text = self.budgetOnDayWithSaving;
    self.moneySavingYearLabel.text = self.moneySavingYear;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [Manager sharedInstance];
    self.navigationItem.hidesBackButton = YES;
}


- (IBAction)budgetWithSavingMoney:(id)sender {
    
    if (![self.manager getBudgetOnDay]) {
        [self.manager setMoneyBox:[self.manager getMonthPercent]];
        [self.manager setMonthDebit:[self.manager getMonthDebit] - [self.manager getMonthPercent]];
        [self.manager setMutableMonthDebit:[self.manager getMutableMonthDebit] - [self.manager getMonthPercent]];
        
        [self.manager setWithPercent:YES];
    } else {
        [self.manager setNewMonthDebit:[self.manager getNewMonthDebit] - [self.manager getNewMonthPercent]];
        
        [self.manager setNewWithPercent:YES];
        [self.manager setChangeAllStableDebitBool:YES];
    }
    [self writeInData:[self.budgetOnDayWithSavingLabel.text doubleValue] setNewWithPercent:YES];
    
    [self pushVC];
}

- (IBAction)budgetWithNonSavingMoney:(id)sender {
    [self writeInData:[self.budgetOnDayLabel.text doubleValue] setNewWithPercent:NO];
    
    [self pushVC];
}

- (void)writeInData:(double)budgetOnDay setNewWithPercent:(BOOL)newWithPercent {
    if (![self.manager getBudgetOnDay]) {
        [self.manager setBudgetOnDay:budgetOnDay];
        [self.manager setBudgetOnCurrentDay:budgetOnDay dayWhenSpend:[NSDate date]];
        [self.manager setStableBudgetOnDay:budgetOnDay];
    } else {
        [self.manager setNewStableBudgetOnDay:budgetOnDay];
        [self.manager setNewWithPercent:newWithPercent];
        [self.manager setChangeAllStableDebitBool:YES];
    }
}

- (void)pushVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    MainScreenTableViewController *mainScreenTableViewVC = [storyboard instantiateViewControllerWithIdentifier:@"MainScreenTableViewController"];
    [self.navigationController pushViewController:mainScreenTableViewVC animated:YES];
}

@end
