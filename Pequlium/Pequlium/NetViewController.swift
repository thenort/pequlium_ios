//
//  NetViewController.swift
//  Pequlium
//
//  Created by Kyrylo Matvieiev on 17/03/2017.
//  Copyright © 2017 Kyrylo Matvieiev. All rights reserved.
//

import UIKit

class NetViewController: UIViewController {

    @IBOutlet weak var appStoreWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: "https://itunes.apple.com/us/app/pequlium/id1216665284?ls=1&mt=8") {
            let request = URLRequest(url: url)
            self.appStoreWebView.loadRequest(request)
        }
    }
}
