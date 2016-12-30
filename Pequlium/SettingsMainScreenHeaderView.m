//
//  SettingsMainScreenHeaderView.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 12.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "SettingsMainScreenHeaderView.h"

@interface SettingsMainScreenHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *howMuchMoneyToNewMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaToNewMonthLabel;
@end

@implementation SettingsMainScreenHeaderView

- (instancetype)initWithDate:(NSDate*)timeForNextDate lastMoney:(double)money
{
    self = (SettingsMainScreenHeaderView*)[[[NSBundle mainBundle] loadNibNamed:@"SettingsMainScreenHeader" owner:self options:nil]objectAtIndex:0];
    if(self){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd MMMM"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
        NSString *dateString = [dateFormatter stringFromDate:timeForNextDate];
        
        self.summaToNewMonthLabel.text = [NSString stringWithFormat:@"Сумма до %@", dateString];
        self.howMuchMoneyToNewMonthLabel.text = [NSString stringWithFormat:@"%2.f", money];
    }
    return self;
}

@end
