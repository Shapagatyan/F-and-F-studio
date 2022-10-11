//
//  NSObject extension.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 18.03.22.
//

import Foundation

extension NSObject {
    class var name: String {
        return String(describing: self)
        
    }
}
