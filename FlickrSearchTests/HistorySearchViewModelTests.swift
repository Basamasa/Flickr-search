//
//  HistorySearchViewModelTests.swift
//  FlickrSearchTests
//
//  Created by Anzer Arkin on 30.01.22.
//

import XCTest
@testable import FlickrSearch

class HistorySearchViewModelTests: XCTestCase {

    override func setUpWithError() throws {
    }

    func testHistorySearchesWithSingleInput() {
        // Given
        HistorySearch.historySearches = []
        
        // When
        HistorySearch.insertHistory(text: "1")
        
        // Then
        XCTAssertEqual(HistorySearch.historySearches, ["1"])
    }
    
    func testHistorySearchesWithMultiInput() {
        // Given
        HistorySearch.historySearches = []
        
        // When
        HistorySearch.insertHistory(text: "1")
        HistorySearch.insertHistory(text: "2")
        HistorySearch.insertHistory(text: "3")
        
        // Then
        XCTAssertEqual(HistorySearch.historySearches, ["3", "2", "1"])
    }
}
