//
//  HistorySearchViewModel.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 30.01.22.
//

import Foundation

/// Search history database
class HistorySearch {
    static let historySearchesId = "history-searches"

    static var historySearches: [String] {
        get {
            let defaults = UserDefaults.standard
            return defaults.stringArray(forKey: historySearchesId) ?? [String]()
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: historySearchesId)
        }
    }
    
    static func insertHistory(text: String) {
        var historySearches = historySearches
        if historySearches.count > 9 {
            historySearches.removeLast()
        }
        historySearches.insert(text, at: 0)
        HistorySearch.historySearches = historySearches
    }
}
