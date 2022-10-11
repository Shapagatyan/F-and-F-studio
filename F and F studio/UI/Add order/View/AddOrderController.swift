//
//  AddOrderController.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 20.03.22.
//

import Combine
import RealmSwift
import UIKit

class AddOrderController: ViewController {
    // MARK: - Views
    var order = Order()
    let realm = try! Realm()
    let imagePicker = UIImagePickerController()

    // MARK: - Properties
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var nameTextField: TextField!
    @IBOutlet private var cardTextField: TextField!
    @IBOutlet private var typeTextField: TextField!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var itemPicture: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var phoneTextField: TextField!
    @IBOutlet private var countTextField: TextField!
    @IBOutlet private var priceTextField: TextField!
    @IBOutlet private var coastTextField: TextField!
    @IBOutlet private var commentTextField: TextField!
    @IBOutlet private var addressTextField: TextField!
}

// MARK: - Setup UI
extension AddOrderController {
    override func setupUI() {
        super.setupUI()
        changeDate()
        addSaveButton()
        setImagePicker()
    }

    func addSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveOrder))
    }

    func changeDate() {
        datePicker.tintColor = .black
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 6
        datePicker.backgroundColor = .white
        datePicker.layer.borderColor = .none
        datePicker.datePickerMode = .dateAndTime
    }

    func setImagePicker() {
        imagePicker.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnImage(_:)))
        itemPicture.addGestureRecognizer(tapGesture)
        itemPicture.isUserInteractionEnabled = true
        itemPicture.layer.cornerRadius = 15
    }
}

extension AddOrderController {
    // MARK: - Save Order Action
    @objc func saveOrder() {
        if typeTextField.text == "" {
            typeTextField.layer.borderWidth = 1.0
            typeTextField.layer.borderColor = UIColor(hex: "#EA1F1F").cgColor
            callAlert(title: "Ошибка", message: "Заполните обязательные поля")
        } else {
            order = Order(deliverydate: datePicker.date, adress: addressTextField.text, name: nameTextField.text, phone: phoneTextField.text, card: cardTextField.text, type: typeTextField.text, count: Int(countTextField.text ?? "") ?? 1, price: priceTextField.text?.toInt ?? 0, selfPrice: coastTextField.text?.toInt ?? 0, comment: cardTextField.text, image: itemPicture.image ?? UIImage(named: "180"))
            print(order)
            RealmManager.shared.save(order)

            callAlert(title: "Удачно", message: "Заказ зарегестрирован") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    // MARK: - Setup Image Action
    @objc func tapOnImage(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Изображение", message: nil, preferredStyle: .actionSheet)

        let actionPhoto = UIAlertAction(title: "С фотогалереи", style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let actionCamera = UIAlertAction(title: "С камеры", style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        alert.addAction(actionPhoto)
        alert.addAction(actionCamera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableView delegate
extension AddOrderController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            itemPicture.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextField delegate
extension AddOrderController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = (textField.text ?? "") as NSString
        let text = oldText.replacingCharacters(in: range, with: string) as String

        if !text.isEmpty {
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor(hex: "#227F23").cgColor
        } else {
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor(hex: "#EA1F1F").cgColor
        }

        switch textField {
        case nameTextField:
            nameTextField.text = text
        case cardTextField:
            cardTextField.text = text
        case typeTextField:
            typeTextField.text = text
        case countTextField:
            countTextField.text = text
        case addressTextField:
            addressTextField.text = text
        case commentTextField:
            commentTextField.text = text
        case priceTextField:
            priceTextField.text = text.currencyInputFormatting()
        case coastTextField:
            coastTextField.text = text.currencyInputFormatting()
        case phoneTextField:
            phoneTextField.text = setPhoneNumberMask(textField: phoneTextField, mask: "+X (XXX) XXX-XX-XX", string: string, range: range)
        default:
            break
        }
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
