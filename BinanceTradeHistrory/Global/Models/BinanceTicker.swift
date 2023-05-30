//
//  BinanceTicker.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/05/30.
//

import Foundation

struct BinanceTicker: Codable {
    let eventTime: TimeInterval
    let tradeTime: TimeInterval
    let symbol: String
    let price: String
    let quantity: String
    let trade: Bool
    let tradeId: Int
    
    enum CodingKeys: String, CodingKey {
        case eventTime = "E"
        case tradeTime = "T"
        case symbol = "s"
        case price = "p"
        case quantity = "q"
        case trade = "m"
        case tradeId = "a"
    }
}
