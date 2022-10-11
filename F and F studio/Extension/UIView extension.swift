//
//  UIView extention.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 05.10.22.
//

import UIKit

class GradienView: UIView {
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        self.layer.insertSublayer(layer, at: 0)
        layer.startPoint = self.startPoint
        layer.endPoint = self.endPoint
        layer.colors = self.colors
        layer.type = self.type
        return layer
    }()

    override func draw(_ rect: CGRect) {
        
    }

    public var colors: [CGColor] = [UIColor(hex: "#469d5c").cgColor, UIColor(hex: "#0A1522").cgColor] {
        didSet {
            self.gradientLayer.colors = self.colors
        }
    }

    public var startPoint = CGPoint(x: 0.5, y: 0.2) {
        didSet {
            self.gradientLayer.startPoint = self.startPoint
        }
    }

    public var endPoint = CGPoint(x: 1.7, y: 1.7) {
        didSet {
            self.gradientLayer.endPoint = self.endPoint
        }
    }

    public var type: CAGradientLayerType = .radial {
        didSet {
            self.gradientLayer.type = self.type
        }
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.cornerRadius = 15
        self.gradientLayer.frame = self.bounds
    }
}


