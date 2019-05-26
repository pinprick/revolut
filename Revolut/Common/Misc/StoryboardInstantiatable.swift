//
//  StoryboardInstantiatable.swift
//  Revolut
//
//  Created by Igor Shvetsov on 18/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardBased {
    
}

extension StoryboardBased where Self: UIViewController {
    static func instantiate() -> Self {
        let sb = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        let vc = sb.instantiateInitialViewController()
        guard let properVC = vc as? Self else {
            fatalError("Probably '\(self)' isn't initial VC of '\(sb)'")
        }
        return properVC
    }
}
