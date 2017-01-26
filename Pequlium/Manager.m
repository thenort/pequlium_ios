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

#pragma mark - Singletone Methods -

+ (instancetype) sharedInstance {
    static id _singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        _singleton = [[self alloc] init];
    });
    return _singleton;
}

#pragma marlk - Platform -

- (NSString *) platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
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

- (void)resetUserDefData:(NSNumber*)mutableBudgetOnDay {
    //обнуление средств (возобновление даты и бюджета)
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *stableBudgetOnDay = [userDefaults objectForKey:@"stableBudgetOnDay"];
    [userDefaults setObject:stableBudgetOnDay forKey:@"budgetOnDay"];
    NSDictionary *budgetOnCurrentDay = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    
    budgetOnCurrentDay = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"dayWhenSpend", mutableBudgetOnDay, @"mutableBudgetOnDay", nil];
    [userDefaults setObject:budgetOnCurrentDay forKey:@"budgetOnCurrentDay"];
    [userDefaults setObject:nil forKey:@"historySpendOfMonth"];
    [userDefaults synchronize];
}

- (void)resetData {
    
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

#pragma mark - Work With balance in Label -


- (NSString*)updateTextBalanceLabel {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    NSNumber *mutableBudgetOnDayWithSpendNumberFromDict = [dict objectForKey:@"mutableBudgetOnDay"];
    return [NSString stringWithFormat:@"%.2f", [mutableBudgetOnDayWithSpendNumberFromDict doubleValue]];
}

@end
