//
//  TextField.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 09.04.22.
//

import UIKit

class TextField: UITextField {
    let label: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        label.textColor = UIColor(white: 0, alpha: 0.2)
        label.alpha = 1
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private var textObserver: NSKeyValueObservation?
    
    override var placeholder: String? {
        set {
            label.text = newValue
        }
        get {
            return label.text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    deinit {
        textObserver?.invalidate()
        textObserver = nil
    }
    
    func setupUI() {
        addPlaceholderLabel()
        
        label.text = super.placeholder
        super.placeholder = nil
        
        addTarget(self, action: #selector(textChanged), for: .editingChanged)
        textObserver = observe(\.text, options: [.initial, .new]) { [weak self] _, _ in
            self?.textChanged()
        }
    }
    
    @objc func textChanged() {
        guard let text = text else { return }
        
        if text.isEmpty, label.transform != .identity {
            UIView.animate(withDuration: 0.2) {
                self.label.transform = .identity
                self.layoutIfNeeded()
            }
        } else if !text.isEmpty, label.transform == .identity {
            let startHeight = ceil(label.font.lineHeight)
            let endHeight = ceil(UIFont.systemFont(ofSize: 10).lineHeight)
            let scale = endHeight / startHeight

            let startWidth = label.frame.width
            let endWidth = startWidth * scale
            let offsetX = (endWidth - startWidth) / 2

            let availableTopHeight = (frame.height - label.font.lineHeight) / 2
            let finalY = availableTopHeight / 2
            let offsetY = finalY - label.frame.midY

            let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
            let translationTransform = CGAffineTransform(translationX: offsetX, y: offsetY)
            let transform = scaleTransform.concatenating(translationTransform)
            
            UIView.animate(withDuration: 0.2) {
                self.label.transform = transform
                self.layoutIfNeeded()
            }
        }
    }
    
    private func addPlaceholderLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 7),
            label.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -7)
        ])
    }
}
 
