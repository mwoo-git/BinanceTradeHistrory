//
//  TradeHistroryController.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/05/30.
//

import UIKit
import Combine

private let cellIdentifier = "TradeHistoryCell"
private let headerIdentifier = "TradeHistoryHeader"

class TradeHistoryController: UITableViewController {
    // MARK: - Properties
    private let socket = BinanceWebSocketService.shared
    private var subscriptions = Set<AnyCancellable>()
    
    private var historyList = [BinanceTradeTicker]() {
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
        socket.connect()
        subscribe()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "BTCUSDT 미니 체결"
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .systemBackground
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        
        tableView.register(TradeHistoryCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(TradeHistoryHeader.self,
                           forHeaderFooterViewReuseIdentifier: headerIdentifier)
        tableView.rowHeight = 50
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "설정",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleSetting))
    }
    
    func subscribe() {
        socket.tickerSubject
            .sink { [weak self] ticker in
                guard let ticker = ticker else { return }
                self?.historyList.insert(ticker, at: 0)
            }
            .store(in: &subscriptions)
        
        socket.currentCoinSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coin in
                guard let coin = coin else { return }
                self?.historyList.removeAll()
                self?.navigationItem.title = "\(coin.uppercased()) 미니 체결"
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Actions
    
    @objc func handleSetting() {
        let controller = SettingController()
        navigationController?.pushViewController(controller, animated: true)
    }
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
