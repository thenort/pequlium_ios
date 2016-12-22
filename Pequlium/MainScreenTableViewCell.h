//
//  MainScreenTableViewCell.h
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 22.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainScreenTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *howLongAgoSpandMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *howMuchMoneySpendLabel;
@end
