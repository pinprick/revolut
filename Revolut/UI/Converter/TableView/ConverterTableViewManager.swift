//
//  ConverterTableViewManager.swift
//  Revolut
//
//  Created by Igor Shvetsov on 19/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation
import UIKit

class ConverterTableViewManager<Model, CellType>: NSObject, UITableViewDelegate where CellType: UITableViewCell {
    
    private var datasource: TableViewDataSource<Model, CellType>
    private weak var tableView: UITableView!
    
    init(tableView: UITableView, datasource: TableViewDataSource<Model, CellType>, configurator: ((UITableView) -> ())?) {
        self.tableView = tableView
        self.datasource = datasource
        configurator?(tableView)
        super.init()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = datasource
    }
    
    func reloadData() {
        DispatchQueue.main.sync { [weak tableView] in
            tableView?.reloadData()
        }
    }
    
    func updateVisibleView() {
        tableView.indexPathsForVisibleRows?.forEach { indexPath in
            guard indexPath.row != 0 else { return }
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.performBatchUpdates({ [weak self] in
            guard let self = self,
                indexPath.row < self.datasource.models.value.count else { return }
            let model = self.datasource.models.value.remove(at: indexPath.row)
            self.datasource.models.value.insert(model, at: 0)
            
            self.tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        }) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}
