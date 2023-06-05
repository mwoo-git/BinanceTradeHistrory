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

    /// 바이낸스 350여개의 코인의 정보를 병렬로 가져오는 함수
    static func fetchTickers(withCoins coins: [BinanceCoin]) async throws -> [BinanceTicker] {
        let symbols = coins.map { $0.symbol }
        var tickers: [BinanceTicker] = []
    
        let chunkSize = 10
        let numChunks = (symbols.count + chunkSize - 1) / chunkSize

        await withTaskGroup(of: [BinanceTicker].self) { group in
            for chunkIndex in 0..<numChunks {
                let startIndex = chunkIndex * chunkSize
                let endIndex = min(startIndex + chunkSize, symbols.count)
                let symbolChunk = Array(symbols[startIndex..<endIndex])

                group.addTask {
                    return await fetchTickersInParallel(symbolChunk)
                }
            }

            for await chunkResult in group {
                tickers.append(contentsOf: chunkResult)
            }
        }

        print(tickers.count)
        return tickers
    }

    static func fetchTickersInParallel(_ symbols: [String]) async -> [BinanceTicker] {
        var tickers: [BinanceTicker] = []
        
        for symbol in symbols {
            let urlString = "https://api.binance.com/api/v3/klines?symbol=\(symbol)&interval=1d&limit=1"
            guard let url = URL(string: urlString) else { continue }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let klines = try JSONDecoder().decode([BinanceKline].self, from: data)
                if let klineData = klines.first {
                    let ticker = BinanceTicker(market: symbol, kline: klineData)
                    tickers.append(ticker)
                }
            } catch {
                print("Error fetching ticker for symbol \(symbol): \(error.localizedDescription)")
            }
        }
        
        return tickers
    }
}
