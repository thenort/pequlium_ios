//
//  CreateBudgetViewController.swift
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 25/02/2017.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

import UIKit

class CreateBudgetViewController: UIViewController {

    @IBOutlet weak var dailyBudgetL: UILabel!
    @IBOutlet weak var dailyBudgetWithEconomyL: UILabel!
    @IBOutlet weak var moneySaveInYearL: UILabel!
    
    var dailyBudget:Double!
    var monthlyPercent:Double!
    var dailyBudgetWithEconomy:Double!
    
    private let manager = Manager.sharedInstance
    var monthBudget:Double!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dailyBudget = self.monthBudget / Double(self.manager.daysInCurrentMonth());
        self.monthlyPercent = (self.monthBudget / 100) * 8;
        self.dailyBudgetWithEconomy = (self.monthBudget - self.monthlyPercent) / Double(self.manager.daysInCurrentMonth());
        let moneySavingInYear = self.monthlyPercent * 12;
        
        self.dailyBudgetL.text = String(format: "%.2f", self.dailyBudget)
        self.dailyBudgetWithEconomyL.text = String(format: "%.2f", self.dailyBudgetWithEconomy)
        self.moneySaveInYearL.text = String(format: "%.2f", moneySavingInYear)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pressSaveBudgetButton(_ sender: Any) {
        saveInData(monthBudget: self.monthBudget - self.monthlyPercent, dayBudget: self.dailyBudgetWithEconomy, monthlyPercent: self.monthlyPercent)
    }
    
    @IBAction func pressNoSaveBudgetButton(_ sender: Any) {
        saveInData(monthBudget: self.monthBudget, dayBudget: self.dailyBudget, monthlyPercent: nil)
    }
    
    func saveInData(monthBudget:Double, dayBudget:Double, monthlyPercent:Double?) {
        if self.manager.getMonthlyBudget() != nil {
            self.manager.setNewMonthlyBudget(newMonthlyBudget: monthBudget)
            self.manager.setNewDailyBudget(newDailyBudget: dayBudget)
            self.manager.setNewMonthlyPercent(newMonthlyPercent: monthlyPercent)
        } else {
            self.manager.setMonthlyBudget(monthlyBudget: monthBudget)
            self.manager.setMutableMonthBudget(mutableMonthBudget: monthBudget)
            self.manager.setBudgetOnDay(dayBudget: dayBudget, daySpend: Date())
            self.manager.setMutableDailyBudget(mutableDailyBudget: dayBudget)
            self.manager.setDailyBudget(dailyBudget: dayBudget)
            self.manager.setMonthlyPercent(monthlyPercent: monthlyPercent)
            self.manager.setFinanceMonthDate(date: Date())
            self.manager.newFinanceMonth()
        }
        self.pushViewController()
    }
    
    func pushViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier:"SpendBudgetTableViewController") as! SpendBudgetTableViewController
        self.navigationController!.pushViewController(viewController, animated: true)
    }

}
