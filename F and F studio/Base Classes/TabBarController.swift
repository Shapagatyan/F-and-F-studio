//
//  TabBarController.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 29.09.22.
//

import UIKit
import Foundation

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = .black

        let ordersController = ActiveOrderController()
        ordersController.tabBarItem = UITabBarItem(title: "Заказы", image: UIImage(systemName: "list.bullet"), selectedImage: nil)

        let historyController = OrderHistoryController()
        historyController.tabBarItem = UITabBarItem(title: "История", image: UIImage(systemName: "clock"), selectedImage: nil)

        setViewControllers([
            NavigationController(rootViewController: ordersController),
            NavigationController(rootViewController: historyController)
        ], animated: false)
    }

}
