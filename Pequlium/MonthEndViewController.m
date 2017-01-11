//
//  MonthEndViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 14.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "MonthEndViewController.h"
#import "MainScreenTableViewController.h"

@interface MonthEndViewController ()
@property (weak, nonatomic) IBOutlet UILabel *balanceEndMonth;
@end

@implementation MonthEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;

    
}

- (void)goToVC {
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
    MainScreenTableViewController *mainScreenTableViewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainScreenTableViewController"];
    [nav pushViewController:mainScreenTableViewVC animated:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)callOneTimeMonthBool {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL callOneTimeMonth = YES;
    [userDefaults setBool:callOneTimeMonth forKey:@"callOneTimeMonth"];
    [userDefaults synchronize];
}

- (IBAction)moveBalanceOnToday:(id)sender {
    //[self callOneTimeMonthBool];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    //значение для switch в настройках дня 1 пункта
    [userDefaults setBool:YES forKey:@"transferMoneyNextDaySettingsMonth"];
    [userDefaults synchronize];
    [self goToVC];
}

- (IBAction)amountOnDailyBudget:(id)sender {
    //[self callOneTimeMonthBool];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    
    //значение для switch в настройках дня 2 пункта
    [userDefaults setBool:YES forKey:@"amountDailyBudgetSettingsMonth"];
    [userDefaults synchronize];
    [self goToVC];
}

- (IBAction)saveMoney:(id)sender {
    //[self callOneTimeMonthBool];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    //значение для switch в настройках дня 3 пункта
    [userDefaults setBool:YES forKey:@"moneyBoxSettingsMonth"];
    [userDefaults synchronize];
    [self goToVC];
}


@end
