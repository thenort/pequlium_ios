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
- (void)tappedAddMoneyButton;
@end

@interface SettingsMainScreenHeaderView : UIView
@property (weak, nonatomic) id <SettingsMainScreenHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *howMuchMoneyToNewMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaToNewMonthLabel;
@property (weak, nonatomic) IBOutlet UIButton *moneyBoxButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *addMoneyButton;
@property (weak, nonatomic) IBOutlet UITextField *enterMoneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;



//- (instancetype)initWithDate:(NSDate*)timeForNextDate lastMoney:(double)money moneyBox:(double)moneyBoxText;
@end
