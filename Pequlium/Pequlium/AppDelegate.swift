//
//  AppDelegate.swift
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 24/02/2017.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

import UIKit
import UserNotifications


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let sharedUserDefaults = UserDefaults(suiteName: "group.pequlium.data")
    private let manager = Manager.sharedInstance
    
    //MARK: - Standart Application functions
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if self.manager.getMonthlyBudget() != nil {
            self.newRootViewController()
        }
        self.customNavigationBar();
        self.pathWhereSaveDataFile();
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.isNotificationOnOff()
        if self.sharedUserDefaults?.value(forKey: "financeMonthDate") != nil {
            self.manager.recalculationMonthEnd()
            self.manager.sumSaveHistoryValueYearEnd()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateSpendBudgetTVC"), object: nil)
        }
        
        DispatchQueue.global(qos: .background).async {
           NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateSettingTVC"), object: nil)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    //MARK : - Custom functions
    
    func newRootViewController() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "SpendBudgetTableViewController") as! SpendBudgetTableViewController
        navigationController.viewControllers = [rootViewController]
        self.window?.rootViewController = navigationController
    }
    
    func customNavigationBar() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default);
        UINavigationBar.appearance().shadowImage = UIImage();
        UINavigationBar.appearance().isTranslucent = true;
        UINavigationBar.appearance().backgroundColor = UIColor.clear;
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -80.0), for: .default);
    }
    
    //MARK: - Notification
    
    func isNotificationOnOff()  {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                self.sharedUserDefaults?.set(true, forKey: "isNotificationSwitchOn")
                self.scheduleNotification()
            } else {
                self.sharedUserDefaults?.removeObject(forKey: "isNotificationSwitchOn")
            }
            self.sharedUserDefaults?.synchronize()
        }
    }
    
    func scheduleNotification() {
        let objNotificationContent = UNMutableNotificationContent()
        objNotificationContent.title = "Напоминание"
        objNotificationContent.body = "Зайдите в Pequlium для упраления бюджетом!"
        objNotificationContent.sound = UNNotificationSound.default()
        
        var triggerDaily = DateComponents()
        triggerDaily.timeZone = NSTimeZone.system
        triggerDaily.hour = 13
        triggerDaily.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        let request = UNNotificationRequest(identifier: "notification", content: objNotificationContent, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    //MARK: - Path Where Save Data File
    
    func pathWhereSaveDataFile() {
        let groupContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.pequlium.data")
        let groupContainerPath = [groupContainerURL!.path]
        print("PATH:", groupContainerPath)
    }

}

