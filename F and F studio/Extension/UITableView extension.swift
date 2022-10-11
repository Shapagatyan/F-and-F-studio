//
//  UITable View Cell Register.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 20.03.22.
//

import Foundation
import UIKit

extension UITableView {
    
    func registerCell(cellType: UITableViewCell.Type) {
        self.register(UINib(nibName: cellType.name, bundle: nil), forCellReuseIdentifier: cellType.name)
    }
    
}
