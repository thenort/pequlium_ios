//
//  MainScreenHeaderView.h
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 09.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainScreenHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *currentBudgetOnDayLabel;
@property (weak, nonatomic) IBOutlet UITextField *processOfSpendingMoneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *startEnterLabel;
@property (weak, nonatomic) IBOutlet UILabel *iSpendTextLabel;
@end
