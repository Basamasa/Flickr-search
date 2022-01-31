//
//  SuggestedTableController.swift
//  FlickrSearchTests
//
//  Created by Anzer Arkin on 30.01.22.
//

import UIKit

// This protocol helps inform MainTableViewController that a suggested search was selected.
protocol SuggestedSearch: AnyObject {
    func didSelectSuggestedSearch(text: String)
}

class SuggestedTableController: UITableViewController {
    
    var filteredProducts = [String]()
        
    weak var suggestedSearchDelegate: SuggestedSearch?
    
    func suggestedImage(fromIndex: Int) -> UIImage {
        let color = UIColor.systemGray
        return (UIImage(systemName: "magnifyingglass.circle.fill")?.withTintColor(color))!
    }
    
    func suggestedTitle(fromIndex: Int) -> String {
        return HistorySearch.historySearches[fromIndex]
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showSuggestedSearches ? HistorySearch.historySearches.count : filteredProducts.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return showSuggestedSearches ? NSLocalizedString("Search history", comment: "") : ""
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cellID")

        if showSuggestedSearches {
            let suggestedtitle = NSMutableAttributedString(string: HistorySearch.historySearches[indexPath.row])
            suggestedtitle.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.label,
                                        range: NSRange(location: 0, length: suggestedtitle.length))
            cell.textLabel?.attributedText = suggestedtitle
            
            cell.detailTextLabel?.text = ""
            cell.accessoryType = .none
            
            let image = suggestedImage(fromIndex: indexPath.row)
            let tintableImage = image.withRenderingMode(.alwaysOriginal)
            cell.imageView?.image = tintableImage
        }
        return cell
    }
    
    var showSuggestedSearches: Bool = false {
        didSet {
            if oldValue != showSuggestedSearches {
                tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let suggestedSearchDelegate = suggestedSearchDelegate else { return }
            
        tableView.deselectRow(at: indexPath, animated: true)

        if showSuggestedSearches {
            let text = HistorySearch.historySearches[indexPath.row]
            suggestedSearchDelegate.didSelectSuggestedSearch(text: text)
        }
    }

}
