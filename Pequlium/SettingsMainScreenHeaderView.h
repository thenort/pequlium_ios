//
//  SettingsMainScreenHeaderView.h
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 12.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsMainScreenHeaderViewDelegate <NSObject>
@required
- (void)tappedMoneyBox;
@end

@interface SettingsMainScreenHeaderView : UIView
@property (weak, nonatomic) id <SettingsMainScreenHeaderViewDelegate> delegate;
- (instancetype)initWithDate:(NSDate*)timeForNextDate lastMoney:(double)money moneyBox:(double)moneyBoxText;

@end
