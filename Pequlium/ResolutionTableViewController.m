//
//  ResolutionTableViewController.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 05.01.17.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

#import "ResolutionTableViewController.h"
#import <UserNotifications/UserNotifications.h>


@interface ResolutionTableViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *resolutionSwitch;
@end

@implementation ResolutionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = btnBack;
    self.tableView.tableFooterView = [UIView new];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateViewSwitchIfBackground)
                                                 name:@"MyNotification"
                                               object:nil];
    [self updateSwitchView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}


#pragma mark - Work with Switch -

- (void)updateSwitchView {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"resolutionSettingsSwitch"]) {
        
        [self.resolutionSwitch setOn:YES animated:YES];
        NSString *error = @"Для того чтобы выключить уведомления зайдите в настройки вашего устройства! Настройки -> Pequlium -> Уведомления -> Допуск уведомлений";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Измените в настройках" message:error preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleCancel handler:nil];

        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    
        [self.resolutionSwitch setEnabled:NO];
        
    } else {
        
        [self.resolutionSwitch setOn:NO animated:YES];
        NSString *error = @"Для того чтобы включить уведомления зайдите в настройки вашего устройства! Настройки -> Pequlium -> Уведомления -> Допуск уведомлений";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Измените в настройках" message:error preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleCancel handler:nil];

        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        [self.resolutionSwitch setEnabled:NO];
        
    }
    [userDefaults synchronize];
}

- (void)updateViewSwitchIfBackground {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"resolutionSettingsSwitch"]) {
        
        [self.resolutionSwitch setOn:YES animated:YES];
        [self.resolutionSwitch setEnabled:NO];
        
    } else {
        
        [self.resolutionSwitch setOn:NO animated:YES];
        [self.resolutionSwitch setEnabled:NO];
        
    }
    [userDefaults synchronize];
}

- (IBAction)pressedResolutionSwitch:(id)sender {
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
