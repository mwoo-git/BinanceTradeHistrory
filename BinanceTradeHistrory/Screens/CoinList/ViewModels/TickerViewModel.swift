//
//  BinanceTickerViewModel.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/06/05.
//

import Foundation

struct TickerViewModel {
    private let ticker: BinanceTicker
    
    var market: String {
        return ticker.market
    }
    
    var price: String {
        return ticker.market
    }
    
    var changeRate: String {
        return ticker.market
    }
    
    var volume: String {
        return ticker.market
    }
    
    var symbol: String {
        return ticker.market
    }
    
    init(ticker: BinanceTicker) {
        self.ticker = ticker
    }
}
