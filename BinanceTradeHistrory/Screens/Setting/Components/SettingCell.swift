//
//  SettingCell.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/06/12.
//

import UIKit

class SettingCell: UITableViewCell {
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left: leftAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure(withTitle title: String) {
        titleLabel.text = title
    }
}
