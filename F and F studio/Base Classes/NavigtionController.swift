//
//  NavigtionController.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 29.09.22.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        navigationBar.tintColor = .black
        navigationBar.backgroundColor = .clear
    }
}

// MARK: - Navigation controller delegate
extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
    }
}
