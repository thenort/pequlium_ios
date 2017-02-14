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
- (NSNumber*)getBudgetOnCurrentDayMoneyNumber;
- (double)getBudgetOnCurrentDayMoneyDouble;
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
- (NSNumber*) getMutableMonthDebitNumber;
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

- (BOOL)getAmountOnDailyBudgetSettingsDay;
- (void)setAmountOnDailyBudgetSettingsDay:(BOOL)boolValue;
- (BOOL)getTransferMoneyToNextDaySettingsDay;
- (void)setTransferMoneyToNextDaySettingsDay:(BOOL)boolValue;

- (BOOL)getTransferMoneyNextDaySettingsMonth;
- (void)setTransferMoneyNextDaySettingsMonth:(BOOL)boolValue;
- (BOOL)getAmountDailyBudgetSettingsMonth;
- (void)setAmountDailyBudgetSettingsMonth:(BOOL)boolValue;
- (BOOL)getMoneyBoxSettingsMonth;
- (void)setMoneyBoxSettingsMonth:(BOOL)boolValue;

- (BOOL)getCallOneTimeDay;
- (void)setCallOneTimeDay:(BOOL)callOneTimeDay;

- (BOOL)getCallOneTimeMonth;
- (void)setCallOneTimeMonth:(BOOL)callOneTimeMonth;

- (BOOL)getCallOneTime;
- (void)setCallOneTime:(BOOL)callOneTime;


- (BOOL)getDailyBudgetTomorrowCountedBool;
- (void)setDailyBudgetTomorrowCountedBool:(BOOL)dailyBudgetTomorrowCountedBool;

- (BOOL)getDailyBudgetTomorrowBool;
- (void)setDailyBudgetTomorrowBool:(BOOL)dailyBudgetTomorrowBool;

- (void)setAllStableDebit;

- (BOOL)getChangeAllStableDebitBool;
- (void)setChangeAllStableDebitBool:(BOOL)changeAllStableDebitBool;

#pragma mark - Bool NegativeBalance Controller -
- (BOOL)getCallFirstTimeInfoToLable;
- (void)setCallFirstTimeInfoToLable:(BOOL)callFirstTimeInfoToLable;
- (BOOL)getCallFirstTimeInfoToLableTwo;
- (void)setCallFirstTimeInfoToLableTwo:(BOOL)callFirstTimeInfoToLableTwo;

#pragma mark - getHistorySpendOfMonth -
- (NSMutableArray*)getHistorySpendOfMonth;
- (NSMutableArray*)getHistorySpendOfMonthNoCopy;
- (void)setHistorySpendOfMonth:(NSNumber*)currentSpendNumber andDate:(NSDate*)date;
- (void)setHistorySpendOfMonthNil;
- (void)setHistorySpendOfMonthArray:(NSMutableArray*)arrayForTable;

#pragma mark - Calculation Day End -
- (void)moveBalanceOnTodayDayEnd;
- (void)amountOnDailyBudgetDayEnd;

#pragma mark - Calculation Month End -
- (void)moveBalanceOnTodayMonthEnd;
- (void)amountOnDailyBudgetMonthEnd;
- (void)saveMoneyMonthEnd;


#pragma mark - Work With MainScreenTableViewController -
- (void)resetBoolOfNegativeBalanceEndDay;
- (void)recalculationEveryDay;
- (void)resetBoolOfNegativeBalanceEndMonth;
- (void)recalculationEveryMonth;


- (void)resetDate;

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
- (NSString*)workWithDateForMainTable:(NSDate*)date;
- (NSNumber*)numFromStringDecimal:(NSString*)str;
@end
