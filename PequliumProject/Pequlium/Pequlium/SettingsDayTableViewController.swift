//
//  SettingsDayTableViewController.swift
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 27/02/2017.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

import UIKit

class SettingsDayTableViewController: UITableViewController {
    
    private let manager = Manager.sharedInstance
    
    @IBOutlet weak var transferDayBalanceSwitch: UISwitch!
    @IBOutlet weak var amountDayBalanceSwitch: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateStatusDaySwitches()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    //MARK: - Switch Day Settings
    
    func updateStatusDaySwitches() {
        if self.manager.getTransferDayBalance() {
            self.transferDayBalanceSwitch.setOn(true, animated: false)
        } else if self.manager.getAmountDayBalance() {
            self.amountDayBalanceSwitch.setOn(true, animated: false)
        }
    }
    
    @IBAction func swipeTransferDayBalanceSwitch(_ sender: UISwitch) {
        if self.transferDayBalanceSwitch.isOn {
            self.amountDayBalanceSwitch.setOn(false, animated: true)
            self.manager.setTransferDayBalance(boolValue: true)
            self.manager.setAmountDayBalance(boolValue: false)
        } else {
            self.amountDayBalanceSwitch.setOn(true, animated: true)
            self.manager.setAmountDayBalance(boolValue: true)
            self.manager.setTransferDayBalance(boolValue: false)
        }
    }
    
    @IBAction func swipeAmountDayBalanceSwitch(_ sender: UISwitch) {
        if self.amountDayBalanceSwitch.isOn {
            self.transferDayBalanceSwitch.setOn(false, animated: true)
            self.manager.setAmountDayBalance(boolValue: true)
            self.manager.setTransferDayBalance(boolValue: false)
        } else {
            self.transferDayBalanceSwitch.setOn(true, animated: true)
            self.manager.setTransferDayBalance(boolValue: true)
            self.manager.setAmountDayBalance(boolValue: false)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}
