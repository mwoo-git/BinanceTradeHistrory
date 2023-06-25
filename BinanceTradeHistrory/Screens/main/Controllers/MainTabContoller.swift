//
//  MainTabContoller.swift
//  BinanceTradeHistrory
//
//  Created by Mac on 2023/05/30.
//

import UIKit

class MainTabController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        obserber()
        configureViewController()
    }
    
    // MARK: - API
    
    // MARK: - Helpers
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        
        let controller = CoinListController()
        let coinlist = templateNavigationController(unselectedImage: UIImage(named: "home_unselected")!, selectedImage: UIImage(named: "home_selected")!, rootViewController: controller)
        controller.mainTabController = self
        
        let history = templateNavigationController(unselectedImage: UIImage(named: "like_unselected")!, selectedImage: UIImage(named: "like_selected")!, rootViewController: TradeHistoryController())
        
        
        viewControllers = [coinlist, history]
        
        tabBar.isTranslucent = true
        
    }
    
    func obserber() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleRestStatusError), name: NSNotification.Name(Notification.restApiStatusError), object: nil)
    }
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        return nav
    }
    
    // MARK: - Actions
    
    @objc func handleRestStatusError() {
        makeAlert(title: "바이낸스 네트워크 에러", message: "바이낸스 코인 데이터를 받아오지 못 했습니다. 잠시 후에 다시 시도해주세요.")
    }
}
