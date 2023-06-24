//
//  TickerCell.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/06/05.
//

import UIKit

class TickerCell: UITableViewCell {
    // MARK: - Properties
    
    private var vm: TickerViewModel? {
        didSet { configureLabels() }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let volumeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private let changeRateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    // MARK: - Lifecycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    
    func configureUI() {
        backgroundColor = .systemBackground
        
        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 20)
        
        addSubview(volumeLabel)
        volumeLabel.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 20)
        
        addSubview(priceLabel)
        priceLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 10, paddingRight: 20)
        
        addSubview(changeRateLabel)
        changeRateLabel.anchor(top: priceLabel.bottomAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 20)
    }
    
    // MARK: - Helpers
    
    func configure(with vm: TickerViewModel) {
        self.vm = vm
    }
    
    func configureLabels() {
        guard let vm = vm else { return }
        
        nameLabel.text = vm.symbol
        volumeLabel.text = "Vol \(vm.volume) USDT"
        changeRateLabel.text = vm.ticker.changeRate > 0 ? "+\(vm.changeRate)" : vm.changeRate
        changeRateLabel.textColor = vm.ticker.changeRate > 0 ? vm.buy : vm.sell
        priceLabel.text = vm.price
    }
}
