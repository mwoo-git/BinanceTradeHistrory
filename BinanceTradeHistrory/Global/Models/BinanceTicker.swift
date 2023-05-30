//
//  BinanceTicker.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/05/30.
//

import Foundation

struct BinanceTicker: Codable {
    let tradeTime: TimeInterval
    let symbol: String
    let price: String
    let quantity: String
    let trade: Bool
    
    var timestamp: Date {
            let utcTimestamp = tradeTime / 1000
            let utcOffset = TimeZone.current.secondsFromGMT()
            let koreanTimestamp = utcTimestamp + TimeInterval(utcOffset) + 9 * 3600
            return Date(timeIntervalSince1970: koreanTimestamp)
        }
        
        var decimalPrice: Decimal {
            return Decimal(string: price) ?? 0
        }
        
        var decimalQuantity: Decimal {
            return Decimal(string: quantity) ?? 0
        }
        
        var tradeAmount: Decimal {
            return decimalPrice * decimalQuantity
        }
    
    enum CodingKeys: String, CodingKey {
        case tradeTime = "T"
        case symbol = "s"
        case price = "p"
        case quantity = "q"
        case trade = "m"
    }
}
