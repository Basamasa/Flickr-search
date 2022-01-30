//
//  FlickrImageModelTests.swift
//  FlickrSearchTests
//
//  Created by Anzer Arkin on 30.01.22.
//

import XCTest

class FlickrImageModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testSearchValidText() {
        
        let expct = expectation(description: "Returns json response")
        
        FlickrAPI().requestText("dogs", pageNo: 1) { (result) in
            
            switch result {
            case .Success(let results):
                if results != nil {
                    XCTAssert(true, "Success")
                    expct.fulfill()
                } else {
                    XCTFail("No results")
                }
            case .Failure(let message):
                XCTFail(message)
            case .Error(let error):
                XCTFail(error)
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
}
