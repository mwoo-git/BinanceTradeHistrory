//
//  Notification.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/06/25.
//

import Foundation

struct Notification {
    // MARK: - Post
    static func post(withName name: String) {
        NotificationCenter.default.post(name: NSNotification.Name(name), object: nil)
    }
    
    // MARK: - Setting
    static let colorChanged = "ColorChanged"
    static let amountChanged = "AmountChanged"
    
    // MARK: - Rest API
    static let restApiStatusError = "RestApiStatusError"
    
    // MARK: - Socket API
    static let socketApiStatusError = "SocketApiStatusError"
}
