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
    self.navigationItem.hidesBackButton = YES;
}


- (IBAction)budgetWithSavingMoney:(id)sender {
    
    if (![[Manager sharedInstance] getBudgetOnDay]) {
        [[Manager sharedInstance] setMoneyBox:[[Manager sharedInstance] getMonthPercent]];
        [[Manager sharedInstance] setMonthDebit:[[Manager sharedInstance] getMonthDebit] - [[Manager sharedInstance] getMonthPercent]];
        [[Manager sharedInstance] setMutableMonthDebit:[[Manager sharedInstance] getMutableMonthDebit] - [[Manager sharedInstance]getMonthPercent]];
        [[Manager sharedInstance] setWithPercent:YES];
    } else {
        [[Manager sharedInstance] setNewMonthDebit:[[Manager sharedInstance] getNewMonthDebit] - [[Manager sharedInstance] getNewMonthPercent]];
        
        [[Manager sharedInstance] setNewWithPercent:YES];
        [[Manager sharedInstance] setChangeAllStableDebitBool:YES];
    }
    [self writeInData:[self.budgetOnDayWithSavingLabel.text doubleValue] setNewWithPercent:YES];
    
    [self pushVC];
}

- (IBAction)budgetWithNonSavingMoney:(id)sender {
    [self writeInData:[self.budgetOnDayLabel.text doubleValue] setNewWithPercent:NO];
    
    [self pushVC];
}

- (void)writeInData:(double)budgetOnDay setNewWithPercent:(BOOL)newWithPercent {
    if (![[Manager sharedInstance] getBudgetOnDay]) {
        [[Manager sharedInstance] setBudgetOnDay:budgetOnDay];
        [[Manager sharedInstance] setBudgetOnCurrentDay:budgetOnDay dayWhenSpend:[NSDate date]];
        [[Manager sharedInstance] setStableBudgetOnDay:budgetOnDay];
    } else {
        [[Manager sharedInstance] setNewStableBudgetOnDay:budgetOnDay];
        
        [[Manager sharedInstance] setNewWithPercent:newWithPercent];
        
        [[Manager sharedInstance] setChangeAllStableDebitBool:YES];
    }
}

- (void)pushVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    MainScreenTableViewController *mainScreenTableViewVC = [storyboard instantiateViewControllerWithIdentifier:@"MainScreenTableViewController"];
    [self.navigationController pushViewController:mainScreenTableViewVC animated:YES];
}

@end
