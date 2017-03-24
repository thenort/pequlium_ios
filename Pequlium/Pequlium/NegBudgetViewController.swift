//
//  NegBudgetViewController.swift
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 26/02/2017.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

import UIKit

class NegBudgetViewController: UIViewController {
    
    private let manager = Manager.sharedInstance
    
    @IBOutlet weak var negBalanceL: UILabel!
    @IBOutlet weak var amountSpendL: UILabel!
    @IBOutlet weak var spendLessL: UILabel!
    var valueFromKeyboard: Double!
    private var negBalance: Double!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.negBalance = self.manager.getBudgetOnDayValue() - self.valueFromKeyboard
        self.negBalanceL.text = String(format: "%.2f", self.negBalance)
        
        self.amountSpendInfo()
        self.spendLessInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    deinit {
        print("call method deinit NegBudgetViewController")
    }
    
    //MARK: - Info To Label
    
    func amountSpendInfo() {
        if !self.manager.getIsFromKeybCalc() {
            let newBudget = self.manager.getMutableDailyBudget() - ((self.negBalance * -1) / Double(self.manager.daysToStartNewMonth()))
            if newBudget < 0 {
                self.amountSpendL.text = "0"
            } else {
                self.amountSpendL.text = String(format: "%.2f", newBudget)
            }
        } else {
            let newBudget = self.manager.getMutableDailyBudget() - (self.valueFromKeyboard / Double(self.manager.daysToStartNewMonth()))
            if newBudget < 0 {
                self.amountSpendL.text = "0"
            } else {
                self.amountSpendL.text = String(format: "%.2f", newBudget)
            }
        }
    }
    
    func spendLessInfo() {
        if !self.manager.getIsFromKeybCalc() {
            let newBudget = self.manager.getMutableDailyBudget() - (self.negBalance * -1)
            if newBudget < 0 {
                self.spendLessL.text = "0"
            } else {
                self.spendLessL.text = String(format: "%.2f", newBudget)
            }
        } else {
            if self.manager.getSpendLessBudget() == nil {
                let newBudget = self.manager.getMutableDailyBudget() - self.valueFromKeyboard
                if newBudget < 0 {
                    self.spendLessL.text = "0"
                } else {
                    self.spendLessL.text = String(format: "%.2f", newBudget)
                }
            } else {
                let newBudget = self.manager.getSpendLessBudget()! - self.valueFromKeyboard
                if newBudget < 0 {
                    self.spendLessL.text = "0"
                } else {
                    self.spendLessL.text = String(format: "%.2f", newBudget)
                }
            }
        }
    }
    
    //MARK: - Action Buttons

    @IBAction func tapAmountSpendButton(_ sender: UIButton) {
        let amountSpend:Double! = Double(self.amountSpendL.text! as String)
        
        if amountSpend > 0 {
            if !self.manager.getIsFromKeybCalc() {
                let newBudget = self.manager.getMutableDailyBudget() - ((self.negBalance * -1) / Double(self.manager.daysToStartNewMonth()))
                self.manager.setMutableDailyBudget(mutableDailyBudget: newBudget)
                self.manager.setIsFromKeybCalc(boolValue: true)
            } else {
                let divided = (self.valueFromKeyboard / Double(self.manager.daysToStartNewMonth()))
                let newBudget = self.manager.getMutableDailyBudget() - divided
                self.manager.setMutableDailyBudget(mutableDailyBudget: newBudget)
                //TEST 13/3/17
                if self.manager.getSpendLessBudget() != nil {
                    if (self.manager.getSpendLessBudget()! - divided) > 1 {
                        self.manager.setSpendLessBudget(tomorrowBudget: self.manager.getSpendLessBudget()! - divided)
                    }
                }
            }
            self.manager.calculationBudget(value: self.valueFromKeyboard)
            self.manager.setSpendHistory(spendValue: (self.valueFromKeyboard * -1), spendDate: Date())
            
            self.popToViewController()
        } else {
            let errorMessage = "Введенная вами сумма превышает ваш бюджет. Введите меньшую сумму";
            let alertController = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert);
            let alertAction = UIAlertAction(title: "ОК", style: .cancel, handler: nil);
            alertController.addAction(alertAction);
            self.present(alertController, animated: true, completion: nil);
        }
        
    }
    
    @IBAction func tapSpendLessButton(_ sender: UIButton) {
        let spendLess:Double! = Double(self.spendLessL.text! as String)
        
        if spendLess > 0 {
            if !self.manager.getIsFromKeybCalc() {
                let newBudget = self.manager.getMutableDailyBudget() - (self.negBalance * -1)
                self.manager.setSpendLessBudget(tomorrowBudget: newBudget)
                self.manager.setIsFromKeybCalc(boolValue: true)
            } else {
                if self.manager.getSpendLessBudget() == nil {
                    let newBudget = self.manager.getMutableDailyBudget() - self.valueFromKeyboard
                    self.manager.setSpendLessBudget(tomorrowBudget: newBudget)
                } else {
                    let newBudget = self.manager.getSpendLessBudget()! - self.valueFromKeyboard
                    self.manager.setSpendLessBudget(tomorrowBudget: newBudget)
                }
            }
            self.manager.calculationBudget(value: self.valueFromKeyboard)
            self.manager.setSpendHistory(spendValue: (self.valueFromKeyboard * -1), spendDate: Date())
            self.popToViewController()
        } else {
            let errorMessage = "Введенная вами сумма превышает ваш бюджет на завтра. Нажмите: Пересчитать дневной бюджет, или введите меньшую сумму.";
            let alertController = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert);
            let alertAction = UIAlertAction(title: "ОК", style: .cancel, handler: nil);
            alertController.addAction(alertAction);
            self.present(alertController, animated: true, completion: nil);
        }
    }

    @IBAction func tapMistakeButton(_ sender: UIButton) {
        self.popToViewController()
    }
    
    
    func popToViewController() {
         _ = self.navigationController?.popViewController(animated: true)
    }
}
