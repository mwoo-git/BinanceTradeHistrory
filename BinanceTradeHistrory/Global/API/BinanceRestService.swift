//
//  BinanceRestService.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/06/05.
//

import Foundation

struct BinanceRestService {
    static func fetchCoins() async throws -> [BinanceCoin] {
        let baseUrl = "https://api.binance.com/api/v3"
        let url = URL(string: "\(baseUrl)/exchangeInfo")!
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw NSError(domain: "Server Error", code: 0, userInfo: nil)
            }
            
            let binanceExchangeInfo = try JSONDecoder().decode(BinanceExchangeInfo.self, from: data)
            let filteredSymbols = binanceExchangeInfo.symbols.filter { $0.quoteAsset == "USDT" && $0.status == "TRADING" }
            let binanceCoins = filteredSymbols.map { BinanceCoin(symbol: $0.symbol, baseAsset: $0.baseAsset, quoteAsset: $0.quoteAsset, status: $0.status) }
            print(binanceCoins.count)
            return binanceCoins
        } catch {
            print("DEBUG: BinanceCoinDataService.fetchCoins() failed. \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchTickers(withCoins coins: [BinanceCoin]) async throws -> [BinanceTicker] {
        let symbols = coins.map { $0.symbol }
        var tickers: [BinanceTicker] = []
        for symbol in symbols {
            let urlString = "https://api.binance.com/api/v3/klines?symbol=\(symbol)&interval=1d&limit=1"
            guard let url = URL(string: urlString) else { continue }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let candle = try JSONDecoder().decode(BinanceCandlestick.self, from: data)
                let ticker = BinanceTicker(market: symbol, candle: candle)
                tickers.append(ticker)
            } catch {
                print("Error fetching ticker for symbol \(symbol): \(error.localizedDescription)")
            }
        }
        print(tickers)
        return tickers
    }

}
