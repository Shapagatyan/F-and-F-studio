//
//  ViewModel.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 20.03.22.
//

import Combine
import UIKit

class ViewModel: NSObject {
    var cancellable: Set<AnyCancellable> = []
    override init() {
        super.init()
        setupBindings()
    }
}

extension ViewModel {
    @objc func setupBindings() {}
}
