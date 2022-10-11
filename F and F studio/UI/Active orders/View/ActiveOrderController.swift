//
//  ActiveOrderController.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 18.03.22.
//

import Combine
import UIKit

class ActiveOrderController: ViewController {
    // MARK: - Views
    @IBOutlet private var tableView: UITableView!

    // MARK: - Properties
    private var orders: [HistoryOrder] = []
    private let viewModel = ActiveOrderViewModel()
    typealias Snapshot = NSDiffableDataSourceSnapshot<TableSection, Order>
    typealias DataSource = UITableViewDiffableDataSource<TableSection, Order>

    // MARK: - Data Source
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(tableView: tableView) { [weak self] tableView, _, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdersTableViewCell.name) as! OrdersTableViewCell
            cell.setData(model)
            return cell
        }
        return dataSource
    }()
}

// MARK: - Setup UI
extension ActiveOrderController {
    override func setupUI() {
        super.setupUI()
        setupNavBar()
        setupTableView()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.registerCell(cellType: OrdersTableViewCell.self)
        tableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: TableHeader.name)
    }

    func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddOrderPage))
        title = "Заказы"
    }
}

// MARK: - Setup Binding
extension ActiveOrderController {
    override func setupBindings() {
        viewModel.$orders.sink { [weak self] models in
            guard let `self` = self else { return }
            var snapshot = Snapshot()

            snapshot.appendSections([.main])
            snapshot.appendItems(models)

            self.dataSource.applySnapshotUsingReloadData(snapshot)
        }.store(in: &cancellable)
    }
}

// MARK: - Actions
extension ActiveOrderController {
    @objc func goToAddOrderPage() {
        let controller = AddOrderController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UITextField delegate
extension ActiveOrderController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = OrderInformationController()
        controller.order = viewModel.orders[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [self] _, _, completionHandler in
            RealmManager.shared.delete(order: viewModel.orders[indexPath.row].id)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor(hex: "#ed6161")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let checkMark = UIContextualAction(style: .destructive, title: nil) { [self] _, _, completionHandler in
            RealmManager.shared.markOrderUnFinished(order: viewModel.orders[indexPath.row], finished: true)
            completionHandler(true)
        }
        checkMark.backgroundColor = UIColor(hex: "#6dc96d")
        checkMark.image = UIImage(systemName: "checkmark.circle")
        let configuration = UISwipeActionsConfiguration(actions: [checkMark])
        return configuration
    }
}
