//
//  NSDate extension.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 30.09.22.
//

import Foundation

extension Date {
    func string(format: String? = nil) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format ?? "d MMM HH:mm"
        formatter.locale = Locale(identifier: "ru-RU")
        return formatter.string(from: self)
    }
}

