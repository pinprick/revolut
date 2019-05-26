//
//  ConverterPresenter.swift
//  Revolut
//
//  Created by Igor Shvetsov on 19/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import Foundation

protocol ConverterPresenter: class {
    func viewDidLoad()
    func didChangeConverting(value text: String)
}

final class CommonConverterPresenter: ConverterPresenter {
    
    typealias C = Constants
    
    enum Constants {
        static let updateInterval: TimeInterval = 1.0
    }
    
    typealias Dependencies = HasRateService
    typealias ViewType = ConverterView & ErrorHandable
    
    private unowned let view: ViewType
    private let dependencies: Dependencies
    
    var rateService: RateService {
        return dependencies.rateService
    }
    
    private var base: String {
        didSet {
            recalculateRates()
        }
    }
    private var value: Double = 1.0
    
    private var rates = [String: Double]()
    private var datasource = RArray<Currency>(value: [])
    
    // MARK: Initalizer
    
    init(view: ViewType, dependencies: Dependencies, base: String = "EUR") {
        self.view = view
        self.base = base
        self.dependencies = dependencies
    }
    
    // MARK: Presenter logic
    
    func viewDidLoad() {
        view.setup(with: datasource)
        loadInitialState()
    }
    
    func didChangeConverting(value text: String) {
        guard !text.isEmpty, let value = Double(text), value > 0 else {
            return
        }
        self.value = value        
        recalculateCurrenciesValue()
        // update visible views
        view.update()
    }
    
    // MARK: Networking
    
    private func loadInitialState() {
        view.showLoader(true)
        rateService.getCurrency(base: base) { [weak self] result in
            guard let self = self else { return }
            defer { self.view.showLoader(false) }
            guard case let Result.success(rates) = result else {
                if case let Result.failure(error) = result {
                    self.view.display(error: error)
                }
                return
            }
            self.rates = rates
            self.datasource.value = rates.map { rate in
                let calculatedValue = self.value * rate.value
                return Currency(name: rate.key, value: calculatedValue)
            }
            self.rates[self.base] = 1.0
            self.datasource.value.insert(Currency(name: self.base, value: 1.0), at: 0)
            self.view.reload()
        }
    }
    
    private func updateData() {
        view.showLoader(true)
        rateService.getCurrency(base: base) { [weak self] result in
            guard let self = self else { return }
            defer { self.view.showLoader(false) }
            guard case let Result.success(rates) = result else {
                if case let Result.failure(error) = result {
                    self.view.display(error: error)
                }
                return
            }
            self.updateRates(rates)
            self.view.update()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + C.updateInterval, execute: { [weak self] in
            guard let self = self else { return }
            self.updateData()
        })
    }
    
    // MARK: Recalculation logic
    
    private func updateRates(_ updatedRates: [String: Double]) {
        rates.keys.forEach { key in
            rates[key] = updatedRates[key]
        }
    }
    
    private func recalculateCurrenciesValue() {
        if let newBase = datasource.value.first?.name {        
            base = newBase
        }
        datasource.value = datasource.value.map { [weak self] currency -> Currency in
            guard let self = self else { return currency }
            let rate = (currency.name == self.base) ? 1 : (self.rates[currency.name] ?? 0)
            let newValue = rate * self.value
            return Currency(name: currency.name, value: newValue)
        }
    }
    
    private func recalculateRates() {
        let baseRate = rates[base] ?? 1
        rates.keys.forEach { key in
            let currentRate = rates[key] ?? 0
            let newRate = currentRate / baseRate
            rates[key] = newRate
        }
    }        
}
