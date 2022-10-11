//
//  RealmManager.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 10.04.22.
//

import Combine
import Foundation
import RealmSwift
import UIKit

class RealmManager {
    
    // MARK: - Properties
    private let realm: Realm
    static let shared = RealmManager()
    private var cancellable = Set<AnyCancellable>()
    @Published private(set) var orders: [Order] = []
    private var orderNotification: NotificationToken?
    
    // MARK: - Init
    private init() {
        let config = Realm.Configuration(schemaVersion: 8)
        realm = try! Realm(configuration: config)

        orderNotification = realm.objects(Order.self).observe(on: .main) { changes in
            switch changes {
            case .initial(let orders):
                self.orders = Array(orders)
            case .update(let orders, _, _, _):
                self.orders = Array(orders)
            case .error(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Functions
    func save(_ model: Object) {
        try! realm.write {
            realm.add(model)
        }
    }

    func delete(_ model: Object) {
        try! realm.write {
            realm.delete(model)
        }
    }

    func updateModel(_ model: Order, image: UIImage?, date: Int, adress: String?, name: String?, phone: String?, card: String?, type: String?, count: Int, price: Int, selfprice: Int, comment: String?) {
        try! realm.write {
            model.name = name
            model.card = card
            model.type = type
            model.count = count
            model.phone = phone
            model.price = price
            model.adress = adress
            model.comment = comment
            model.changeImage(image)
            model.deliverydate = date
            model.selfPrice = selfprice
        }
    }

    func delete(order id: String) {
        guard let model = orders.first(where: { $0.id == id }) else { return }
        try! realm.write {
            realm.delete(model)
        }
    }

    func markOrderUnFinished(order: Order, finished: Bool) {
        order.realm?.beginWrite()
        order.finished = finished
        do {
            try order.realm?.commitWrite()
        } catch {
            print(error.localizedDescription)
        }
    }
}
