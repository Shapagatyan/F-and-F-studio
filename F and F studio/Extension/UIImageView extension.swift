//
//  UIImageView extension.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 23.09.22.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(imageURL: String) {
        kf.setImage(with: URL(string: imageURL))
    }
}
