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

- (void)saveInDataFromTextField:(NSString*)textFromTextField withKey:(NSString*)key;
- (void)saveInData:(double)anyDoubleValue withKey:(NSString*)key;
- (NSString*)getDebitFromDataInStringFormat:(NSString*)key;
- (double)getDebitFromDataInDoubleFormat:(NSString*)key;
- (NSUInteger)daysInCurrentMonth;
- (NSString*)updateTextBalanceLabel;
- (void)customBtnOnKeyboardFor:(UITextField*)nameOfTextField nameOfAction:(SEL)action;
- (void)customButtonsOnKeyboardFor:(UITextField*)nameOfTextField addAction:(SEL)addAction cancelAction:(SEL)cancelAction;
- (NSString*)formatDate:(NSDate*)date;
- (void)resetData;
- (NSInteger)daysToStartNewMonth;
- (NSInteger)differenceDay;
- (NSString*)nameOfPreviousMonth;
- (NSString*)stringForHistorySaveOfMonthDict;
- (void)workWithHistoryOfSave:(id)mutableMonthDebite nameOfPeriod:(NSString*)name;
- (void)resetUserDefData:(NSNumber*)mutableBudgetOnDay;
- (NSString*)workWithDateForMainTable:(NSDate*)date;

@end
