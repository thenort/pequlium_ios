//
//  SettingsMainScreenHeaderView.h
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 12.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsMainScreenHeaderView : UIView
@property (weak, nonatomic, readonly) IBOutlet UILabel *howMuchMoneyToNewMonthLabel;
@property (weak, nonatomic, readonly) IBOutlet UILabel *summaToNewMonthLabel;
- (instancetype)initWithDate:(NSDate*)timeForNextDate lastMoney:(double)money;
@end
