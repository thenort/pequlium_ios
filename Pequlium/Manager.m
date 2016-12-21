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

#pragma mark -  - 

- (void)calculationBudget {
    
    double monthDebit = [[Manager sharedInstance] getDebitFromDataInDoubleFormat:@"monthDebit"];
    
    double budgetOnDay = monthDebit / [[Manager sharedInstance] daysInCurrentMonth];
    [self saveInData:budgetOnDay withKey:@"budgetOnDay"];
    
    double monthDebitWithEightPercent = (monthDebit / 100) * 8;
    
    double budgetOnDayWithEconomy = (monthDebit - monthDebitWithEightPercent) / [[Manager sharedInstance] daysInCurrentMonth];
    [self saveInData:budgetOnDayWithEconomy withKey:@"budgetOnDayWithEconomy"];
    double moneySavingYear = monthDebitWithEightPercent * 12;
    [self saveInData:moneySavingYear withKey:@"moneySavingYear"];
    
}

#pragma mark - Work with Date -

- (NSUInteger)daysInCurrentMonth {
    NSDate *currentDate = [NSDate new];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate];
    return range.length;
}





@end
