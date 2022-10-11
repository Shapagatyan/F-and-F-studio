//
//  OrderHistoryViewModel.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 29.09.22.
//

import Foundation

class OrderHistoryViewModel: ViewModel {
    @Published private(set) var hisOrders: [HistoryOrder] = []
}

extension OrderHistoryViewModel {
    override func setupBindings() {
        RealmManager.shared.$orders.sink { [weak self] orders in
            let orders = orders.filter { $0.finished }.sorted(by: { $0.deliverydate < $1.deliverydate })
            var hisOrders: [HistoryOrder] = []

            for order in orders {
                if let section = hisOrders.last, Calendar.current.compare(order.orderDeliverDate, to: section.date, toGranularity: .month) == .orderedSame {
                    section.orders.append(order)
                } else {
                    hisOrders.append(HistoryOrder(date: order.orderDeliverDate, orders: [order]))
                }
            }

            self?.hisOrders = hisOrders
        }.store(in: &cancellable)
    }
}
