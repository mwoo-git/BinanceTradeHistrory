//
//  BinanceTicker.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/05/30.
//

import Foundation

// MARK: - Socket

struct BinanceTradeTicker: Codable {
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

// MARK: - fetchCoins

struct BinanceExchangeInfo: Codable {
    let symbols: [BinanceCoin]
}

struct BinanceCoin: Codable {
    let symbol: String
    let baseAsset: String
    let quoteAsset: String
    let status: String
}

// MARK: - fetchTickers

struct BinanceTicker: Decodable {
    let market: String
    let kline: BinanceKline
    
    var changeRate: Double {
        guard let openPrice = Double(kline.open),
              let closePrice = Double(kline.close) else { return 0 }
        
        return ((closePrice - openPrice) / openPrice) * 100
    }
    
    var volume: Double {
        guard let closePrice = Double(kline.close),
              let volume = Double(kline.volume) else { return 0 }
        
        return closePrice * volume
    }
}

// MARK: - Kline

struct BinanceKline: Codable {
    let openTime: Int
    let open: String
    let high: String
    let low: String
    let close: String
    let volume: String
    let closeTime: Int
    let quoteVolume: String
    let trades: Int
    let buyAssetVolume: String
    let buyQuoteVolume: String
    let ignored: String
    
    init(from decoder: Decoder) throws {
        var values = try decoder.unkeyedContainer()
        self.openTime = try values.decode(Int.self)
        self.open = try values.decode(String.self)
        self.high = try values.decode(String.self)
        self.low = try values.decode(String.self)
        self.close = try values.decode(String.self)
        self.volume = try values.decode(String.self)
        self.closeTime = try values.decode(Int.self)
        self.quoteVolume = try values.decode(String.self)
        self.trades = try values.decode(Int.self)
        self.buyAssetVolume = try values.decode(String.self)
        self.buyQuoteVolume = try values.decode(String.self)
        self.ignored = try values.decode(String.self)
    }
}




