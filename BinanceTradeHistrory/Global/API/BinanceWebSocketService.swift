//
//  BinanceWebSocketService.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/05/30.
//

import Foundation
import Combine

class BinanceWebSocketService: NSObject {
    
    static let shared = BinanceWebSocketService()
    
    private override init() {}
    
    @Published var isConnected = false
    
    let tickerSubject = CurrentValueSubject<BinanceTradeTicker?, Never>(nil)
    var ticker: BinanceTradeTicker? { tickerSubject.value }
    
    let currentCoinSubject = CurrentValueSubject<String?, Never>(nil)
    
    private var webSocket: URLSessionWebSocketTask?
    
    func connect() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string: "wss://fstream.binance.com/ws")!
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
    }
    
    func send(withSymbol symbol: String?) {
        guard let symbol = symbol else { return print("심볼 없음")}
        
        if let currentSymbol = currentCoinSubject.value {
            // Unsubscribe from the current symbol
            let unsubscribeStream = "\(currentSymbol.lowercased())@aggTrade"
            let unsubscribeMessage = """
                {"method": "UNSUBSCRIBE", "params": ["\(unsubscribeStream)"], "id": 1}
                """
            webSocket?.send(.string(unsubscribeMessage), completionHandler: { error in
                if let error = error {
                    print("Binance unsubscribe error: \(error.localizedDescription)")
                }
            })
        }
        
        currentCoinSubject.send(symbol)
        
        let stream = "\(symbol.lowercased())@aggTrade"
        let message = """
        {"method": "SUBSCRIBE", "params": ["\(stream)"], "id": 1}
        """
        webSocket?.send(.string(message), completionHandler: { error in
            if let error = error {
                print("Binance send error: \(error.localizedDescription)")
            }
        })
        print(message)
    }
    
    private func receive() {
        webSocket?.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    //                    print("Received text message: \(text)")
                    if let data = text.data(using: .utf8) {
                        self.onReceiveData(data)
                    }
                default: break
                }
                self.receive()
                
            case .failure(let error):
                print("Failed to receive message: \(error.localizedDescription)")
            }
        }
    }
    
    private func onReceiveData(_ data: Data) {
        DispatchQueue.global(qos: .background).async {
            guard let ticker = try? JSONDecoder().decode(BinanceTradeTicker.self, from: data) else { return }
            
            let amount = (Decimal(string: ticker.price) ?? 0) * (Decimal(string: ticker.quantity) ?? 0)
            let decimalNumber = NSDecimalNumber(decimal: amount)
            let integerAmount = decimalNumber.intValue
            
            guard integerAmount > self.fetchUserAmount() else { return }
            
            self.tickerSubject.send(ticker)
        }
    }
    
    private func fetchUserAmount() -> Int {
        guard let numberString = UserDefaults.standard.string(forKey: "AmountKey") else { return 0 }
        let formattedString = numberString.replacingOccurrences(of: ",", with: "")
        if let number = Int(formattedString) {
            return number
        } else {
            return 0
        }
    }
    
    func close() {
        webSocket?.cancel(with: .goingAway, reason: nil)
        webSocket = nil
    }
}

// MARK: - URLSessionWebSocketDelegate

extension BinanceWebSocketService: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Binance websocket connection opened.")
        isConnected = true
        if let currentSymbol = currentCoinSubject.value {
            send(withSymbol: currentSymbol)
        } else {
            send(withSymbol: "BTCUSDT")
        }
        receive()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Binance websocket connection closed.")
        isConnected = false
    }
}

