//
//  CalculationViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 20.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "CalculationViewController.h"
#import "Manager.h"

@interface CalculationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *budgetOnDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *budgetOnDayWithSavingLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneySavingYearLabel;
@end

@implementation CalculationViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self textLabelFill];
}



//заполняем TextField информацией с базы
- (void)textLabelFill {
    self.budgetOnDayLabel.text = [[Manager sharedInstance]getDebitFromDataInStringFormat:@"budgetOnDay"];
    self.budgetOnDayWithSavingLabel.text = [[Manager sharedInstance]getDebitFromDataInStringFormat:@"budgetOnDayWithEconomy"];
    self.moneySavingYearLabel.text = [[Manager sharedInstance]getDebitFromDataInStringFormat:@"moneySavingYear"];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
