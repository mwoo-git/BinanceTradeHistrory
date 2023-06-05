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

// MARK: - Rest_fetchCoin

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
    let candle: BinanceCandlestick
}

// MARK: - CandleStick

struct BinanceCandlestick: Decodable {
    let openTime: TimeInterval
    let openPrice: String
    let highPrice: String
    let lowPrice: String
    let closePrice: String
    let volume: String
    let closeTime: TimeInterval
    let quoteAssetVolume: String
    let trades: Int
    let takerBuyBaseAssetVolume: String
    let takerBuyQuoteAssetVolume: String
    let ignored: String
    
    enum CodingKeys: String, CodingKey {
        case openTime = "0"
        case openPrice = "1"
        case highPrice = "2"
        case lowPrice = "3"
        case closePrice = "4"
        case volume = "5"
        case closeTime = "6"
        case quoteAssetVolume = "7"
        case trades = "8"
        case takerBuyBaseAssetVolume = "9"
        case takerBuyQuoteAssetVolume = "10"
        case ignored = "11"
    }
}




