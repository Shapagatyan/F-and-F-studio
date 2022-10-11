//
//  ActiveOrderViewModel.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 20.03.22.
//

import Combine
import UIKit

class ActiveOrderViewModel: ViewModel {
    @Published private(set) var orders: [Order] = []
}

extension ActiveOrderViewModel {
    override func setupBindings() {
        RealmManager.shared.$orders.sink { [weak self] orders in
            self?.orders = orders.filter { !$0.finished }.sorted(by: { $0.deliverydate < $1.deliverydate })
        }.store(in: &cancellable)
    }
}

enum TableSection: Int, Hashable {
    case main
}
