//
//  DayEndViewController.swift
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 26/02/2017.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

import UIKit

class DayEndViewController: UIViewController {
    
    @IBOutlet weak var balanceEndDayL: UILabel!
    private let manager = Manager.sharedInstance

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.balanceEndDayL.text = String(format: "%.2f", self.manager.getBudgetOnDayValue())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }

    @IBAction func tapTransferDayBalance(_ sender: UIButton) {
        self.manager.setIsCallDayEndVC(boolValue: true)
        self.manager.transferDayBalanceDayEnd()
        //value for Switch SettingsDayEnd
        self.manager.setTransferDayBalance(boolValue: true)
        self.manager.setAmountDayBalance(boolValue: false)
        self.popToViewController()
    }
    
    @IBAction func tapAmountDayBalance(_ sender: UIButton) {
        self.manager.setIsCallDayEndVC(boolValue: true)
        self.manager.amountDayBalanceDayEnd()
        //value for Switch SettingsDayEnd
        self.manager.setAmountDayBalance(boolValue: true)
        self.manager.setTransferDayBalance(boolValue: false)
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
