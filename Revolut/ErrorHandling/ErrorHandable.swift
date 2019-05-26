//
//  ErrorHandable.swift
//  Revolut
//
//  Created by Igor Shvetsov on 22/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation

protocol ErrorHandable {
    func display(error: Error)
}

extension ErrorHandable {
    func display(error: Error) {
        print(error.localizedDescription)
    }
}
