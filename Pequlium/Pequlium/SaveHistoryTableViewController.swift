//
//  SaveHistoryTableViewController.swift
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 02/03/2017.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

import UIKit

class SaveHistoryTableViewController: UITableViewController {
    
    private let manager = Manager.sharedInstance
    private var saveHistory: Array<Dictionary<String, Any>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.manager.getSaveHistory() != nil {
            self.saveHistory = self.manager.getSaveHistory()!
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.saveHistory.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SaveHistoryTableViewCell
        let tmpDataSavehistory = self.saveHistory[indexPath.row]
        
        let savePeriod = tmpDataSavehistory["savePeriod"]
        cell.periodSaveL.text = String(savePeriod as! String)
        
        let saveValue = tmpDataSavehistory["saveValue"]
        cell.valueSaveL.text = String(format: "%.2f", saveValue as! Double)
        
        return cell
    }
}
