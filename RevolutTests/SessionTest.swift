//
//  SessionTest.swift
//  RevolutTests
//
//  Created by Igor Shvetsov on 02/06/2019.
//  Copyright © 2019 Igor Shvetsov. All rights reserved.
//

import XCTest

class SessionTest: XCTestCase {

    func testSuccess() {
        let base = "EUR"
        let date = DateFormatter().string(from: Date())
        let rates = ["RUB": 79.276, "USD": 1.159]
        let rateResponse = RateResponse(base: base, date: date, rates: rates)
        
        let params = ["base": base]
        let rateResponseResource = RateResponse.resource(params: params)
        
        var expectedResult: Result<RateResponse?, Error> = Result.success(rateResponse)
        let expectation = XCTestExpectation()
        let mockData = ResponseAndError(response: rateResponse)
        _ = SessionMock<RateResponse>(mockData: mockData).load(rateResponseResource) { (result) in
            expectedResult = result
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
        
        switch expectedResult {
        case .success(let response):
            XCTAssertEqual(response, rateResponse)
        case .failure(_):
            XCTFail()
        }
    }
    
    func testFailure() {
        let base = "EUR"
        let date = DateFormatter().string(from: Date())
        let rates = ["RUB": 79.276, "USD": 1.159]
        let rateResponse = RateResponse(base: base, date: date, rates: rates)
        
        let params = ["base": base]
        let rateResponseResource = RateResponse.resource(params: params)
        let error = ErrorMock.notInitialized
        var expectedResult: Result<RateResponse?, Error> = Result.failure(error)
        let expectation = XCTestExpectation()
        let mockData = ResponseAndError(response: rateResponse, error: error)
        _ = SessionMock<RateResponse>(mockData: mockData).load(rateResponseResource) { (result) in
            expectedResult = result
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
        
        switch expectedResult {
        case .failure(let error):
            XCTAssertNotNil(error)
        case .success(_):
            XCTFail()
        }
    }

}
