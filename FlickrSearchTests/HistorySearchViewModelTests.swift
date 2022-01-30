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
        HistorySearchViewModel.historySearches = []
        
        // When
        HistorySearchViewModel.insertHistory(text: "1")
        
        // Then
        XCTAssertEqual(HistorySearchViewModel.historySearches, ["1"])
    }
    
    func testHistorySearchesWithMultiInput() {
        // Given
        HistorySearchViewModel.historySearches = []
        
        // When
        HistorySearchViewModel.insertHistory(text: "1")
        HistorySearchViewModel.insertHistory(text: "2")
        HistorySearchViewModel.insertHistory(text: "3")
        
        // Then
        XCTAssertEqual(HistorySearchViewModel.historySearches, ["3", "2", "1"])
    }
}
