//
//  Result+Networking.swift
//  Revolut
//
//  Created by Igor Shvetsov on 27/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation

extension Result {
    init(_ value: Success?, or error: Failure) {
        if let value = value {
            self = .success(value)
        } else {
            self = .failure(error)
        }
    }
}
