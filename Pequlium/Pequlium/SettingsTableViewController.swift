//
//  SettingsTableViewController.swift
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 26/02/2017.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, SettingsHeaderViewDelegate {
    
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    private let manager = Manager.sharedInstance
    private let sharedUserDefaults = UserDefaults(suiteName: "group.pequlium.data")
    private var headerView = SettingsHeaderView()
    private var valueFromKeyboard: Double!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerView.newFinanceMothDateL.text = "Сумма до " + self.manager.dateInStrFormat(string: "dd MMMM", date: self.manager.getFinanceMonthDate())
        self.headerView.mutableMonthBudgetL.text = String(format: "%.2f", self.manager.getMutableMonthBudget())
        self.headerView.moneyBoxButton.setTitle(String(format: "%.2f", self.manager.getMoneyBox()), for: UIControlState.normal)
        self.updateStatusNotifSwitch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.xibInHeaderToTableView()
        self.tableView.tableFooterView = UIView();
        self.headerView.addValueTF.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        self.manager.customBtnsOnKeyboardFor(textFieldName: self.headerView.addValueTF, addAction: #selector(self.addButtonKeyboard), cancelAction: #selector(self.cancelButtonKeyboard))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.settingsTVCupdate), name: NSNotification.Name(rawValue: "updateSettingTVC"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateSettingTVC"), object: nil)
        print("call method deinit SettingsTableViewController")
    }
    
    func settingsTVCupdate() {
        DispatchQueue.main.async {
            self.headerView.newFinanceMothDateL.text = "Сумма до " + self.manager.dateInStrFormat(string: "dd MMMM", date: self.manager.getFinanceMonthDate())
            self.headerView.mutableMonthBudgetL.text = String(format: "%.2f", self.manager.getMutableMonthBudget())
            self.headerView.moneyBoxButton.setTitle(String(format: "%.2f", self.manager.getMoneyBox()), for: UIControlState.normal)
            
            self.updateStatusNotifSwitch()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    //MARK: Switch Resolution
    
    func updateStatusNotifSwitch() {
        if self.sharedUserDefaults?.value(forKey: "isNotificationSwitchOn") != nil {
            self.notificationSwitch.setOn(true, animated: false)
        } else {
            self.notificationSwitch.setOn(false, animated: false)
        }
    }
    
    @IBAction func swipeNotificationSwitch(_ sender: UISwitch) {
        if self.notificationSwitch.isOn {
            self.alertController(message: "1. Для того чтобы разрешить уведомления: нажмите кнопку OK\n\n2. Pequlium -> Уведомления -> Допуск уведомлений -> Переместите переключатель вправо", setStatus: false)
        } else {
            self.alertController(message: "1. Для того чтобы запретить уведомления: нажмите кнопку OK\n\n2. Pequlium -> Уведомления -> Допуск уведомлений -> Переместите переключатель влево", setStatus: true)
        }
    }
    
    func alertController(message: String, setStatus: Bool) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let settingsUrl = NSURL(string:UIApplicationOpenSettingsURLString) as! URL
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        })
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (UIAlertAction) in
            self.notificationSwitch.setOn(setStatus, animated: true)
        })
        alertController.addAction(cancelAction)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        let messageText = NSMutableAttributedString(
            string: message,
            attributes: [
                NSParagraphStyleAttributeName: paragraphStyle,
                NSFontAttributeName : UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote),
                NSForegroundColorAttributeName : UIColor.gray
            ]
        )
    
        alertController.setValue(messageText, forKey: "attributedMessage")
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Action btns on keyboard
    
    func addButtonKeyboard() {
        let newString = self.headerView.addValueTF.text?.replacingOccurrences(of: "+", with: "")
        if NumberFormatter().number(from: newString!)?.doubleValue != nil {
            self.valueFromKeyboard = (NumberFormatter().number(from: newString!)?.doubleValue)!
        }
        
        let firstChar = String(self.headerView.addValueTF.text!.characters.prefix(2))
        let exception = (isEmpty: self.headerView.addValueTF.text!.isEmpty, isNull: self.headerView.addValueTF.text == "+0", isNullComa: self.headerView.addValueTF.text == "+0,", isComa: firstChar == "+,", isDot: firstChar == "+.")
        
        if (exception.isEmpty || exception.isNull || exception.isComa || exception.isDot || exception.isNullComa) {
            let errorMessage = "Введите корректную сумму";
            let alertController = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) in
                self.headerView.addValueTF.text = nil
            })
            alertController.addAction(alertAction);
            self.present(alertController, animated: true, completion: nil);
        } else {
            //Month budget
            self.manager.setMutableMonthBudget(mutableMonthBudget: (self.manager.getMutableMonthBudget() + self.valueFromKeyboard))
            self.headerView.mutableMonthBudgetL.text = String(format: "%.2f", self.manager.getMutableMonthBudget())
            //Day budget
            let divided = valueFromKeyboard / Double(self.manager.daysToStartNewMonth())
            self.manager.setMutableDailyBudget(mutableDailyBudget: self.manager.getMutableDailyBudget() + divided)
            if self.manager.getSpendLessBudget() != nil {
                self.manager.setSpendLessBudget(tomorrowBudget: self.manager.getSpendLessBudget()! + divided)
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.headerView.tFHeightConstraint.constant = -70
                self.headerView.layoutIfNeeded()
                self.headerView.addValueTF.resignFirstResponder()
                self.headerView.addValueTF.text = nil
                self.headerView.moneyBoxButton.alpha = 1
                self.headerView.moneyBoxTextL.alpha = 1
                
               self.headerView.addValueText.setTitleColor(UIColor(colorLiteralRed: 0 / 255, green: 153 / 255, blue: 255 / 255, alpha: 1), for: .normal)
            })
        }
    }
    
    func cancelButtonKeyboard() {
        UIView.animate(withDuration: 0.5) { 
            self.headerView.tFHeightConstraint.constant = -70
            self.headerView.layoutIfNeeded()
            self.headerView.addValueTF.resignFirstResponder()
            self.headerView.addValueTF.text = nil
            self.headerView.moneyBoxButton.alpha = 1
            self.headerView.moneyBoxTextL.alpha = 1
            
            self.headerView.addValueText.setTitleColor(UIColor(colorLiteralRed: 0 / 255, green: 153 / 255, blue: 255 / 255, alpha: 1), for: .normal)
        }
    }
    
    //MARK: - xibInHeaderToTableView
    
    func xibInHeaderToTableView() {
        self.headerView = Bundle.main.loadNibNamed("SettingsHeaderXib", owner: self, options: nil)?.first as! SettingsHeaderView
        self.headerView.delegate = self
        self.tableView.tableHeaderView = self.headerView
    }
    
    //MARK: HeaderView Delegate
    
    func tapAddValue() {
        UIView.animate(withDuration: 0.5) {
            self.headerView.tFHeightConstraint.constant = +70
            self.headerView.layoutIfNeeded()
            self.headerView.addValueTF.becomeFirstResponder()
            self.headerView.moneyBoxButton.alpha = 0
            self.headerView.moneyBoxTextL.alpha = 0
        }
    }
    
    func tapMoneyBox() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier:"SaveHistoryTableViewController") as! SaveHistoryTableViewController
        self.navigationController!.pushViewController(viewController, animated: true)
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidChange(textField: UITextField) {
        if ((textField.text?.characters.count)! > 0) {
            let firstChar = String(textField.text!.characters.prefix(1))
            if (firstChar != "+") {
                textField.text = String(format: "+" + textField.text!)
            }
        }
        if (textField.text?.characters.count)! > 0 {
            self.headerView.addValueText.setTitleColor(UIColor.darkGray, for: .normal)
        } else {
            self.headerView.addValueText.setTitleColor(UIColor(colorLiteralRed: 0 / 255, green: 153 / 255, blue: 255 / 255, alpha: 1), for: .normal)
        }
    }
    
}

