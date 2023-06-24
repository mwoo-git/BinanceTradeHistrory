//
//  BinanceTickerViewModel.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/06/05.
//

import UIKit

struct TickerViewModel {
    let ticker: BinanceTicker
    
    let isBlue = UserDefaults.standard.bool(forKey: UserDefault.colorKey)
    
    var market: String {
        return ticker.market
    }
    
    var price: String {
        return ticker.kline.close
    }
    
    var changeRate: String {
        return String(format: "%.2f%%", ticker.changeRate)
    }
    
    var volume: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        let suffixes = ["", "K", "M", "B", "T"]
        var value = ticker.volume
        var suffixIndex = 0
        
        while value >= 1000 && suffixIndex < suffixes.count - 1 {
            value /= 1000
            suffixIndex += 1
        }
        
        let formattedValue = numberFormatter.string(from: NSNumber(value: value)) ?? ""
        return "\(formattedValue)\(suffixes[suffixIndex])"
    }
    
    var symbol: String {
        return ticker.market
    }
    
    var buy: UIColor {
        return isBlue ? .systemRed : .systemGreen
    }
    
    var sell: UIColor {
        return isBlue ? .systemBlue : .systemRed
    }
    
    init(ticker: BinanceTicker) {
        self.ticker = ticker
    }
}
