//
//  TradeHistoryHeader.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/06/10.
//

import UIKit

class TradeHistoryHeader: UITableViewHeaderFooterView {
    // MARK: - Properties

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "시간"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "체결가"
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.text = "체결대금($)"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        addSubview(timeLabel)
        timeLabel.centerY(inView: self)
        timeLabel.anchor(left: leftAnchor, paddingLeft: 12, paddingRight: 12)
        
        addSubview(priceLabel)
        priceLabel.centerY(inView: self)
        priceLabel.anchor(right: timeLabel.rightAnchor, paddingLeft: 12, paddingRight: 12)
        
        addSubview(amountLabel)
        amountLabel.centerY(inView: self)
        amountLabel.anchor(left: priceLabel.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12)
        amountLabel.setWidth(120)
    }
}
