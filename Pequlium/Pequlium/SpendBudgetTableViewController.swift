//
//  SpendBudgetTableViewController.swift
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 25/02/2017.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

import UIKit

class SpendBudgetTableViewController: UITableViewController {
    
    private var manager = Manager.sharedInstance
    private var headerView = SpendBudgetHeaderView()
    private var timer = Timer()
    private var valueFromKeyboard: Double!
    private var spendHistory: Array<Dictionary<String, Any>>?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerView.spendValueTF.becomeFirstResponder()
        self.manager.recalculationMonthEnd()
        self.manager.sumSaveHistoryValueYearEnd()
        self.callMonthEndDayEndVC()
        if self.manager.getSpendHistory() != nil {
            self.spendHistory = self.manager.getSpendHistory()!
        } else {
            self.spendHistory = nil
            self.tableView.reloadData()
        }
        self.headerView.budgetOnDayL.text = String(format: "%.2f", self.manager.getBudgetOnDayValue())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startTimer()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.xibInHeaderToTableView()
        self.headerView.spendValueTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        self.manager.customBtnOnKeyboardFor(textFieldName: self.headerView.spendValueTF, addAction: #selector(self.tapButtonOnTF))
        
        self.navigationItem.hidesBackButton = true
        self.headerView.spendValueTF.tintColor = UIColor.clear
        self.headerView.spendTextL.alpha = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.spendBudgetTVCupdate), name: NSNotification.Name(rawValue: "updateSpendBudgetTVC"), object: nil)
    }
    
    func spendBudgetTVCupdate() {
        self.callMonthEndDayEndVC()
        self.headerView.budgetOnDayL.text = String(format: "%.2f", self.manager.getBudgetOnDayValue())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopTimer()
        self.headerView.spendValueTF.resignFirstResponder()
    }
    
    
    
    func callMonthEndDayEndVC() {
        let dayExeption = (self.manager.differenceDays() != 0, !self.manager.getIsCallDayEndVC(), self.manager.getBudgetOnDayValue() > 0)
        if (Date().compare(self.manager.getFinanceMonthDate()) == .orderedDescending) {
            if (!self.manager.getIsCallMonthEndVC()) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier:"MonthEndViewController") as! MonthEndViewController
                self.navigationController!.pushViewController(viewController, animated: true)
            }
        } else {
            if (dayExeption.0 && dayExeption.1 && dayExeption.2) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier:"DayEndViewController") as! DayEndViewController
                self.navigationController!.pushViewController(viewController, animated: true)
            }
        }
    }

    //MARK: - Timer (update data table)
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 10.00, target: self, selector: #selector(self.tableViewReloadData), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        self.timer.invalidate()
    }
    
    func tableViewReloadData() {
        self.tableView.reloadData()
    }
    
    // MARK: - Text Field Button
    
    func tapButtonOnTF() {
        if NumberFormatter().number(from: self.headerView.spendValueTF.text!)?.doubleValue != nil {
           self.valueFromKeyboard = (NumberFormatter().number(from: self.headerView.spendValueTF.text!)?.doubleValue)! * -1
        }
        
        let firstChar = String(self.headerView.spendValueTF.text!.characters.prefix(2))
        let exception = (isEmpty: self.headerView.spendValueTF.text!.isEmpty, isNull: self.headerView.spendValueTF.text == "-0", isNullComa: self.headerView.spendValueTF.text == "-0,", isComa: firstChar == "-,", isDot: firstChar == "-.")
        
        if (exception.isEmpty || exception.isNull || exception.isComa || exception.isDot || exception.isNullComa) {
            let errorMessage = "Введите корректную сумму";
            let alertController = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert);
            let alertAction = UIAlertAction(title: "ОК", style: .cancel, handler: nil);
            alertController.addAction(alertAction);
            self.present(alertController, animated: true, completion: nil);
        } else if (self.valueFromKeyboard) > self.manager.getMutableMonthBudget() {
            let errorMessage = "Введенная вами сумма превышает ваш месячный финансовый остаток";
            let alertController = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert);
            let alertAction = UIAlertAction(title: "ОК", style: .cancel, handler: nil);
            alertController.addAction(alertAction);
            self.present(alertController, animated: true, completion: nil);
        } else {
            if ((self.manager.getBudgetOnDayValue() - self.valueFromKeyboard) < 0 ) {
                self.negativeBudgetVC()
            } else {
                self.manager.setSpendHistory(spendValue: self.valueFromKeyboard * -1, spendDate: Date())
                if self.manager.getSpendHistory() != nil {
                    self.spendHistory = self.manager.getSpendHistory()!
                }
                self.manager.calculationBudget(value: self.valueFromKeyboard)
                self.headerView.budgetOnDayL.text = String(format: "%.2f", self.manager.getBudgetOnDayValue())
                self.tableView.reloadData()
            }
        }
        self.cleanupSpendValueTF()
    }
    
    func cleanupSpendValueTF() {
        self.headerView.spendValueTF.text = ""
        if (self.headerView.spendValueTF.text?.isEmpty)! {
            UIView.animate(withDuration: 0.2, animations: { 
                self.headerView.spendTextL.alpha = 0
                self.headerView.enterTextL.alpha = 1
            })
        }
    }

    //MARK: - Xib In Header
    
    func xibInHeaderToTableView() {
        self.headerView = Bundle.main.loadNibNamed("SpendBudgetHeaderXib", owner: self, options: nil)?.first as! SpendBudgetHeaderView
        self.tableView.tableHeaderView = self.headerView
        self.autoresizeXib()
    }
    
    func autoresizeXib() {
        let screen = UIScreen.main.bounds
        let height = screen.height
        
        if (height > 480 && height <= 568) {
            self.tableView.tableHeaderView?.frame = CGRect(x: (self.tableView.tableHeaderView?.frame.origin.x)!, y: (self.tableView.tableHeaderView?.frame.origin.y)!, width: (self.tableView.tableHeaderView?.frame.size.width)!, height: 243)
        } else if (height > 568 && height <= 667) {
            self.tableView.tableHeaderView?.frame = CGRect (x: (self.tableView.tableHeaderView?.frame.origin.x)!, y: (self.tableView.tableHeaderView?.frame.origin.y)!, width: (self.tableView.tableHeaderView?.frame.size.width)!, height: 343)
        } else if (height > 667 && height <= 736) {
            self.tableView.tableHeaderView?.frame = CGRect (x: (self.tableView.tableHeaderView?.frame.origin.x)!, y: (self.tableView.tableHeaderView?.frame.origin.y)!, width: (self.tableView.tableHeaderView?.frame.size.width)!, height: 400)
        }
    }
    
    //MARK: - UIScrollViewDelegat 
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y < -64.0) {
            self.headerView.spendValueTF.becomeFirstResponder()
        } else if (scrollView.contentOffset.y > 41.0 ) {
            self.headerView.spendValueTF.resignFirstResponder()
        }
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldDidChange(textField: UITextField) {
        if ((textField.text?.characters.count)! > 0) {
            let firstChar = String(textField.text!.characters.prefix(1))
            if (firstChar != "-") {
                textField.text = String(format: "-" + textField.text!)
            }
        }
        if ((textField.text?.characters.count)! > 0) {
            UIView .animate(withDuration: 0.2, animations: { 
                self.headerView.spendTextL.alpha = 1
                self.headerView.enterTextL.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: { 
                self.headerView.spendTextL.alpha = 0
                self.headerView.enterTextL.alpha = 1
            })
        }
    }
    
    //MARK: Call NegBudget Controller
    
    func negativeBudgetVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier:"NegBudgetViewController") as! NegBudgetViewController
        viewController.valueFromKeyboard = self.valueFromKeyboard
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count: Int
        if self.spendHistory != nil {
            count = self.spendHistory!.count
        } else {
            count = 0
        }
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! SpendBudgetTableViewCell
        if self.spendHistory != nil {
            let tmpDataSpendHistory = self.spendHistory![indexPath.row]
            
            let spendDate = tmpDataSpendHistory["spendDate"]
            cell.timeSpendL.text = self.manager.formatHistorySpendDate(date: spendDate as! Date)
            
            let spendValue = tmpDataSpendHistory["spendValue"]
            cell.valueSpendL.text = String(format: "%.2f", spendValue as! Double)
        }
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.tableView.beginUpdates()
            if self.spendHistory != nil {
                self.spendHistory!.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.manager.setUpdateSpendHistory(updateSpendHistory: self.spendHistory)
            self.tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }

}
