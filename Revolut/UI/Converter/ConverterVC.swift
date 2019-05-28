//
//  ConverterVC.swift
//  Revolut
//
//  Created by Igor Shvetsov on 04/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation
import UIKit

typealias RArray<T> = ReferenceProxy<[T]>

protocol ConverterView: UIResponder {
    func setup(with models: RArray<Currency>)
    func update()
    func reload()
    func showLoader(_ visible: Bool)
}

class ConverterVC: UIViewController, StoryboardBased {
    
    @IBOutlet private weak var tableView: UITableView!
    
    // 'presenter' is force unwrapped to fail fast (to know that Presenter isn't assigned)
    private var presenter: ConverterPresenter!
    private var tableViewManager: ConverterTableViewManager<Currency, CurrencyTableViewCell>?
    private let spinner = UIActivityIndicatorView(style: .gray)
    private let rateService = NetworkRateService()
    
    private var cellConfigurator:  (Currency, CurrencyTableViewCell) -> Void {
        return { currency, cell in
            
            let vm = CurrencyTableViewCellVM(
                imageName: currency.name.lowercased(),
                title: currency.name,
                subtitle: "",
                value: String(format: "%.2f", currency.value),
                action: { [weak self] value in
                    self?.presenter.didChangeConverting(value: value)
                }
            )
            cell.configureWith(cellVM: vm)
            cell.isHighlighted = false
        }
    }
    
    // MARK: Configuration
    
    func configure(presenter: ConverterPresenter) {
        self.presenter = presenter
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension ConverterVC {
    
    private func setupTableView(with models: RArray<Currency>) {
        
        let datasource = TableViewDataSource(models: models, cellConfigurator: cellConfigurator)
        tableViewManager = ConverterTableViewManager(tableView: tableView, datasource: datasource) { tableView in
            tableView.rowHeight = 100.0
            tableView.keyboardDismissMode = .onDrag
            tableView.register(CurrencyTableViewCell.self)
        }
    }
}

extension ConverterVC: ConverterView {
    
    func setup(with models: RArray<Currency>) {
        setupTableView(with: models)
    }
    
    func update() {
        tableViewManager?.updateVisibleView()
    }
    
    func reload() {
        tableViewManager?.reloadData()
    }
    
    func showLoader(_ visible: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = visible
        }
    }
}

extension ConverterVC: ErrorHandable {
    
}
