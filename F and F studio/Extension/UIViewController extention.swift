//
//  UIViewController extention.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 06.10.22.
//

import Foundation
import UIKit

extension UIViewController {
     func setPhoneNumberMask(textField: UITextField, mask: String, string: String, range: NSRange) -> String {
        let text = textField.text ?? ""
        let phone = (text as NSString).replacingCharacters(in: range, with: string)
        let number = phone.replacingOccurrences(of: "[^0-9]",
                                                with: "",
                                                options: .regularExpression)
        var result = ""
        var index = number.startIndex

        for character in mask where index < number.endIndex {
            if character == "X" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(character)
            }
        }

        if result.count == 18 {
            textField.layer.borderWidth = 1.0
            textField.placeholder = "Phone is valid"
            textField.layer.borderColor = UIColor(hex: "#227F23").cgColor
        } else {
            textField.layer.borderWidth = 1.0
            textField.placeholder = "Phone is not valid"
            textField.layer.borderColor = UIColor(hex: "#EA1F1F").cgColor
        }
        return result
    }
}


