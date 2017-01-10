//
//  AppDelegate.m
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 09.12.16.
//  Copyright © 2016 Kyrylo Matvieiev. All rights reserved.
//

#import "AppDelegate.h"
#import "Manager.h"
#import "MainScreenTableViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self puthNSUserDefaultsPlist];
    [self customNavigationBar];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* rootNC = [storyboard instantiateInitialViewController];
    self.window.rootViewController = rootNC;
    [self.window makeKeyAndVisible];
    
    [self callDayEndViewController];
    
    return YES;
}

- (void)callDayEndViewController {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[Manager sharedInstance]differenceDay] != 0) {
        NSDictionary *dict = [userDefaults objectForKey:@"budgetOnCurrentDay"];
        NSNumber *mutableBudgetWithSpendNumber = [dict objectForKey:@"mutableBudgetOnDay"];
        BOOL callOneTimeDay = [userDefaults boolForKey:@"callOneTimeDay"];
        if (!callOneTimeDay) {
            if ([mutableBudgetWithSpendNumber doubleValue] > 0) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
                UINavigationController *dayEndViewControllerVC = [storyboard instantiateViewControllerWithIdentifier:@"DayEndViewController"];
                self.window.rootViewController = dayEndViewControllerVC;
            }
        }
    }
}

- (void)customNavigationBar {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new]
                                  forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTranslucent:YES];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)puthNSUserDefaultsPlist {
    // puth of NSUserDefaults plist
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
}

@end
