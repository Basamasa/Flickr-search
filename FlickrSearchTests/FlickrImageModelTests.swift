//
//  FlickrImageModelTests.swift
//  FlickrSearchTests
//
//  Created by Anzer Arkin on 30.01.22.
//

import XCTest
@testable import FlickrSearch

class FlickrAPITests: XCTestCase {

    override func setUpWithError() throws {
    }
    
    func testSearchValidText() {
        // Given
        let expect = expectation(description: "Returns response")
        
        // When
        FlickrAPI().requestText("dogs", pageNo: 1) { (result) in
            
            switch result {
            case .Success(let results):
                if results != nil {
                    XCTAssert(true, "Success")
                    expect.fulfill()
                } else {
                    XCTFail("No results")
                }
            case .Failure(let message):
                XCTFail(message)
            case .Error(let error):
                XCTFail(error)
            }
        }
        
        // Then
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testSearchInvalidText() {
        // Given
        let expect = expectation(description: "Returns error message")
        
        // When
        FlickrAPI().requestText("", pageNo: 1) { (result) in
            switch result {
            case .Success( _):
                XCTFail("No results")
            case .Failure( _):
                XCTAssert(true, "Success")
                expect.fulfill()
            case .Error( _):
                XCTAssert(true, "Success")
                expect.fulfill()
            }
        }
        
        // Then
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
}
