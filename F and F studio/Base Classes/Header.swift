//
//  Header.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 30.09.22.
//

import Foundation

import UIKit

class TableHeader: UITableViewHeaderFooterView {
    // MARK: - Views
    private var backView: UIView!
    private var dateLabel: UILabel!
    private var priceLabel: UILabel!
    private var countLabel: UILabel!
    private var profitLabel: UILabel!
    private var stackView: UIStackView!
    private var dateStackView: UIStackView!
    private var priceStackView: UIStackView!

    // MARK: - Properties
    static let height: CGFloat = UITableView.automaticDimension

    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        backgroundColor = .clear
        tintColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
}

// MARK: - Setup UI
private extension TableHeader {
    func setupUI() {
        guard stackView == nil else { return }
        addStackView()

        addDateStackView()
        addDateLabel()
        addCountLabel()

        addPriceStackView()
        addPriceLabel()
        addProfitLabel()
        addBackView()
    }

    // MARK: Stack view
    func addStackView() {
        stackView = UIStackView(frame: .zero)
        contentView.addSubview(stackView)
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    // MARK: Date stack
    func addDateStackView() {
        dateStackView = UIStackView(frame: .zero)
        stackView.addArrangedSubview(dateStackView)
        dateStackView.spacing = 4
        dateStackView.axis = .vertical
        dateStackView.alignment = .center
        dateStackView.distribution = .fill
    }

    // MARK: Date label
    func addDateLabel() {
        dateLabel = UILabel(frame: .zero)
        dateStackView.addArrangedSubview(dateLabel)
        dateLabel.textColor = UIColor(hex: "145a32")
        dateLabel.font = UIFont.boldSystemFont(ofSize: 16)
    }

    // MARK: Count label
    func addCountLabel() {
        countLabel = UILabel(frame: .zero)
        dateStackView.addArrangedSubview(countLabel)
        countLabel.textColor = .black
        countLabel.font = UIFont.systemFont(ofSize: 10)
    }

    // MARK: Price stack
    func addPriceStackView() {
        priceStackView = UIStackView(frame: .zero)
        stackView.addArrangedSubview(priceStackView)
        priceStackView.alignment = .fill
        priceStackView.axis = .horizontal
        priceStackView.distribution = .fillEqually
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        priceStackView.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }

    func addBackView() {
        backView = GradienView()
        contentView.insertSubview(backView, at: 0)
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.topAnchor.constraint(equalTo: priceStackView.topAnchor).isActive = true
        backView.bottomAnchor.constraint(equalTo: priceStackView.bottomAnchor).isActive = true
        backView.leftAnchor.constraint(equalTo: priceStackView.leftAnchor, constant: 4).isActive = true
        backView.rightAnchor.constraint(equalTo: priceStackView.rightAnchor, constant: -4).isActive = true
    }

    // MARK: Price label
    func addPriceLabel() {
        priceLabel = UILabel(frame: .zero)
        priceStackView.addArrangedSubview(priceLabel)
        priceLabel.textColor = .white
        priceLabel.textAlignment = .center
        priceLabel.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    }

    // MARK: Profit label
    func addProfitLabel() {
        profitLabel = UILabel(frame: .zero)
        priceStackView.addArrangedSubview(profitLabel)
        profitLabel.textColor = .white
        profitLabel.textAlignment = .center
        profitLabel.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    }
}

// MARK: - Public methods
extension TableHeader {
    func setData(model: HistoryOrderSection) {
        let dateString = model.date.string(format: "MMM yyyy" + "г.")
        dateLabel.text = dateString.firstUppercased
        countLabel.text = {
            if model.count == 1 {
                return "\(model.count) продукт"
            } else if model.count == 2 || model.count == 3 || model.count == 4 {
                return "\(model.count) продуктa"
            } else {
                return "\(model.count) продуктов"
            }
        }()
        priceLabel.text = String(model.price).currencyInputFormatting()
        profitLabel.text = String(model.price - model.selfPrice).currencyInputFormatting()
    }
}
