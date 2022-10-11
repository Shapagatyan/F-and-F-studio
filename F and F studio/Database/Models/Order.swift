//
//  Order.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 20.03.22.
//

import RealmSwift
import UIKit

class Order: Object {
    @Persisted var type: String?
    @Persisted var name: String?
    @Persisted var card: String?
    @Persisted var phone: String?
    @Persisted var count: Int = 0
    @Persisted var price: Int = 0
    @Persisted var adress: String?
    @Persisted var comment: String?
    @Persisted var imageURL: String?
    @Persisted var createdate = Date()
    @Persisted var selfPrice: Int  = 0
    @Persisted var deliverydate: Int = 0
    @Persisted var finished: Bool = false
    @Persisted var id = UUID().uuidString

    override static func primaryKey() -> String? {
        return "id"
    }

    internal convenience init(deliverydate: Date, adress: String?, name: String?, phone: String?, card: String?, type: String?, count: Int = 1, price: Int = 0, selfPrice: Int = 0, comment: String?, image: UIImage?) {
        
        self.init()
        self.name = name
        self.card = card
        self.type = type
        self.phone = phone
        self.count = count
        self.price = price
        self.adress = adress
        self.comment = comment
        self.changeImage(image)
        self.createdate = Date()
        self.selfPrice = selfPrice
        self.id = UUID().uuidString
        self.deliverydate = Int(deliverydate.timeIntervalSince1970)
    }

    func changeImage(_ image: UIImage?) {
        DocumentManager.shared.saveImage(id: self.id, image: image)
    }

    var image: UIImage? {
        return DocumentManager.shared.getImage(id: self.id)
    }
    
    var orderDeliverDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(deliverydate))
    }
}
