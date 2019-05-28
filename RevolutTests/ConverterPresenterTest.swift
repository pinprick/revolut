//
//  ConverterPresenterTest.swift
//  RevolutTests
//
//  Created by Igor Shvetsov on 28/05/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import XCTest

class ConverterPresenterTest: XCTestCase {
    
    var rates: [String: Double]!
    var presenter: ConverterPresenter!
    var converterView = ConverterViewMock()
    var rateService: RateService!
    var dependencies: AppDependencies!

    override func setUp() {

        rates = ["RUB": 79.276, "USD": 1.159]
        rateService = RateServiceMock(rates: rates)
        dependencies = AppDependencies(rateService: rateService)
        presenter = CommonConverterPresenter(view: converterView, dependencies: dependencies)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitialLoad() {
        
        let base = "EUR"
        let value = 1.0
        let baseCurrency = Currency(name: base, value: value)
        presenter.viewDidLoad()
        
        var expectedCurrencies: [Currency] = rates.map { rate -> Currency in
            let calculatedValue = rate.value
            return Currency(name: rate.key, value: calculatedValue)
        }
        
        expectedCurrencies.insert(baseCurrency, at: 0)
        let loadedCurrencies: [Currency] = converterView.models.value
        
        XCTAssertEqual(loadedCurrencies, expectedCurrencies)
    }

    func testChangeConvertingValue() {
        
        let base = "EUR"
        let newValue = 2.0
        let newValueString = String(newValue)
        
        presenter.viewDidLoad()
        let baseCurrency = Currency(name: base, value: newValue)
        presenter.didChangeConverting(value: newValueString)
        
        var expectedCurrencies: [Currency] = rates.map { rate -> Currency in
            let calculatedValue = rate.value * newValue
            return Currency(name: rate.key, value: calculatedValue)
        }
        
        expectedCurrencies.insert(baseCurrency, at: 0)
        let loadedCurrencies: [Currency] = converterView.models.value
        
        XCTAssertEqual(loadedCurrencies, expectedCurrencies)
    }
    
    func testLoadFailure() {
        
        rateService = FailureRateServiceMock()
        dependencies = AppDependencies(rateService: rateService)
        presenter = CommonConverterPresenter(view: converterView, dependencies: dependencies)
        
        presenter.viewDidLoad()
        
        XCTAssertNotNil(converterView.error)        
    }
}
