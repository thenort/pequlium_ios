//
//  MonthEndViewController.swift
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 26/02/2017.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

import UIKit

class MonthEndViewController: UIViewController {

    @IBOutlet weak var balanceEndMonthL: UILabel!
    private let manager = Manager.sharedInstance
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.balanceEndMonthL.text = String(format: "%.2f", self.manager.getMutableMonthBudget())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func tapTransferMonthBalance(_ sender: UIButton) {
        self.manager.setIsCallMonthEndVC(boolValue: true)
        self.manager.transferMonthBalanceMonthEnd()
        //value for Switch SettingsDayEnd
        self.manager.setTransferMonthBalance(boolValue: true)
        self.manager.setAmountMonthBalance(boolValue: false)
        self.manager.setSaveBalance(boolValue: false)
        self.popToViewController()
    }
    
    @IBAction func tapAmountMonthBalance(_ sender: UIButton) {
        self.manager.setIsCallMonthEndVC(boolValue: true)
        self.manager.amountMonthBalanceMonthEnd()
        //value for Switch SettingsMonthEnd
        self.manager.setAmountMonthBalance(boolValue: true)
        self.manager.setTransferMonthBalance(boolValue: false)
        self.manager.setSaveBalance(boolValue: false)
        self.popToViewController()
    }
    
    @IBAction func tapSaveMonthBalance(_ sender: UIButton) {
        self.manager.setIsCallMonthEndVC(boolValue: true)
        //do something
        self.manager.saveMonthBalanceMonthEnd()
        self.manager.setSaveBalance(boolValue: true)
        self.manager.setTransferMonthBalance(boolValue: false)
        self.manager.setAmountMonthBalance(boolValue: false)
        self.popToViewController()
    }
    
    func popToViewController() {
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is SpendBudgetTableViewController {
                _ = self.navigationController?.popToViewController(vc as! SpendBudgetTableViewController, animated: true)
            }
        }
    }
}
