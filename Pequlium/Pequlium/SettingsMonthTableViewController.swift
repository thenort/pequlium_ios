//
//  SettingsMonthTableViewController.swift
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 27/02/2017.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

import UIKit

class SettingsMonthTableViewController: UITableViewController {
    
    private let manager = Manager.sharedInstance
    
    @IBOutlet weak var transferMonthBalanceSwitch: UISwitch!
    @IBOutlet weak var amountMonthBalanceSwitch: UISwitch!
    @IBOutlet weak var saveBalanceSwitch: UISwitch!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateStatusMonthSwitches()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    //MARK: - Switch Month Settings
    
    func updateStatusMonthSwitches() {
        if self.manager.getTransferMonthBalance() {
            self.transferMonthBalanceSwitch.setOn(true, animated: false)
        } else if self.manager.getAmountMonthBalance() {
            self.amountMonthBalanceSwitch.setOn(true, animated: false)
        } else if self.manager.getSaveBalance() {
            self.saveBalanceSwitch.setOn(true, animated: false)
        }
    }
    
    @IBAction func swipeTransferMonthBalanceSwitch(_ sender: UISwitch) {
        if self.transferMonthBalanceSwitch.isOn {
            self.amountMonthBalanceSwitch.setOn(false, animated: true)
            self.saveBalanceSwitch.setOn(false, animated: true)
            self.manager.setTransferMonthBalance(boolValue: true)
            self.manager.setAmountMonthBalance(boolValue: false)
            self.manager.setSaveBalance(boolValue: false)
        } else {
            if !self.manager.getAmountMonthBalance() || !self.manager.getSaveBalance() {
                self.transferMonthBalanceSwitch.isOn = true
            }
        }
    }
    
    @IBAction func swipeAmountMonthBalanceSwitch(_ sender: UISwitch) {
        if self.amountMonthBalanceSwitch.isOn {
            self.transferMonthBalanceSwitch.setOn(false, animated: true)
            self.saveBalanceSwitch.setOn(false, animated: true)
            self.manager.setAmountMonthBalance(boolValue: true)
            self.manager.setTransferMonthBalance(boolValue: false)
            self.manager.setSaveBalance(boolValue: false)
        } else {
            if !self.manager.getTransferMonthBalance() || !self.manager.getSaveBalance() {
                self.amountMonthBalanceSwitch.isOn = true
            }
        }
    }
    
    @IBAction func swipeSaveBalanceSwitch(_ sender: UISwitch) {
        if self.saveBalanceSwitch.isOn {
            self.transferMonthBalanceSwitch.setOn(false, animated: true)
            self.amountMonthBalanceSwitch.setOn(false, animated: true)
            self.manager.setSaveBalance(boolValue: true)
            self.manager.setTransferMonthBalance(boolValue: false)
            self.manager.setAmountMonthBalance(boolValue: false)
        } else {
            if !self.manager.getTransferMonthBalance() || !self.manager.getAmountMonthBalance() {
                self.saveBalanceSwitch.isOn = true
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}
