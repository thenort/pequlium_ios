//
//  MoneyBoxHistoryTableViewCell.h
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 13.01.17.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyBoxHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameOfMonth;
@property (weak, nonatomic) IBOutlet UILabel *moneySave;
@end
