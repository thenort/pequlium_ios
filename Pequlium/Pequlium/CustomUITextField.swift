//
//  CustomUITextField.swift
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 09/03/2017.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

import Foundation
import UIKit

class CustomUITextField: UITextField {

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
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
