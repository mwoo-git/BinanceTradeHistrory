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
                let coins = try await BinanceRestService.fetchFuturesCoins()
                self.coins = coins
            } catch {
                Notification.post(withName: Notification.restApiStatusError)
                print("DEBUG: fetchCoins() Failed.")
            }
        }
    }
    
    func fetchTickers() {
        Task {
            do {
                guard let coins = self.coins else { return fetchCoins() }
                let tickers = try await BinanceRestService.fetchTickers(withCoins: coins, type: .futures)
                self.tickers = tickers
            } catch {
                Notification.post(withName: Notification.restApiStatusError)
                print("DEBUG: fetchTickers() Failed.")
            }
        }
    }
    
    // MARK: - Update
    
    func updateCoinlist() {
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
            return tickers.sorted(by: { $0.changeRate > $1.changeRate })
        case .fall:
            return tickers.sorted(by: { $0.changeRate < $1.changeRate })
        case .volume:
            return tickers.sorted(by: { $0.volume > $1.volume })
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
