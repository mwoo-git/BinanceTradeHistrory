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
    
    let tickerSubject = CurrentValueSubject<BinanceTicker?, Never>(nil)
    var ticker: BinanceTicker? { tickerSubject.value }
    
    private var webSocket: URLSessionWebSocketTask?
    
    func connect() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string: "wss://fstream.binance.com/ws")!
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
    }
    
    func send() {
        let symbol = "BTCUSDT"
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
            guard let ticker = try? JSONDecoder().decode(BinanceTicker.self, from: data) else {
                return print("BinanceTicker 객체 생성 에러")
            }
            
            let amount = (Decimal(string: ticker.price) ?? 0) * (Decimal(string: ticker.quantity) ?? 0)
            guard amount > 100000 else { return }
            print(ticker)
            self.tickerSubject.send(ticker)
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
        send()
        receive()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Binance websocket connection closed.")
        isConnected = false
    }
}

