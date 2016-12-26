//
//  CalculationViewController.h
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 20.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculationViewController : UIViewController
@property (strong, nonatomic) NSString *budgetOnDay;
@property (strong, nonatomic) NSString *budgetOnDayWithSaving;
@property (strong, nonatomic) NSString *moneySavingYear;

@property (weak, nonatomic) IBOutlet UILabel *budgetOnDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *budgetOnDayWithSavingLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneySavingYearLabel;
@end
