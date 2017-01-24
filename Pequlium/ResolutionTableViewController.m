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
    [self updateSwitchView];
}
#pragma mark - Work with Switch -

- (void)updateSwitchView {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"resolutionSettingsSwitch"]) {
        self.resolutionSwitch.on = YES;
    } else {
        self.resolutionSwitch.on = NO;
    }
}
/// доделать переключение (алерт и т.д)
- (void)checkNotificationSetting {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            
            [userDefaults setBool:YES forKey:@"resolutionSettingsSwitch"];
            self.resolutionSwitch.on = YES;
            
        } else {
            [userDefaults setBool:NO forKey:@"resolutionSettingsSwitch"];
        }
    }];
    [userDefaults synchronize];
}

- (IBAction)pressedResolutionSwitch:(id)sender {
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([self.resolutionSwitch isOn]) {
        [userDefaults setBool:YES forKey:@"resolutionSettingsSwitch"];
    } else {
        [userDefaults setBool:NO forKey:@"resolutionSettingsSwitch"];
    }
    [userDefaults synchronize];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
