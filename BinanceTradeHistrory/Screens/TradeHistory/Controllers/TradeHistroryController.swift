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
private let footerIdentifier = "TradeHistoryFooter"

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
    
    private let isConnectedLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        subscribe()
        obserber()
        isConnected()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard !socket.isConnectedSubject.value else { return }
        socket.connect()
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: isConnectedLabel)
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
        
        socket.isConnectedSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.isConnectedLabel.text = isConnected ? "연결됨" : "연결안됨"
                self?.isConnectedLabel.textColor = isConnected ? .systemGreen : .systemRed
            }
            .store(in: &subscriptions)
    }
    
    func obserber() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleColorChanged), name: NSNotification.Name(Notification.colorChanged), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleAmountChanged), name: NSNotification.Name(Notification.amountChanged), object: nil)
    }
    
    func isConnected() {
        isConnectedLabel.text = socket.isConnectedSubject.value ? "연결됨" : "연결안됨"
        isConnectedLabel.textColor = socket.isConnectedSubject.value ? .systemGreen : .systemRed
    }
    
    // MARK: - Actions
    
    @objc func handleSetting() {
        let controller = SettingController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleColorChanged() {
        historyList.removeAll()
    }
    
    @objc func handleAmountChanged() {
        historyList.removeAll()
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
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 0, historyList.isEmpty else { return nil }
        
        let footer = TradeHistoryFooter(reuseIdentifier: footerIdentifier)
        return footer
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 && historyList.isEmpty ? 200 : 0
    }
}
