//
//  CoinListViewModel.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/06/05.
//

import RxSwift
import RxCocoa

enum SortCoins {
    case rise
    case fall
    case volume
}

class CoinListViewModel {
    
    // MARK: - Properties
    
    var coinlist = BehaviorRelay<[TickerViewModel]>(value: [])
    var filterd = BehaviorRelay<[TickerViewModel]>(value: [])
    
    var tickers: [BinanceTicker]? {
        didSet {
            updateCoinlist()
        }
    }
    var coins: [BinanceCoin]? {
        didSet {
            fetchTickers()
        }
    }
    var sort: SortCoins = .volume {
        didSet {
            updateCoinlist()
        }
    }
    
    // MARK: - Init
    
    init() {
        fetchCoins()
    }
    
    // MARK: - RestAPI
    
    func fetchCoins() {
        Task {
            do {
                let coins = try await BinanceRestService.fetchCoins()
                self.coins = coins
            } catch {
                print("DEBUG: fetchCoins() Failed.")
            }
        }
    }
    
    func fetchTickers() {
        Task {
            do {
                guard let coins = coins else { return fetchCoins() }
                let tickers = try await BinanceRestService.fetchTickers(withCoins: coins)
                self.tickers = tickers
            } catch {
                print("DEBUG: fetchTickers() Failed.")
            }
        }
    }
    
    // MARK: - Update
    
    private func updateCoinlist() {
        Task {
            let sortedArray = await sortCoins()
            let viewModels = await convertToViewModels(withTickers: sortedArray)
            
            await MainActor.run {
                self.coinlist.accept(viewModels)
            }
        }
    }
    
    // MARK: - Sort
    
    private func sortCoins() async -> [BinanceTicker] {
        guard let tickers = tickers else { return [] }
        switch sort {
        case .rise:
            return tickers.sorted(by: { $0.signedChangeRate > $1.signedChangeRate })
        case .fall:
            return tickers.sorted(by: { $0.signedChangeRate < $1.signedChangeRate })
        case .volume:
            return tickers.sorted(by: { $0.accTradePrice24H > $1.accTradePrice24H })
        }
    }
    
    // MARK: - Convert
    
    private func convertToViewModels(withTickers tickers: [BinanceTicker]) async -> [TickerViewModel] {
        let viewModels = tickers.compactMap { ticker in
            return TickerViewModel(ticker: ticker)
        }
        return viewModels
    }
}
