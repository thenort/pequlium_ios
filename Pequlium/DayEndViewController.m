//
//  DayEndViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 14.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "DayEndViewController.h"

@interface DayEndViewController ()
@property (weak, nonatomic) IBOutlet UILabel *balanceEndDay;
@end

@implementation DayEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefaults objectForKey:@"budgetOnCurrentDay"];
    NSNumber *mutableBudgetOnDayWithSpendNumberFromDict = [dict objectForKey:@"mutableBudgetOnDay"];
    
    BOOL callOneTimeDay = YES;
    [userDefaults setBool:callOneTimeDay forKey:@"callOneTimeDay"];
    [userDefaults synchronize];
    
    self.balanceEndDay.text = [NSString stringWithFormat:@"%.2f", [mutableBudgetOnDayWithSpendNumberFromDict doubleValue]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moveBalanceOnToday:(id)sender {
    
    
}

- (IBAction)amountOnDailyBudget:(id)sender {
    
    
}

@end
