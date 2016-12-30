//
//  Manager.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 20.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "Manager.h"


@implementation Manager

#pragma mark - Singletone Methods -

+ (instancetype) sharedInstance {
    static id _singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        _singleton = [[self alloc] init];
    });
    return _singleton;
}

#pragma mark - Work with NSUserDefaults -

- (void)saveInDataFromTextField:(NSString*)textFromTextField withKey:(NSString*)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    double valueDouble = [textFromTextField doubleValue];
    [userDefault setDouble:valueDouble forKey:key];
    [userDefault synchronize];
}

- (void)saveInData:(double)anyDoubleValue withKey:(NSString*)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setDouble:anyDoubleValue forKey:key];
    [userDefault synchronize];
}


- (NSString*)getDebitFromDataInStringFormat:(NSString*)key {
    double valueFromData = [[NSUserDefaults standardUserDefaults]doubleForKey:key];
    return [NSString stringWithFormat:@"%.2f",valueFromData];
}

- (double)getDebitFromDataInDoubleFormat:(NSString*)key {
    double valueFromData = [[NSUserDefaults standardUserDefaults]doubleForKey:key];
    return valueFromData;
}



- (void)resetData {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    double balanceOnCurrentMonth = [userDefaults doubleForKey:@"mutableMonthDebit"];
    double balance = [userDefaults doubleForKey:@"balance"];
    [userDefaults setDouble:balanceOnCurrentMonth + balance forKey:@"balance"];
    double monthDebit = [userDefaults doubleForKey:@"monthDebit"];
    [userDefaults setDouble:monthDebit forKey:@"mutableMonthDebit"];
    //сохраняем всю историю
    NSDictionary *allHistoryOfSpendOfMonth = [userDefaults objectForKey:@"historySpendOfMonth"];
    [userDefaults setObject:allHistoryOfSpendOfMonth forKey:@"allHistoryOfSpendOfAllMonth"];
    //обнуляем историю
    [userDefaults setObject:nil forKey:@"historySpendOfMonth"];
    
    
    NSDate *resetDateEveryMonth = [userDefaults objectForKey:@"resetDateEveryMonth"];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:resetDateEveryMonth options:0];
    [userDefaults setObject:newDate forKey:@"resetDateEveryMonth"];
    [userDefaults synchronize];
}

#pragma mark - Work with Date -

- (NSUInteger)daysInCurrentMonth {
    NSDate *currentDate = [NSDate new];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate];
    return range.length;
}

- (NSString*)formatDate:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

#pragma mark - Button on keyboard -

- (void)customBtnOnKeyboardFor:(UITextField*)nameOfTextField nameOfAction:(SEL)action {
    
    UIToolbar *ViewForDoneButtonOnKeyboard = [[UIToolbar alloc] init];
    [ViewForDoneButtonOnKeyboard sizeToFit];
    UIBarButtonItem *btnAddOnKeyboard = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:nil
                                                                        action:action];
    [ViewForDoneButtonOnKeyboard setItems:@[btnAddOnKeyboard]];
    nameOfTextField.inputAccessoryView = ViewForDoneButtonOnKeyboard;
}

#pragma mark - Work With balance in Label -

- (NSString*)updateTextBalanceLabel {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    NSNumber *mutableBudgetOnDayWithSpendNumberFromDict = [dict objectForKey:@"mutableBudgetOnDay"];
    return [NSString stringWithFormat:@"%.2f", [mutableBudgetOnDayWithSpendNumberFromDict doubleValue]];
}

@end
