//
//  Manager.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 20.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "Manager.h"
#import <NSDate+TimeAgo.h>
#include <sys/types.h>
#include <sys/sysctl.h>


@implementation Manager

+ (instancetype) sharedInstance {
    static id _singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        _singleton = [[self alloc] init];
    });
    return _singleton;
}

#pragma mark - Work With Data -

#pragma mark - Work with budgetOnCurrentDay NSDictionary (NSUserdefaults) -

// Work with budgetOnCurrentDay NSDictionary (get)

- (NSDictionary*)getBudgetOnCurrentDay {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictBudgetOnCurrentDay = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    return dictBudgetOnCurrentDay;
}

- (NSNumber*)getBudgetOnCurrentDayMoneyNumber {
    return [self getBudgetOnCurrentDay][@"mutableBudgetOnDay"];
}

- (double)getBudgetOnCurrentDayMoneyDouble {
    return [[self getBudgetOnCurrentDay][@"mutableBudgetOnDay"] doubleValue];
}

- (NSDate*)getBudgetOnCurrentDayDate {
    return [self getBudgetOnCurrentDay][@"dayWhenSpend"];
}

// Work with budgetOnCurrentDay NSDictionary (set)

- (void)setBudgetOnCurrentDay:(double)mutableBudgetOnDay dayWhenSpend:(NSDate*)date {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithDouble:mutableBudgetOnDay], @"mutableBudgetOnDay", date, @"dayWhenSpend", nil];
    [userDefaults setObject:dict forKey:@"budgetOnCurrentDay"];
    [userDefaults synchronize];
}

#pragma mark - Work with budgetOnDay (NSUserdefaults) -

// Work with budgetOnDay (get)

- (double)getBudgetOnDay {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:@"budgetOnDay"] doubleValue];
}

// Work with budgetOnDay (set)

- (void)setBudgetOnDay:(double)budgetOnDay {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithDouble:budgetOnDay] forKey:@"budgetOnDay"];
    [userDefaults synchronize];
}

#pragma mark - Work with dailyBudgetTomorrowCounted (NSUserdefaults) -

// Work with dailyBudgetTomorrowCounted (get)

- (double)getDailyBudgetTomorrowCounted {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:@"dailyBudgetTomorrowCounted"] doubleValue];
}

// Work with dailyBudgetTomorrowCounted (set)

- (void)setDailyBudgetTomorrowCounted:(double)dailyBudgetTomorrowCounted {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithDouble:dailyBudgetTomorrowCounted] forKey:@"dailyBudgetTomorrowCounted"];
    [userDefaults synchronize];
}



#pragma mark - Work with stableBudgetOnDay  (NSUserdefaults) -

// Work with stableBudgetOnDay  (get)
- (double)getStableBudgetOnDay {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:@"stableBudgetOnDay"] doubleValue];
}

// Work with stableBudgetOnDay  (set)
- (void)setStableBudgetOnDay:(double)stableBudgetOnDay {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithDouble:stableBudgetOnDay] forKey:@"stableBudgetOnDay"];
    [userDefaults synchronize];

}

#pragma mark - Work with newStableBudgetOnDay  (NSUserdefaults) -

// Work with newStableBudgetOnDay  (get)
- (double)getNewStableBudgetOnDay {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:@"newStableBudgetOnDay"] doubleValue];
}

// Work with newStableBudgetOnDay  (set)
- (void)setNewStableBudgetOnDay:(double)newStableBudgetOnDay {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithDouble:newStableBudgetOnDay] forKey:@"newStableBudgetOnDay"];
    [userDefaults synchronize];
    
}

#pragma mark - Work with mutableMonthDebit  (NSUserdefaults) -

// Work with mutableMonthDebit  (get)
- (double)getMutableMonthDebit {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:@"mutableMonthDebit"] doubleValue];
}

- (NSNumber*) getMutableMonthDebitNumber {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"mutableMonthDebit"];
}

// Work with mutableMonthDebit  (set)
- (void)setMutableMonthDebit:(double)mutableMonthDebit {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithDouble:mutableMonthDebit] forKey:@"mutableMonthDebit"];
    [userDefaults synchronize];
}



#pragma mark - Work with monthDebit  (NSUserdefaults) -

// Work with monthDebit  (get)
- (double)getMonthDebit {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:@"monthDebit"] doubleValue];
}

// Work with monthDebit  (set)
- (void)setMonthDebit:(double)monthDebit {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithDouble:monthDebit] forKey:@"monthDebit"];
    [userDefaults synchronize];
}

#pragma mark - Work with newMonthDebit  (NSUserdefaults) -

// Work with newMonthDebit  (get)
- (double)getNewMonthDebit {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:@"newMonthDebit"] doubleValue];
}

// Work with monthDebit  (set)
- (void)setNewMonthDebit:(double)newMonthDebit {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithDouble:newMonthDebit] forKey:@"newMonthDebit"];
    [userDefaults synchronize];
}


#pragma mark - Work with monthPercent  (NSUserdefaults) -

// Work with monthPercent  (get)
- (double)getMonthPercent {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:@"monthPercent"] doubleValue];
}

// Work with monthPercent  (set)
- (void)setMonthPercent:(double)monthPercent {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithDouble:monthPercent] forKey:@"monthPercent"];
    [userDefaults synchronize];
}

// Work with withPercent  (get)
- (BOOL)getWithPercent {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"withPercent"];
}

// Work with withPercent  (set)
- (void)setWithPercent:(BOOL)withPercent {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:withPercent forKey:@"withPercent"];
    [userDefaults synchronize];
}

#pragma mark - Work with newWithPercent  (NSUserdefaults) -

// Work with newWithPercent  (get)
- (BOOL)getNewWithPercent {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"newWithPercent"];
}

// Work with withPercent  (set)
- (void)setNewWithPercent:(BOOL)newWithPercent {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:newWithPercent forKey:@"newWithPercent"];
    [userDefaults synchronize];
}

#pragma mark - Work with newMonthPercent  (NSUserdefaults) -

// Work with newMonthPercent  (get)
- (double)getNewMonthPercent {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:@"newMonthPercent"] doubleValue];
}

// Work with newMonthPercent  (set)
- (void)setNewMonthPercent:(double)newMonthPercent {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithDouble:newMonthPercent] forKey:@"newMonthPercent"];
    [userDefaults synchronize];
}

#pragma mark - Work with moneyBox  (NSUserdefaults) -

// Work with moneyBox  (get)
- (double)getMoneyBox {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:@"moneyBox"] doubleValue];
}

// Work with moneyBox  (set)
- (void)setMoneyBox:(double)moneyBox {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithDouble:moneyBox] forKey:@"moneyBox"];
    [userDefaults synchronize];
}

#pragma mark - Work with resetDateEveryMonth  (NSUserdefaults) -

// Work with resetDateEveryMonth  (get)
- (NSDate*)getResetDateEveryMonth {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"resetDateEveryMonth"];
}

// Work with resetDateEveryMonth  (set)
- (void)setResetDateEveryMonth:(NSDate*)resetDateEveryMonth {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:resetDateEveryMonth forKey:@"resetDateEveryMonth"];
    [userDefaults synchronize];
}

#pragma mark - Work with Switch -

#pragma mark - Work with SwitchDayEnd -

// Work with SwitchDayEnd amountOnDailyBudgetSettingsDay (get)
- (BOOL)getAmountOnDailyBudgetSettingsDay {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"amountOnDailyBudgetSettingsDay"];
}

// Work with SwitchDayEnd amountOnDailyBudgetSettingsDay (set)
- (void)setAmountOnDailyBudgetSettingsDay:(BOOL)boolValue {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:boolValue forKey:@"amountOnDailyBudgetSettingsDay"];
    [userDefaults synchronize];
}

// Work with SwitchDayEnd transferMoneyToNextDaySettingsDay (get)
- (BOOL)getTransferMoneyToNextDaySettingsDay {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"transferMoneyToNextDaySettingsDay"];
}

// Work with SwitchDayEnd transferMoneyToNextDaySettingsDay (set)
- (void)setTransferMoneyToNextDaySettingsDay:(BOOL)boolValue {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:boolValue forKey:@"transferMoneyToNextDaySettingsDay"];
    [userDefaults synchronize];
}

#pragma mark - Work with change: (monthPercent, monthDebit, stableBudgetOnDay) -

- (void)setAllStableDebit {
    [self setMonthDebit:[self getNewMonthDebit]];
    [self setStableBudgetOnDay:[self getNewStableBudgetOnDay]];
    if ([self getNewWithPercent]) {
        [self setWithPercent:YES];
        [self setMonthPercent:[self getNewMonthPercent]];
    } else {
        [self setWithPercent:NO];
    }
    [self setChangeAllStableDebitBool:NO];
}

#pragma mark - Work with changeAllStableDebit  (NSUserdefaults) -

// Work with changeAllStableDebitBool  (get)
- (BOOL)getChangeAllStableDebitBool {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"changeAllStableDebitBool"];
}


// Work with changeAllStableDebitBool  (set)
- (void)setChangeAllStableDebitBool:(BOOL)changeAllStableDebitBool {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:changeAllStableDebitBool forKey:@"changeAllStableDebitBool"];
    [userDefaults synchronize];
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

- (void)resetUserDefData:(double)mutableBudgetOnDay {
    //обнуление средств (возобновление даты и бюджета)
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *stableBudgetOnDay = [userDefaults objectForKey:@"stableBudgetOnDay"];
    [userDefaults setObject:stableBudgetOnDay forKey:@"budgetOnDay"];
    
    NSDictionary *budgetOnCurrentDay = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    budgetOnCurrentDay = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"dayWhenSpend", [NSNumber numberWithDouble:mutableBudgetOnDay], @"mutableBudgetOnDay", nil];
    [userDefaults setObject:budgetOnCurrentDay forKey:@"budgetOnCurrentDay"];
    
    [userDefaults setObject:nil forKey:@"historySpendOfMonth"];
    [userDefaults synchronize];
}

- (void)resetDate {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    //обнуляем историю
    [userDefaults setObject:nil forKey:@"historySpendOfMonth"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *resetDateEveryMonth = [userDefaults objectForKey:@"resetDateEveryMonth"];
    NSDateComponents *componentsCurrentDate = [calendar components:(NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:resetDateEveryMonth];
    [componentsCurrentDate setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate *newCurrentDate = [calendar dateFromComponents:componentsCurrentDate];
    [userDefaults setObject:newCurrentDate forKey:@"oldResetDateEveryMonth"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:newCurrentDate options:0];
    [userDefaults setObject:newDate forKey:@"resetDateEveryMonth"];
    [userDefaults synchronize];
    
}

#pragma mark - Work with Date -

- (NSInteger)differenceDay {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *budgetOnCurrentDay = [userDefault objectForKey:@"budgetOnCurrentDay"];
    NSDate *dateFromDict = [budgetOnCurrentDay objectForKey:@"dayWhenSpend"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    [calendar setLocale:[NSLocale systemLocale]];
    
    //разница в time zone
    NSDate* currentDate = [NSDate date];
    NSTimeZone* CurrentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSTimeZone* SystemTimeZone = [NSTimeZone systemTimeZone];
    NSInteger currentGMTOffset = [CurrentTimeZone secondsFromGMTForDate:currentDate];
    NSInteger SystemGMTOffset = [SystemTimeZone secondsFromGMTForDate:currentDate];
    NSTimeInterval interval = SystemGMTOffset - currentGMTOffset;
    CGFloat intervalInHour = interval / 3600;
    //
    
    NSDateComponents *componentsDateFromDict = [calendar components:(NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:dateFromDict];
    [componentsDateFromDict setTimeZone:[NSTimeZone systemTimeZone]];
    componentsDateFromDict.hour = +intervalInHour;
    
    NSDate *newDateFromDict = [calendar dateFromComponents:componentsDateFromDict];
    
    NSDateComponents *componentsCurrentDate = [calendar components:(NSCalendarUnitDay| NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate new]];
    [componentsCurrentDate setTimeZone:[NSTimeZone systemTimeZone]];
    componentsCurrentDate.hour = +intervalInHour;
    
    NSDate *newCurrentDate = [calendar dateFromComponents:componentsCurrentDate];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay fromDate:newDateFromDict toDate:newCurrentDate options:0];
    return difference.day;
    
}

- (NSUInteger)daysInCurrentMonth {
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate];
    return range.length;
}

- (NSString*)formatDate:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}



- (NSString*)workWithDateForMainTable:(NSDate*)date {
    NSString *timeAgo = [date timeAgo];
    return timeAgo;
}

- (NSInteger)daysToStartNewMonth {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *dateStartNewMonth = [userDefaults objectForKey:@"resetDateEveryMonth"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *days = [calendar components:NSCalendarUnitDay fromDate:[NSDate new] toDate:dateStartNewMonth options:0];
    NSInteger daysToStartNewMonth = days.day;
    if (daysToStartNewMonth == 0) {
        daysToStartNewMonth = 1;
        return daysToStartNewMonth;
    } else {
        return daysToStartNewMonth;
    }
}

- (NSString*)nameOfPreviousMonth {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *date = [calendar components:NSCalendarUnitMonth fromDate:[NSDate date]];
    NSUInteger numberOfMonth = date.month - 1;
    if (numberOfMonth == 0) {
        numberOfMonth = 12;
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    NSString *monthName = [[df monthSymbols] objectAtIndex:(numberOfMonth)];
    return monthName;

}

- (void)workWithHistoryOfSave:(id)mutableMonthDebite nameOfPeriod:(NSString*)name {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *historySaveOfMonth = [[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"historySaveOfMonth"]]mutableCopy];
    if (historySaveOfMonth == nil) {
        historySaveOfMonth = [NSMutableArray array];
    }
    NSMutableDictionary *dictWithDateAndSum = [NSMutableDictionary new];
    
    [dictWithDateAndSum setObject:mutableMonthDebite forKey: @"currentMutableMonthDebit"];
    [dictWithDateAndSum setObject:name forKey:@"currentMonthPeriod"];
    [historySaveOfMonth addObject:dictWithDateAndSum];
    [userDefaults setObject:historySaveOfMonth forKey:@"historySaveOfMonth"];
}

- (NSString*)stringForHistorySaveOfMonthDict {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    [dateFormatter setDateFormat:@"dd LLL"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComp = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:[userDefaults objectForKey:@"oldResetDateEveryMonth"]];
    
    dateComp.month = dateComp.month - 1;
    if (dateComp.month == 0) {
        dateComp.month = 12;
    }
    
    NSDate *dayAndMonthOldResetDateEveryMonth = [calendar dateFromComponents:dateComp];
    [userDefaults setObject:dayAndMonthOldResetDateEveryMonth forKey:@"dayAndMonthOldResetDateEveryMonth"];
    
    NSString *datedayAndMonthOldResetDateEveryMonth = [dateFormatter stringFromDate:[userDefaults objectForKey:@"dayAndMonthOldResetDateEveryMonth"]];
    NSString *dateFromOldResetDateEveryMonth = [dateFormatter stringFromDate:[userDefaults objectForKey:@"oldResetDateEveryMonth"]];
    
    NSString *strWithOldResetDateEveryMonthAndResetDateEveryMonth = [NSString stringWithFormat:@"%@ - %@", datedayAndMonthOldResetDateEveryMonth, dateFromOldResetDateEveryMonth];
    
    return strWithOldResetDateEveryMonthAndResetDateEveryMonth;
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

- (void)customButtonsOnKeyboardFor:(UITextField*)nameOfTextField addAction:(SEL)addAction cancelAction:(SEL)cancelAction {
    UIToolbar *ViewForButtonsOnKeyboard = [[UIToolbar alloc] init];
    [ViewForButtonsOnKeyboard sizeToFit];
    UIBarButtonItem *btnAddOnKeyboard = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:nil
                                                                        action:addAction];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *btnCancelOnKeyboard = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:nil
                                                                        action:cancelAction];
    [ViewForButtonsOnKeyboard setItems:@[btnAddOnKeyboard, flexible, btnCancelOnKeyboard]];
    nameOfTextField.inputAccessoryView = ViewForButtonsOnKeyboard;
}

#pragma mark - Work With balance in Label -


- (NSString*)updateTextBalanceLabel {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    NSNumber *mutableBudgetOnDayWithSpendNumberFromDict = [dict objectForKey:@"mutableBudgetOnDay"];
    return [NSString stringWithFormat:@"%.2f", [mutableBudgetOnDayWithSpendNumberFromDict doubleValue]];
}

@end
