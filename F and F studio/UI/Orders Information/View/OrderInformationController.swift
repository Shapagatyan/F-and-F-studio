//
//  OrderInformationController.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 05.10.22.
//

import UIKit

class OrderInformationController: ViewController {
    // MARK: - Views
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var cardTextField: TextField!
    @IBOutlet private var typeTextField: TextField!
    @IBOutlet private var nameTextField: TextField!
    @IBOutlet private var countTextField: TextField!
    @IBOutlet private var priceTextField: TextField!
    @IBOutlet private var phoneTextField: TextField!
    @IBOutlet private var adressTextField: TextField!
    @IBOutlet private var commentTextField: TextField!
    @IBOutlet private var selfPriceTextField: TextField!

    // MARK: - Properties
    var order: Order?
    let imagePicker = UIImagePickerController()

    // MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension OrderInformationController {
    // MARK: - Setup UI
    override func setupUI() {
        super.setupUI()
        setData()
        changeDate()
        setupViews()
        setupNavBar()
        setImagePicker()
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
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 15
    }

    func setupViews() {
        imageView.layer.cornerRadius = 15
    }

    func setupNavBar() {
        title = "Edit"
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveAction(_:))), animated: false)
    }

    // MARK: - Set Data
    func setData() {
        let textFieldArray: [TextField] = [adressTextField, phoneTextField, cardTextField, typeTextField, nameTextField, countTextField, priceTextField, selfPriceTextField, commentTextField]

        guard let order = self.order else { return }

        imageView.image = order.image
        nameTextField.text = order.name
        typeTextField.text = order.type
        cardTextField.text = order.card
        nameTextField.text = order.name
        phoneTextField.text = order.phone
        adressTextField.text = order.adress
        commentTextField.text = order.comment
        datePicker.date = order.orderDeliverDate
        countTextField.text = String(order.count)
        priceTextField.text = String(order.price).currencyInputFormatting()
        selfPriceTextField.text = String(order.selfPrice).currencyInputFormatting()

        for textField in textFieldArray {
            textField.autocapitalizationType = .words
            if textField.text != "", textField.text != " " {
                textField.placeholder = .none
            }
        }
    }
}

// MARK: - Setup UI
extension OrderInformationController {
    @objc func saveAction(_ sender: UIBarButtonItem) {
        guard let order = self.order else { return }
        let date = Int(datePicker.date.timeIntervalSince1970)
        RealmManager.shared.updateModel(order, image: imageView.image, date: date, adress: adressTextField.text, name: nameTextField.text, phone: phoneTextField.text, card: cardTextField.text, type: typeTextField.text, count: Int(countTextField.text ?? "") ?? 1, price: priceTextField.text?.toInt ?? 0, selfprice: selfPriceTextField.text?.toInt ?? 0, comment: commentTextField.text)

        callAlert(title: "Удачно", message: "Заказ редактирован") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

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

// MARK: - Delegates
extension OrderInformationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFields Delegates
extension OrderInformationController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = (textField.text ?? "") as NSString
        let text = oldText.replacingCharacters(in: range, with: string) as String

        switch textField {
        case cardTextField:
            cardTextField.text = text
        case typeTextField:
            typeTextField.text = text
        case nameTextField:
            nameTextField.text = text
        case countTextField:
            countTextField.text = text
        case adressTextField:
            adressTextField.text = text
        case commentTextField:
            commentTextField.text = text
        case priceTextField:
            priceTextField.text = text.currencyInputFormatting()
        case selfPriceTextField:
            selfPriceTextField.text = text.currencyInputFormatting()
        case phoneTextField:
            phoneTextField.text = setPhoneNumberMask(textField: phoneTextField, mask: "+X (XXX) XXX-XX-XX", string: string, range: range)
        default:
            break
        }
        return false
    }
}
