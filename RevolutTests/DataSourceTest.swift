//
//  DataSourceTest.swift
//  RevolutTests
//
//  Created by Igor Shvetsov on 27/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import XCTest

class DataSourceTest: XCTestCase {
    
    var tableView: UITableView! = nil
    var items: [String]! = nil
    var models = ReferenceProxy<[String]>(value: [])
    var dataSource: TableViewDataSource<String, UITableViewCell>! = nil
    var tableViewManager: ConverterTableViewManager<String, UITableViewCell>!

    override func setUp() {
        tableView = UITableView()
        items = ["One", "Two", "Three"]
        models = ReferenceProxy<[String]>(value: items)
        dataSource = TableViewDataSource(models: models, cellConfigurator: { (_, _) in })
        tableViewManager = ConverterTableViewManager(tableView: tableView, datasource: dataSource, configurator: { (tableView) in
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        })
    }

    override func tearDown() {

    }

    func testRowsInSection() {
        let tableView = UITableView()
        let items = ["One", "Two", "Three"]
        let models = ReferenceProxy<[String]>(value: items)
        let dataSource = TableViewDataSource(models: models, cellConfigurator: { (_, _) in
            //
        })
        tableView.dataSource = dataSource
        
        
        let numberOfRows = dataSource.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, items.count)
    }
    
    func testSelectCurrency() {
        let thirdRow = 2
        let thirdIndexPath = IndexPath(row: thirdRow, section: 0)
        tableViewManager.tableView(tableView, didSelectRowAt: thirdIndexPath)
        XCTAssertEqual(items[0], "One")
    }

}
