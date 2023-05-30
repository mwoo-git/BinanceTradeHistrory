//
//  TradeHistoryCellViewModel.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/05/31.
//

import Foundation

struct TradeHistoryCellViewModel {
    let ticker: BinanceTicker
    
    var time: String {
        let utcTimestamp = ticker.tradeTime / 1000
        let utcOffset = TimeZone.current.secondsFromGMT()
        let koreanTimestamp = utcTimestamp + TimeInterval(utcOffset) + 9 * 3600
        let date = Date(timeIntervalSince1970: koreanTimestamp)
        
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
}
