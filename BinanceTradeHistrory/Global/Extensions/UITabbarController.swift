//
//  UITabbarController.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/06/26.
//

import UIKit

extension UITabBarController {
    func makeAlert(title: String,
                   message: String,
                   okAction: ((UIAlertAction) -> Void)? = nil,
                   completion : (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertViewController = UIAlertController(title: title,
                                                        message: message,
                                                        preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: okAction)
            alertViewController.addAction(okAction)
            
            self.present(alertViewController, animated: true, completion: completion)
        }
    }
    
    func makeRequestAlert(title: String,
                          message: String,
                          okTitle: String = "확인",
                          cancelTitle: String = "취소",
                          okAction: ((UIAlertAction) -> Void)?,
                          cancelAction: ((UIAlertAction) -> Void)? = nil,
                          completion : (() -> Void)? = nil) {
        
        let alertViewController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelTitle,
                                         style: .default,
                                         handler: cancelAction)
        
        let okAction = UIAlertAction(title: okTitle,
                                     style: .destructive,
                                     handler: okAction)
        
        [cancelAction, okAction].forEach { action in
            alertViewController.addAction(action)
        }
        
        self.present(alertViewController, animated: true, completion: completion)
    }
    
    func makeActionSheet(title: String? = nil,
                         message: String? = nil,
                         actionTitles:[String?],
                         actionStyle:[UIAlertAction.Style],
                         actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .actionSheet)
        
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title,
                                       style: actionStyle[index],
                                       handler: actions[index])
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}

