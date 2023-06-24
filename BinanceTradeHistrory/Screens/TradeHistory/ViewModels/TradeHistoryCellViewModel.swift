//
//  TradeHistoryCellViewModel.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/05/31.
//

import UIKit

struct TradeHistoryCellViewModel {
    let ticker: BinanceTradeTicker
    
    let isBlue = UserDefaults.standard.bool(forKey: UserDefault.colorKey)
    
    var time: String {
        let utcTimestamp = ticker.tradeTime / 1000
        let date = Date(timeIntervalSince1970: TimeInterval(utcTimestamp))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }

    var price: String {
        return ticker.price
    }
    
    var quantity: String {
        return ticker.quantity
    }
    
    var amount: String {
        let amount = (Decimal(string: ticker.price) ?? 0) * (Decimal(string: ticker.quantity) ?? 0)
        let decimalNumber = NSDecimalNumber(decimal: amount)
        let integerAmount = decimalNumber.intValue
        return String(describing: integerAmount)
    }
    
    var buy: UIColor {
        return isBlue ? .systemRed : .systemGreen
    }
    
    var sell: UIColor {
        return isBlue ? .systemBlue : .systemRed
    }
}
