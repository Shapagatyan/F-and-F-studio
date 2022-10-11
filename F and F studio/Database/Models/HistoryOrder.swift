//
//  HistoryOrder.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 29.09.22.
//

import Foundation
import RealmSwift
import UIKit

class HistoryOrder: NSObject {
    let date: Date
    var orders: [Order]
    lazy var section: HistoryOrderSection = {
        let price = orders.map({$0.price * $0.count }).reduce(0, +)
        let selfPrice = orders.map({$0.selfPrice * $0.count}).reduce(0, +)
        return HistoryOrderSection(date: date, count: orders.count, price: price, selfPrice: selfPrice)
    }()

    internal init(date: Date, orders: [Order]) {
        self.date = date
        self.orders = orders
    }
}

class HistoryOrderSection: NSObject {
    let date: Date
    let count: Int
    let price: Int
    let selfPrice: Int

    internal init(date: Date, count: Int, price: Int, selfPrice: Int) {
        self.date = date
        self.count = count
        self.price = price
        self.selfPrice = selfPrice
    }
}
