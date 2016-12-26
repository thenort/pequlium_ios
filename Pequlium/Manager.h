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
//- (void)calculationBudget;
- (void)customBtnOnKeyboardFor:(UITextField*)nameOfTextField nameOfAction:(SEL)action;
- (NSString*)formatDate:(NSDate*)date;
- (void)resetData;
@end
