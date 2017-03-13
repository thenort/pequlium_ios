//
//  Manager.swift
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 24/02/2017.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

import UIKit

class Manager: NSObject {
    
    private let sharedDefaults = UserDefaults(suiteName: "group.pequlium.data")
    
    // MARK: - Singleton Method
    
    class var sharedInstance : Manager {
        struct Singleton {
            static let instance = Manager()
        }
        return Singleton.instance
    }
    
    // MARK: - Data Stack
    
    
    // MonthlyBudget
    func setMonthlyBudget(monthlyBudget: Double) {
        self.sharedDefaults?.set(monthlyBudget, forKey: "monthlyBudget")
        self.sharedDefaults?.synchronize()
    }
    
    func getMonthlyBudget() -> Double? {
        return self.sharedDefaults?.value(forKey: "monthlyBudget") as! Double?
    }
    
    func setNewMonthlyBudget(newMonthlyBudget: Double?) {
        self.sharedDefaults?.set(newMonthlyBudget, forKey: "newMonthlyBudget")
        self.sharedDefaults?.synchronize()
    }
    
    func getNewMonthlyBudget() -> Double? {
        return self.sharedDefaults?.value(forKey: "newMonthlyBudget") as! Double?
    }
    
    //MutableMonthBudget
    func setMutableMonthBudget(mutableMonthBudget: Double) {
        self.sharedDefaults?.set(mutableMonthBudget, forKey: "mutableMonthBudget")
        self.sharedDefaults?.synchronize()
    }
    
    func getMutableMonthBudget() -> Double {
        return self.sharedDefaults?.value(forKey: "mutableMonthBudget") as! Double
    }
    
    
    //BudgetOnDay
    func setBudgetOnDay(dayBudget: Double, daySpend: Date) {
        let calendar = Calendar.current
        var dateComp = calendar.dateComponents([.day, .month, .year], from: daySpend)
        dateComp.timeZone = NSTimeZone.system
        
        let daySpendDate = calendar.date(from: dateComp)
        
        let tmpDict:[String:Any] = ["dayBudget": dayBudget, "daySpend": daySpendDate!]
        self.sharedDefaults?.setValue(tmpDict, forKey: "currentDayBudget")
        self.sharedDefaults?.synchronize()
    }
    
    func setBudgetOnDayValue(dayBudget: Double) {
        let tmpDict:[String:Any] = ["dayBudget": dayBudget, "daySpend": self.getBudgetOnDayDate()]
        self.sharedDefaults?.setValue(tmpDict, forKey: "currentDayBudget")
        self.sharedDefaults?.synchronize()
    }
    
    func getBudgetOnDayValue() -> Double {
        let tmpDict = self.sharedDefaults?.value(forKey: "currentDayBudget") as! Dictionary<String, Any>
        return tmpDict["dayBudget"] as! Double
    }
    
    func getBudgetOnDayDate() -> Date {
        let tmpDict = self.sharedDefaults?.value(forKey: "currentDayBudget") as! Dictionary<String, Any>
        return tmpDict["daySpend"] as! Date
    }
    
    //MutableDailyBudget
    func setMutableDailyBudget(mutableDailyBudget: Double) {
        self.sharedDefaults?.set(mutableDailyBudget, forKey: "mutableDailyBudget")
    }
    
    func getMutableDailyBudget() -> Double {
        return self.sharedDefaults?.value(forKey: "mutableDailyBudget") as! Double
    }
    
    //DailyBudget
    func setDailyBudget(dailyBudget: Double) {
        self.sharedDefaults?.set(dailyBudget, forKey: "dailyBudget")
        self.sharedDefaults?.synchronize()
    }
    
    func getDailyBudget() -> Double {
        return self.sharedDefaults?.value(forKey: "dailyBudget") as! Double
    }
    
    func setNewDailyBudget(newDailyBudget: Double?) {
        self.sharedDefaults?.set(newDailyBudget, forKey: "newDailyBudget")
        self.sharedDefaults?.synchronize()
    }
    
    func getNewDailyBudget() -> Double? {
        return self.sharedDefaults?.value(forKey: "newDailyBudget") as! Double?
    }
    
    //MonthlyPerthent
    func setMonthlyPercent(monthlyPercent: Double?) {
        self.sharedDefaults?.set(monthlyPercent, forKey: "monthlyPercent")
        self.sharedDefaults?.synchronize()
    }
    
    func getMonthlyPercent() -> Double? {
        return self.sharedDefaults?.value(forKey: "monthlyPercent") as! Double?
    }
    
    func setNewMonthlyPercent(newMonthlyPercent: Double?) {
        self.sharedDefaults?.set(newMonthlyPercent, forKey: "newMonthlyPercent")
        self.sharedDefaults?.synchronize()
    }
    
    func getNewMonthlyPercent() -> Double? {
        return self.sharedDefaults?.value(forKey: "newMonthlyPercent") as! Double?
    }
    
    //- SettingDayTableVC switch (BOOL)-//
    
    //transferDayBalance
    
    func setTransferDayBalance(boolValue: Bool) {
        self.sharedDefaults?.set(boolValue, forKey: "isTransferDayBalance")
        self.sharedDefaults?.synchronize()
    }
    
    func getTransferDayBalance() -> Bool {
        return self.sharedDefaults?.bool(forKey: "isTransferDayBalance") as Bool!
    }
    
    //amountDayBalance
    
    func setAmountDayBalance(boolValue: Bool) {
        self.sharedDefaults?.set(boolValue, forKey: "isAmountDayBalance")
        self.sharedDefaults?.synchronize()
    }
    
    func getAmountDayBalance() -> Bool {
        return self.sharedDefaults?.bool(forKey: "isAmountDayBalance") as Bool!
    }
    
    //- SettingMonthTableVC switch (BOOL)-//
    
    //transferMonthBalance
    
    func setTransferMonthBalance(boolValue: Bool) {
        self.sharedDefaults?.set(boolValue, forKey: "isTransferMonthBalance")
        self.sharedDefaults?.synchronize()
    }
    
    func getTransferMonthBalance() -> Bool {
        return self.sharedDefaults?.bool(forKey: "isTransferMonthBalance") as Bool!
    }
    
    //amountMonthBalance
    
    func setAmountMonthBalance(boolValue: Bool) {
        self.sharedDefaults?.set(boolValue, forKey: "isAmountMonthBalance")
        self.sharedDefaults?.synchronize()
    }
    
    func getAmountMonthBalance() -> Bool {
        return self.sharedDefaults?.bool(forKey: "isAmountMonthBalance") as Bool!
    }
    
    //saveBalance
    
    func setSaveBalance(boolValue: Bool) {
        self.sharedDefaults?.set(boolValue, forKey: "isSaveBalance")
        self.sharedDefaults?.synchronize()
    }
    
    func getSaveBalance() -> Bool {
        return self.sharedDefaults?.bool(forKey: "isSaveBalance") as Bool!
    }
    
    //MoneyBox
    func setMoneyBox(value: Double) {
        self.sharedDefaults?.set(value, forKey: "moneyBox")
        self.sharedDefaults?.synchronize()
    }
    
    func getMoneyBox() -> Double {
        return self.sharedDefaults?.double(forKey: "moneyBox") as Double!
    }
    
    //- SaveHistoryTableVC -//
    
    //SaveHistory
    func setSaveHistory(saveValue: Double, savePeriod: String) {
        var saveHistory = self.sharedDefaults?.value(forKey: "saveHistory") as? Array<Dictionary<String, Any>>
        if (saveHistory == nil) {
            saveHistory = Array()
        }
        let dictValueAndPeriod:[String:Any] = ["saveValue": saveValue, "savePeriod": savePeriod]
        saveHistory?.insert(dictValueAndPeriod, at: 0)
        self.sharedDefaults?.set(saveHistory, forKey: "saveHistory")
        self.sharedDefaults?.synchronize()
    }
    
    func getSaveHistory() -> Array<Dictionary<String, Any>>? {
        return self.sharedDefaults?.value(forKey: "saveHistory") as? Array<Dictionary<String, Any>>
    }
    
    //- SpendBudgetTableViewController -//
    
    func setSpendHistory(spendValue: Double, spendDate: Date) {
        var spendHistory  = self.sharedDefaults?.value(forKey: "spendHistory") as? Array<Dictionary<String, Any>>
        if (spendHistory == nil) {
            spendHistory = Array()
        }
        let dictValueAndDate:[String:Any] = ["spendValue": spendValue, "spendDate": spendDate]
        spendHistory?.insert(dictValueAndDate, at: 0)
        self.sharedDefaults?.set(spendHistory, forKey: "spendHistory")
        self.sharedDefaults?.synchronize()
    }
    
    func setSpendHistoryRemove() {
        self.sharedDefaults?.removeObject(forKey: "spendHistory")//removeObject(forKey: "spendHistory")
    }
    
    func getSpendHistory() -> Array<Dictionary<String, Any>>? {
       return self.sharedDefaults?.value(forKey: "spendHistory") as? Array<Dictionary<String, Any>>
    }
    
    func setUpdateSpendHistory(updateSpendHistory: Array<Dictionary<String, Any>>?) {
        self.sharedDefaults?.set(updateSpendHistory, forKey: "spendHistory")
        self.sharedDefaults?.synchronize()
    }
    
    func calculationBudget(value: Double) {
        self.setBudgetOnDayValue(dayBudget: self.getBudgetOnDayValue() - value)
        self.setMutableMonthBudget(mutableMonthBudget: self.getMutableMonthBudget() - value)
    }
    
    //- NegBudgetViewController -//
    
    func setIsFromKeybCalc(boolValue: Bool) {
        self.sharedDefaults?.set(boolValue, forKey: "isFromKeybCalc")
        self.sharedDefaults?.synchronize()
    }
    
    func setIsFromKeybCalcRemove() {
        self.sharedDefaults?.removeObject(forKey: "isFromKeybCalc")
        self.sharedDefaults?.synchronize()
    }
    
    func getIsFromKeybCalc() -> Bool {
        return ((self.sharedDefaults?.value(forKey: "isFromKeybCalc")) != nil)
    }
    
    func setSpendLessBudget(tomorrowBudget: Double?) {
        self.sharedDefaults?.set(tomorrowBudget, forKey: "spendLessBudget")
        self.sharedDefaults?.synchronize()
    }
    
    func getSpendLessBudget() -> Double? {
        return self.sharedDefaults?.value(forKey: "spendLessBudget") as! Double?
    }
    
    // MARK: - Work with Date
    
    //DifferenceDay
    func differenceDays() -> Int? {
        let dateSpend = self.getBudgetOnDayDate()
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.system
        var compCurrDate = calendar.dateComponents([.day, .month, .year], from: Date())
        compCurrDate.timeZone = NSTimeZone.system
        let currDate = calendar.date(from: compCurrDate)
        let difference = calendar.dateComponents([.day], from: dateSpend, to: currDate!)
        
        return difference.day!
    }
    
    //FinanceMonthDate
    func setFinanceMonthDate(date: Date) {
        self.sharedDefaults?.set(date, forKey: "financeMonthDate")
        self.sharedDefaults?.synchronize()
    }
    
    func getFinanceMonthDate() -> Date {
        return self.sharedDefaults?.value(forKey: "financeMonthDate") as! Date
    }
    
    func newFinanceMonth() {
        
        let calendar = Calendar.current
        var compFinanceMonthDate = calendar.dateComponents([.day, .month, .year], from: self.getFinanceMonthDate())
        compFinanceMonthDate.timeZone = NSTimeZone.system
        
        let financeMonthDate = calendar.date(from: compFinanceMonthDate)
        
        var dateComponent = DateComponents()
        dateComponent.month = 1
        
        let newFinanceMonthDate = calendar.date(byAdding: dateComponent, to: financeMonthDate!)
        self.setFinanceMonthDate(date: newFinanceMonthDate!)
        
    }
    
    func dateInStrFormat(string:String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = string
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let dateInStrFormat = dateFormatter.string(from: date)
        return dateInStrFormat
    }
    
    func savePeriod(date: Date) -> String! {
        let calendar = Calendar.current
        var compFinanceMonthDate = calendar.dateComponents([.day, .month, .year], from: date)
        compFinanceMonthDate.timeZone = NSTimeZone.system
        
        let financeMonthDate = calendar.date(from: compFinanceMonthDate)
        
        var dateComponent = DateComponents()
        dateComponent.month = -1
        
        let oldFinanceMonthDate = calendar.date(byAdding: dateComponent, to: financeMonthDate!)
        
        return "\(self.dateInStrFormat(string: "dd MMMM", date: oldFinanceMonthDate!)) - \(self.dateInStrFormat(string: "dd MMMM", date: financeMonthDate!))"
    }
    
    //DaysInCurrentMonth
    func daysInCurrentMonth() -> Int {
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.system
        let range: Range = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: Date())!
        return range.count
    }
    
    //DaysInCurrentMonth
    func daysToStartNewMonth() -> Int {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.system
        let days = calendar.dateComponents([.day], from: Date(), to: self.getFinanceMonthDate())
        let daysToStartNewMonth = days.day
        /*
        if (daysToStartNewMonth == 0) {
            daysToStartNewMonth = 1
            return daysToStartNewMonth!
        } else {
            return daysToStartNewMonth!
        }*/
        return daysToStartNewMonth!
    }
    
    func formatHistorySpendDate(date: Date) -> String {
        let timeAgo = date.timeAgo()
        return timeAgo
    }
    
    // MARK: - Custom Button on Keyboard
    
    func customBtnOnKeyboardFor(textFieldName: UITextField, addAction: Selector ) {
        let ViewForDoneButtonOnKeyboard = UIToolbar() 
        ViewForDoneButtonOnKeyboard.sizeToFit()
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
        let btnAddOnKeyboard = UIBarButtonItem(title: "Добавить", style: UIBarButtonItemStyle.done, target: nil, action: addAction)
        ViewForDoneButtonOnKeyboard.setItems([flexible, btnAddOnKeyboard], animated: true)
        textFieldName.inputAccessoryView = ViewForDoneButtonOnKeyboard
    }
    
    func customBtnsOnKeyboardFor(textFieldName: UITextField, addAction: Selector, cancelAction: Selector) {
        let ViewForDoneButtonOnKeyboard = UIToolbar()
        ViewForDoneButtonOnKeyboard.sizeToFit()
        let btnCancelOnKeyboard = UIBarButtonItem(title: "Отменить", style: UIBarButtonItemStyle.done, target: nil, action: cancelAction)
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
        let btnAddOnKeyboard = UIBarButtonItem(title: "Добавить", style: UIBarButtonItemStyle.done, target: nil, action: addAction)
        ViewForDoneButtonOnKeyboard.setItems([btnCancelOnKeyboard, flexible, btnAddOnKeyboard], animated: true)
        textFieldName.inputAccessoryView = ViewForDoneButtonOnKeyboard
    }
    
    //MARK: - Calculation DayEnd
    
    func recalculationDayEnd() {
        if self.differenceDays() != 0 {
            if self.getBudgetOnDayValue() > 0 && self.getIsCallDayEndVC() {
                if self.getTransferDayBalance() {
                    self.transferDayBalanceDayEnd()
                } else if self.getAmountDayBalance() {
                    self.amountDayBalanceDayEnd()
                }
            }
            if self.getBudgetOnDayValue() < 0 {
                if self.getSpendLessBudget() != nil {
                    self.setBudgetOnDay(dayBudget: self.getSpendLessBudget()!, daySpend: Date())
                    
                    self.setIsFromKeybCalcRemove()
                    self.setSpendLessBudget(tomorrowBudget: nil)
                }
            }
        }
    }
    
    //- Calculation DayEnd
    
    func transferDayBalanceDayEnd() {
        self.setBudgetOnDay(dayBudget: self.getMutableDailyBudget() + self.getBudgetOnDayValue(), daySpend: Date())
    }
    
    func amountDayBalanceDayEnd() {
        let divivded = self.getBudgetOnDayValue() / Double(self.daysToStartNewMonth())
        let amountBudget = self.getMutableDailyBudget() + divivded
        self.setMutableDailyBudget(mutableDailyBudget: amountBudget)
        self.setBudgetOnDay(dayBudget: amountBudget, daySpend: Date())
    }
    
    //MARK: - Calculation MonthEnd
    
    func recalculationMonthEnd() {
        if (Date().compare(self.getFinanceMonthDate()) == .orderedDescending) {
            if self.getIsCallMonthEndVC() {
                if self.getTransferMonthBalance() {
                    self.transferMonthBalanceMonthEnd()
                } else if self.getAmountMonthBalance() {
                    self.amountMonthBalanceMonthEnd()
                } else if self.getSaveBalance() {
                    self.saveMonthBalanceMonthEnd()
                }
            }
        } else {
            self.recalculationDayEnd() // call method recalc dayEnd
        }
    }
    
    
    //- Calculation MonthEnd
    func transferMonthBalanceMonthEnd() {
        if self.getMonthlyPercent() != nil {
           self.setMoneyBox(value: self.getMoneyBox() + self.getMonthlyPercent()!)
        }
        self.setSaveHistory(saveValue: 0, savePeriod: self.savePeriod(date: self.getFinanceMonthDate()))
        
        self.newFinanceMonth()
        self.setNewBudget()
        self.setMutableDailyBudget(mutableDailyBudget: self.getDailyBudget())
        self.setBudgetOnDay(dayBudget: self.getMutableMonthBudget() + self.getMutableDailyBudget(), daySpend: Date())
        self.setMutableMonthBudget(mutableMonthBudget: self.getMonthlyBudget()! + self.getMutableMonthBudget())
    
        self.setSpendLessBudget(tomorrowBudget: nil)
        self.setIsFromKeybCalcRemove()
        self.setSpendHistoryRemove()
    }
    
    func amountMonthBalanceMonthEnd() {
        if self.getMonthlyPercent() != nil {
            self.setMoneyBox(value: self.getMoneyBox() + self.getMonthlyPercent()!)
        }
        self.setSaveHistory(saveValue: 0, savePeriod: self.savePeriod(date: self.getFinanceMonthDate()))
        
        self.newFinanceMonth()
        let divivded = self.getMutableMonthBudget() / Double(self.daysToStartNewMonth())
        self.setNewBudget()
        let amountBudget = self.getDailyBudget() + divivded
        self.setMutableDailyBudget(mutableDailyBudget: amountBudget)
        self.setBudgetOnDay(dayBudget: amountBudget, daySpend: Date())
        self.setMutableMonthBudget(mutableMonthBudget: self.getMonthlyBudget()! + self.getMutableMonthBudget())
    
        self.setSpendLessBudget(tomorrowBudget: nil)
        self.setIsFromKeybCalcRemove()
        self.setSpendHistoryRemove()
    }
    
    func saveMonthBalanceMonthEnd() {
        if self.getMonthlyPercent() != nil {
            self.setMoneyBox(value: self.getMoneyBox() + self.getMutableMonthBudget() + getMonthlyPercent()!)
        } else {
            self.setMoneyBox(value: self.getMoneyBox() + self.getMutableMonthBudget())
        }
        self.setSaveHistory(saveValue: self.getMutableMonthBudget(), savePeriod: self.savePeriod(date: self.getFinanceMonthDate()))
        self.setMoneyBoxValue(saveValue: self.getMutableMonthBudget())
        
        self.newFinanceMonth()
        self.setNewBudget()
        self.setMutableDailyBudget(mutableDailyBudget: self.getDailyBudget())
        self.setBudgetOnDay(dayBudget: self.getDailyBudget(), daySpend: Date())
        self.setMutableMonthBudget(mutableMonthBudget: self.getMonthlyBudget()!)

        self.setSpendLessBudget(tomorrowBudget: nil)
        self.setIsFromKeybCalcRemove()
        self.setSpendHistoryRemove()
    }
    
    //Change all Kind of Budgets (stable)
    func setNewBudget() {
        if self.getNewMonthlyBudget() != nil {
            if self.getNewMonthlyPercent() != nil {
                self.setMonthlyPercent(monthlyPercent: getNewMonthlyPercent()!)
                self.setNewMonthlyPercent(newMonthlyPercent: nil)
            } else {
                self.setMonthlyPercent(monthlyPercent: nil)
            }
            self.setMonthlyBudget(monthlyBudget: self.getNewMonthlyBudget()!)
            self.setDailyBudget(dailyBudget: self.getNewDailyBudget()!)
            
            setNewMonthlyBudget(newMonthlyBudget: nil)
            setNewDailyBudget(newDailyBudget: nil)
        }
    }
    
    //DayEndVC - BOOL -
    func setIsCallDayEndVC(boolValue: Bool) {
        self.sharedDefaults?.set(boolValue, forKey: "isCallDayEndVC")
        self.sharedDefaults?.synchronize()
    }
    
    func getIsCallDayEndVC() -> Bool {
        return self.sharedDefaults?.bool(forKey: "isCallDayEndVC") as Bool!
    }
    
    //MonthEndVC - BOOL -
    func setIsCallMonthEndVC(boolValue: Bool) {
        self.sharedDefaults?.set(boolValue, forKey: "isCallMonthEndVC")
        self.sharedDefaults?.synchronize()
    }
    
    func getIsCallMonthEndVC() -> Bool {
        return self.sharedDefaults?.bool(forKey: "isCallMonthEndVC") as Bool!
    }
    
    //MARK: - Sum Save Money For The Year
    
    //For (Sum Save Money For The Year)
    func setMoneyBoxValue(saveValue: Double) {
        var saveMoneyBoxValue = self.sharedDefaults?.value(forKey: "moneyBoxValue") as? Array<Double>
        if saveMoneyBoxValue == nil {
            saveMoneyBoxValue = Array()
        }
        saveMoneyBoxValue?.append(saveValue)
        self.sharedDefaults?.set(saveMoneyBoxValue, forKey: "moneyBoxValue")
        self.sharedDefaults?.synchronize()
    }
    
    func getMoneyBoxValue() -> Array<Double>? {
        return self.sharedDefaults?.value(forKey: "moneyBoxValue") as? Array<Double>
    }
    
    func sumSaveHistoryValueYearEnd() {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.system
        
        let component = calendar.dateComponents([.year], from: Date())
        if self.sharedDefaults?.value(forKey: "moneyBoxYear") == nil {
            let dateYear = calendar.date(from: component)
            self.sharedDefaults?.set(dateYear, forKey: "moneyBoxYear")
        }
        let oldYear = self.sharedDefaults?.value(forKey: "moneyBoxYear") as! Date
        let newYear: Date! = calendar.date(from: component)
        
        if oldYear < newYear {
            if self.getMoneyBoxValue() != nil {
                let saveMoneyBoxValue = self.getMoneyBoxValue()!
                var sumSaveValueYearEnd: Double = 0.00
                
                for value: Double in saveMoneyBoxValue {
                    sumSaveValueYearEnd = sumSaveValueYearEnd + value
                }
                self.setSaveHistory(saveValue: sumSaveValueYearEnd, savePeriod: self.dateInStrFormat(string: "yyyy", date: oldYear))
            } else {
                self.setSaveHistory(saveValue: 0, savePeriod: self.dateInStrFormat(string: "yyyy", date: oldYear))
            }
            
            self.sharedDefaults?.removeObject(forKey: "moneyBoxValue")
            self.sharedDefaults?.set(newYear, forKey: "moneyBoxYear")
        }
        self.sharedDefaults?.synchronize()
    }
    
}
