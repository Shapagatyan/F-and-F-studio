//
//  OrdersTableViewCell.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 18.03.22.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {
    // MARK: - Views
    @IBOutlet private var textLabel1: UILabel!
    @IBOutlet private var textLabel2: UILabel!
    @IBOutlet private var textLabel4: UILabel!
    @IBOutlet private var fotoImageView: UIImageView!

    // MARK: - Actions
    func setData(_ model: Order) {
        textLabel2.text = model.type
        fotoImageView.image = model.image
        selectionStyle = UITableViewCell.SelectionStyle.none
        textLabel1.text = Date(timeIntervalSince1970: TimeInterval(model.deliverydate)).string(format: "dd MMMM HH:mm")
        textLabel4.text = String(model.price * model.count).currencyInputFormatting() + " amd"
    }

    override func layoutSubviews() {
        fotoImageView.layer.cornerRadius = fotoImageView.frame.height / 5
    }
}
