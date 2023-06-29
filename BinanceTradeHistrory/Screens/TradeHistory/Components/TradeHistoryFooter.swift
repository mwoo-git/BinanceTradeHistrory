//
//  TradeHistoryFooter.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/06/29.
//

import UIKit

import UIKit

class TradeHistoryFooter: UITableViewHeaderFooterView {
    // MARK: - Properties
    
    private weak var navigationController: UINavigationController?

    private let curruntAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        addSubview(curruntAmountLabel)
        curruntAmountLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: curruntAmountLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
    }
    
    func configure() {
        guard let amount = UserDefaults.standard.string(forKey: UserDefault.amountKey) else { return }
        
        curruntAmountLabel.text = "순간거래대금 조회조건 \(amount) USDT 이상 ↑"
        descriptionLabel.text = "알트코인은 순간거래대금 조회조건의 값이 너무 크면 체결내역이 느리게 갱신될 수 있습니다."
    }
}
