//
//  String extension.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 19.09.22.
//

import Foundation

extension String {
    func currencyInputFormatting() -> String {
        let number = NSNumber(value: (self.replacingOccurrences(of: " ", with: "") as NSString).integerValue)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = "."
        return formatter.string(from: number) ?? self
    }

    var toInt: Int {
        let string = (self.replacingOccurrences(of: " ", with: "") as NSString)
        return string.integerValue
    }

    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst().lowercased()
    }
}
