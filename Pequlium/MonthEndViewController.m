//
//  MonthEndViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 14.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "MonthEndViewController.h"

@interface MonthEndViewController ()
@property (weak, nonatomic) IBOutlet UILabel *balanceEndMonth;
@end

@implementation MonthEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL callOneTimeMonth = YES;
    [userDefaults setBool:callOneTimeMonth forKey:@"callOneTimeMonth"];
    [userDefaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moveBalanceOnToday:(id)sender {
    
    
}

- (IBAction)amountOnDailyBudget:(id)sender {
    
    
}

- (IBAction)saveMoney:(id)sender {
    
    
}


@end
