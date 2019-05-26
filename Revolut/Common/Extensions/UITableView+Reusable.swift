//
//  UITableView+Reusable.swift
//  Revolut
//
//  Created by Igor Shvetsov on 22/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        let identifier = String(describing: T.self)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    func dequeueCell<T: UITableViewCell>(_: T.Type, indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: T.self)
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        return cell
    }
}
