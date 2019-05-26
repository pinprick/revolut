//
//  TableVIewDataSource.swift
//  Revolut
//
//  Created by Igor Shvetsov on 04/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation
import UIKit

class TableViewDataSource<Model, CellType>: NSObject, UITableViewDataSource where CellType: UITableViewCell {
    typealias CellConfigurator = (Model, CellType) -> Void
    typealias Source = ReferenceProxy<[Model]>
    
    var models: ReferenceProxy<[Model]>
    private let cellConfigurator: CellConfigurator
    
    init(models: Source,
         cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.cellConfigurator = cellConfigurator
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return models.value.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models.value[indexPath.row]
        let cell = tableView.dequeueCell(CellType.self, indexPath: indexPath) as? CellType
        
        guard let currentCell = cell else {
            fatalError("Cell type is wrong!")
        }

        cellConfigurator(model, currentCell)
        
        return currentCell
    }
}
