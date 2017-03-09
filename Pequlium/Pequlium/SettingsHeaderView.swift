//
//  SettingsHeaderView.swift
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 26/02/2017.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

import UIKit

protocol SettingsHeaderViewDelegate {
    func tapMoneyBox()
    func tapAddValue()
}

class SettingsHeaderView: UIView {
    
    @IBOutlet weak var newFinanceMothDateL: UILabel!
    @IBOutlet weak var mutableMonthBudgetL: UILabel!
    
    @IBOutlet weak var tFHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addValueTF: CustomUITextField!
    @IBOutlet weak var addValueText: UIButton!
    @IBOutlet weak var moneyBoxButton: UIButton!
    @IBOutlet weak var moneyBoxTextL: UILabel!
    
    var delegate: SettingsHeaderViewDelegate?
    
    
    @IBAction func tapAddValueButton(_ sender: UIButton) {
       delegate?.tapAddValue()
    }
    
    @IBAction func tapMoneyBoxButton(_ sender: UIButton) {
       delegate?.tapMoneyBox()
    }
    
    
}
