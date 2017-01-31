//
//  Manager.h
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 20.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Manager : NSObject

+ (instancetype) sharedInstance;

- (NSDictionary*)getBudgetOnCurrentDay;
- (NSNumber*)getBudgetOnCurrentDayMoney;
- (NSDate*)getBudgetOnCurrentDayDate;
- (void)setBudgetOnCurrentDay:(double)mutableBudgetOnDay dayWhenSpend:(NSDate*)date;

- (double)getBudgetOnDay;
- (void)setBudgetOnDay:(double)budgetOnDay;

- (double)getDailyBudgetTomorrowCounted;
- (void)setDailyBudgetTomorrowCounted:(double)dailyBudgetTomorrowCounted;

- (double)getStableBudgetOnDay;
- (void)setStableBudgetOnDay:(double)stableBudgetOnDay;

- (double)getNewStableBudgetOnDay;
- (void)setNewStableBudgetOnDay:(double)newStableBudgetOnDay;

- (double)getMutableMonthDebit;
- (void)setMutableMonthDebit:(double)mutableMonthDebit;

- (double)getMonthDebit;
- (void)setMonthDebit:(double)monthDebit;

- (double)getNewMonthDebit;
- (void)setNewMonthDebit:(double)newMonthDebit;

- (double)getMonthPercent;
- (void)setMonthPercent:(double)monthPercent;
- (BOOL)getWithPercent;
- (void)setWithPercent:(BOOL)withPercent;

- (BOOL)getNewWithPercent;
- (void)setNewWithPercent:(BOOL)newWithPercent;

- (double)getNewMonthPercent;
- (void)setNewMonthPercent:(double)newMonthPercent;

- (double)getMoneyBox;
- (void)setMoneyBox:(double)moneyBox;

- (NSDate*)getResetDateEveryMonth;
- (void)setResetDateEveryMonth:(NSDate*)resetDateEveryMonth;

- (void)setAllStableDebit;

- (BOOL)getChangeAllStableDebitBool;
- (void)setChangeAllStableDebitBool:(BOOL)changeAllStableDebitBool;

- (void)resetDate;




- (void)saveInDataFromTextField:(NSString*)textFromTextField withKey:(NSString*)key;
- (void)saveInData:(double)anyDoubleValue withKey:(NSString*)key;
- (NSString*)getDebitFromDataInStringFormat:(NSString*)key;
- (double)getDebitFromDataInDoubleFormat:(NSString*)key;
- (NSUInteger)daysInCurrentMonth;
- (NSString*)updateTextBalanceLabel;
- (void)customBtnOnKeyboardFor:(UITextField*)nameOfTextField nameOfAction:(SEL)action;
- (void)customButtonsOnKeyboardFor:(UITextField*)nameOfTextField addAction:(SEL)addAction cancelAction:(SEL)cancelAction;
- (NSString*)formatDate:(NSDate*)date;
- (NSInteger)daysToStartNewMonth;
- (NSInteger)differenceDay;
- (NSString*)nameOfPreviousMonth;
- (NSString*)stringForHistorySaveOfMonthDict;
- (void)workWithHistoryOfSave:(id)mutableMonthDebite nameOfPeriod:(NSString*)name;
- (void)resetUserDefData:(NSNumber*)mutableBudgetOnDay;
- (NSString*)workWithDateForMainTable:(NSDate*)date;

@end
