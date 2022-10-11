//
//  Int extension.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 04.10.22.
//

import Foundation

extension Int {
    var string: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = ","
        numberFormatter.decimalSeparator = "."
        return numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
    }
}
