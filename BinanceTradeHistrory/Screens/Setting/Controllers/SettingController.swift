//
//  SettingController.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/06/12.
//

import UIKit
import RxSwift

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class SettingController: UITableViewController {
    // MARK: - Properties
    
    private let titlelist = ["순간거래대금 조회조건", "매수/매도 색상"]
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    // MARK: - Helpers
    
    func configureTableView() {
        navigationItem.title = "설정"
        view.backgroundColor = .systemBackground
        
        tableView.register(SettingCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 50
    }
    
    
    // MARK: - Actions
}

// MARK: - TableViewDataSource

extension SettingController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SettingCell
        switch indexPath.section {
        case 0:
            cell.configure(withTitle: titlelist[indexPath.row])
        default:
            break
        }
        return cell
    }
}

// MARK: - TableViewDelegate

extension SettingController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let controller = EditAmountController()
                navigationController?.pushViewController(controller, animated: true)
            case 1:
                let controller = SettingController()
                navigationController?.pushViewController(controller, animated: true)
            default:
                break
            }
        default:
            break
        }
    }
}
