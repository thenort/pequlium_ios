//
//  TodayViewController.m
//  PequliumWidget
//
//  Created by Kyrylo Matvieiev on 22/02/2017.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "Manager.h"

@interface TodayViewController () <NCWidgetProviding>
@property (strong, nonatomic) Manager *manager;
@end

@implementation TodayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [Manager sharedInstance];
    
    
    
    NSLog(@"%.2f", [self.manager getMonthDebit]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    

    
    completionHandler(NCUpdateResultNewData);
}

@end
