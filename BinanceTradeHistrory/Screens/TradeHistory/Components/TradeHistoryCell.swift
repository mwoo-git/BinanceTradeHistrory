//
//  TradeHistoryCell.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/05/30.
//

import UIKit

class TradeHistoryCell: UITableViewCell {
    // MARK: - Properties
    
    var vm: TradeHistoryCellViewModel? {
        didSet { configure() }
    }
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let vm = vm else { return }
        timeLabel.text = vm.time
        priceLabel.text = vm.price
        amountLabel.text = vm.amount
        amountLabel.textColor = vm.ticker.trade ? vm.sell : vm.buy
    }
}
