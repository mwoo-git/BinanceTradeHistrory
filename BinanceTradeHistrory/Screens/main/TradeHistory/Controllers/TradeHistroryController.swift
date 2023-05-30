//
//  TradeHistroryController.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/05/30.
//

import UIKit
import Combine

private let cellIdentifier = "ProfileCell"

class TradeHistoryController: UITableViewController {
    // MARK: - Properties
    private var subscriptions = Set<AnyCancellable>()
    
    private var historyList = [BinanceTicker]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        BinanceWebSocketService.shared.connect()
        subscribeToTickerUpdates()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "바이낸스 미니 체결"
        view.backgroundColor = .systemBackground
        
        tableView.register(TradeHistoryCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 50
    }
    
    func subscribeToTickerUpdates() {
        BinanceWebSocketService.shared.tickerSubject
            .sink { [weak self] ticker in
                guard let ticker = ticker else { return }
                self?.historyList.insert(ticker, at: 0)
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Actions
}

// MARK: - TableViewDataSource

extension TradeHistoryController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return historyList.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TradeHistoryCell
        cell.selectionStyle = .none
        cell.vm = TradeHistoryCellViewModel(ticker: historyList[indexPath.row])
        return cell
    }
}
