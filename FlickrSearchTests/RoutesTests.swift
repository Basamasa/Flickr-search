//
//  RoutesTests.swift
//  FlickrSearchTests
//
//  Created by Anzer Arkin on 30.01.22.
//

import XCTest
@testable import FlickrSearch

class RoutesTests: XCTestCase {

    override func setUpWithError() throws {
    }

    func testBaseUrl() {
        // Given
        let searchText = "Cat"
        let pageNo = 1
        
        // When
        let request = Routes.searchRequest(searchText: searchText, pageNo: pageNo)
        
        // Then
        XCTAssertEqual(request?.mainDocumentURL, URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=136bb4dc9c1ade0aba1c974ac3e866db&format=json&nojsoncallback=1&safe_search=1&per_page=60&text=Cat%@&page=1"))
    }
    
    func testImageUrl() {
        // Given
        let id = "12344"
        let secret = "abcdef"
        
        // When
        let url = String(format: Routes.imageURL, id, secret)
        
        // Then
        XCTAssertEqual(url, "https://farm66.static.flickr.com/65535/12344_abcdef.jpg")
    }

}
