//
//  OrderHistoryController.swift
//  F and F studio
//
//  Created by Анна Шапагатян on 29.09.22.
//

import UIKit

class OrderHistoryController: ViewController {
    // MARK: - Views
    @IBOutlet var tableView: UITableView!

    // MARK: - Properties
    private let viewModel = OrderHistoryViewModel()
    typealias DataSource = UITableViewDiffableDataSource<HistoryOrderSection, Order>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HistoryOrderSection, Order>

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

// MARK: - Setup Bindings
extension OrderHistoryController {
    override func setupBindings() {
        viewModel.$hisOrders.delay(for: 0.05, scheduler: RunLoop.main).sink { [weak self] models in
            guard let `self` = self else { return }
            var snapshot = Snapshot()
            let sections = models.map { $0.section }
            snapshot.appendSections(sections)
            models.forEach { snapshot.appendItems($0.orders, toSection: $0.section) }
            self.dataSource.applySnapshotUsingReloadData(snapshot)
        }.store(in: &cancellable)
    }
}

// MARK: - Setup UI
extension OrderHistoryController {
    override func setupUI() {
        super.setupUI()
        title = "История"
        tableView.registerCell(cellType: OrdersTableViewCell.self)
        tableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: TableHeader.name)
    }
}

// MARK: - UITableView delegate
extension OrderHistoryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeader.name) as! TableHeader
        header.setData(model: viewModel.hisOrders[section].section)
        return header
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = OrderInformationController()
        controller.order = viewModel.hisOrders[indexPath.section].orders[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [self] _, _, completionHandler in
            RealmManager.shared.delete(viewModel.hisOrders[indexPath.section].orders[indexPath.row])
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor(hex: "#ed6161")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let checkMark = UIContextualAction(style: .destructive, title: nil) { [self] _, _, completionHandler in
            RealmManager.shared.markOrderUnFinished(order: viewModel.hisOrders[indexPath.section].orders[indexPath.row], finished: false)
            completionHandler(true)
        }
        checkMark.backgroundColor = UIColor(hex: "#ed6161")
        checkMark.image = UIImage(systemName: "checkmark.circle")
        let configuration = UISwipeActionsConfiguration(actions: [checkMark])
        return configuration
    }
}
