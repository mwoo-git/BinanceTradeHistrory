//
//  TradeHistroryController.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/05/30.
//

import UIKit

class TradeHistoryController: UITableViewController {
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "바이낸스 미니 체결"
        view.backgroundColor = .red
    }
    
    // MARK: - Actions
}
