//
//  MonthBudgetViewController.swift
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 25/02/2017.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

import UIKit

class MonthBudgetViewController: UIViewController {

    @IBOutlet weak var enterMonthBudgetTF: UITextField!
    private var manager = Manager.sharedInstance
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.manager.customBtnOnKeyboardFor(textFieldName: self.enterMonthBudgetTF, addAction: #selector(self.tapButtonOnTF))
        (UIView.animate(withDuration: 0.4, animations: {
            self.enterMonthBudgetTF.becomeFirstResponder()
        }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.manager.getMonthlyBudget() != nil {
            self.navigationItem.hidesBackButton = false
        } else {
            self.navigationItem.hidesBackButton = true
        }
    }
    
    func tapButtonOnTF()  {
        let firstChar = String(self.enterMonthBudgetTF.text!.characters.prefix(1))
        let exception = (isEmpty: self.enterMonthBudgetTF.text!.isEmpty, isNull: firstChar == "0", isComa: firstChar == ",", isDot: firstChar == ".")
        
        if (exception.isEmpty || exception.isNull || exception.isComa || exception.isDot)  {
            let errorMessage = "Введите корректную сумму";
            let alertController = UIAlertController(title: "Ошибка", message: errorMessage, preferredStyle: .alert);
            let alertAction = UIAlertAction(title: "ОК", style: .cancel, handler: { (UIAlertAction) in
                self.enterMonthBudgetTF.text = ""
            });
            alertController.addAction(alertAction);
            self.present(alertController, animated: true, completion: nil);
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier:"CreateBudgetViewController") as! CreateBudgetViewController
            viewController.monthBudget = NumberFormatter().number(from: self.enterMonthBudgetTF.text!)?.doubleValue
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя_-+=!№;%:?@#$^&*() "
        let characterSet = NSCharacterSet (charactersIn: string)
        if string.rangeOfCharacter(from: characterSet.inverted) != nil {
            return false
        }
        return true
    }

}
