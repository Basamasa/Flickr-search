//
//  FlickrSearchTests.swift
//  FlickrSearchTests
//
//  Created by Anzer Arkin on 28.01.22.
//

import XCTest
@testable import FlickrSearch

class FlickrSearchTests: XCTestCase {

    override func setUpWithError() throws {
    }

    func testSearchValidText() {
        
        let expct = expectation(description: "Returns json response")
        
        FlickrAPI().request("dogs", pageNo: 1) { (result) in
            
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
    
    func testValidatePhotoImageURL() {
        
        let expct = expectation(description: "Returns all fields to create valid image url")
        
        FlickrAPI().request("dogs", pageNo: 1) { (result) in
            
            switch result {
            case .Success(let results):
                
                guard let photosCount = results?.photo.count else {
                    XCTFail("No photos returned")
                    return
                }
                
                if photosCount > 0 {
                    XCTAssert(true, "Returned photos")
                    
                    // Pick first photo to test image url
                    let photo = results?.photo.first
                    
                    if photo?.farm == nil {
                        XCTFail("No farm id returned")
                    }
                    
                    if photo?.server == nil {
                        XCTFail("No server id returned")
                    }
                    
                    if photo?.id == nil {
                        XCTFail("No photo id returned")
                    }
                    
                    if photo?.secret == nil {
                        XCTFail("No secret id returned")
                    }
                    
                    XCTAssert(true, "Success")
                    expct.fulfill()
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
    
    func testSearchInvalidText() {
        
        let expct = expectation(description: "Returns error message")
        
        FlickrAPI().request("", pageNo: 1) { (result) in
            switch result {
            case .Success( _):
                XCTFail("No results")
            case .Failure( _):
                XCTAssert(true, "Success")
                expct.fulfill()
            case .Error( _):
                XCTAssert(true, "Success")
                expct.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }

}
