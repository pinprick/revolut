//
//  AppDelegate.swift
//  Revolut
//
//  Created by Igor Shvetsov on 02/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {

    var window: UIWindow?
    private var handlers: [AppDelegateHandlerType] = []

}

extension AppDelegate {
    func run(application: UIApplication) -> Bool {
        let window = UIWindow()
        self.window = window
        window.makeKeyAndVisible()
        
        handlers = [
            ApplicationNavigationHandler()
        ]
        
        return true
    }
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return run(application: application) && handlers
            .map({ handler in
                handler.application(application, didFinishLaunchingWithOptions: launchOptions)
            })
            .allTrue()                
    }
}

// Returns true if any of elements of the sequnce is true, or if the sequence is empty.
private extension Sequence where Element == Bool {
    // Perform (inefficiently) logical & on all items of boolean sequence.
    func allTrue() -> Bool {
        return self.reduce(true, { (acc, value) -> Bool in
            return acc && value
        })
    }
}
