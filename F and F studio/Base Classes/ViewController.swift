//
//  ViewController.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 18.03.22.
//

import Combine
import UIKit

class ViewController: UIViewController {
    var cancellable: Set<AnyCancellable> = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        startup()
        setupBindings()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        setupBindings()
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension ViewController {
    @objc func setupUI() {
        changeTintColor(to: .black)
    }

    @objc func setupBindings() {}
    @objc func startup() {}
}

extension ViewController {
    func changeTintColor(to color: UIColor) {
        let appearance = navigationController?.navigationBar.standardAppearance
        appearance?.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: color
        ]
        navigationController?.navigationBar.standardAppearance = appearance!
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = color
    }

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ViewController {
    func callAlert(title: String, message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true, completion: completion)
        }

        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
