//
//  SettingsMainScreenHeaderView.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 12.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "SettingsMainScreenHeaderView.h"
#import "MoneyBoxHistoryTableViewController.h"

@interface SettingsMainScreenHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *howMuchMoneyToNewMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaToNewMonthLabel;
@property (weak, nonatomic) IBOutlet UIButton *moneyBoxButton;
@end

@implementation SettingsMainScreenHeaderView

- (instancetype)initWithDate:(NSDate*)timeForNextDate lastMoney:(double)money moneyBox:(double)moneyBoxText {
    self = (SettingsMainScreenHeaderView*)[[[NSBundle mainBundle] loadNibNamed:@"SettingsMainScreenHeader" owner:self options:nil]objectAtIndex:0];
    if(self){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd MMMM"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
        NSString *dateString = [dateFormatter stringFromDate:timeForNextDate];
        
        self.summaToNewMonthLabel.text = [NSString stringWithFormat:@"Сумма до %@", dateString];
        self.howMuchMoneyToNewMonthLabel.text = [NSString stringWithFormat:@"%2.f", money];
        [self.moneyBoxButton setTitle:[NSString stringWithFormat:@"%2.f", moneyBoxText] forState:UIControlStateNormal];
    }
    return self;
}

- (IBAction)tappedMoneyBox:(id)sender {
    [self.delegate tappedMoneyBox];
}


@end
