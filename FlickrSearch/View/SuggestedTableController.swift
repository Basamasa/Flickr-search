//
//  SuggestedTableController.swift
//  FlickrSearchTests
//
//  Created by Anzer Arkin on 30.01.22.
//

import UIKit

// This protocol helps inform MainTableViewController that a suggested search or product was selected.
protocol SuggestedSearch: AnyObject {
    // A suggested search was selected; inform our delegate that the selected search token was selected.
    func didSelectSuggestedSearch(token: UISearchToken)
    
    // A product was selected; inform our delgeate that a product was selected to view.
    func didSelectProduct(product: Product)
}

class SuggestedTableController: UITableViewController {
    
    var filteredProducts = [Product]()
    
    // Given the table cell row number, return the UIColor equivalent.
    class func suggestedColor(fromIndex: Int) -> UIColor {
        var suggestedColor: UIColor!
        switch fromIndex {
        case 0:
            suggestedColor = UIColor.systemRed
        case 1:
            suggestedColor = UIColor.systemGreen
        case 2:
            suggestedColor = UIColor.systemBlue
        case 3:
            suggestedColor = UIColor.label
        default: break
        }
        return suggestedColor
    }
    
    private func suggestedImage(fromIndex: Int) -> UIImage {
        let color = SuggestedTableController.suggestedColor(fromIndex: fromIndex)
        return (UIImage(systemName: "magnifyingglass.circle.fill")?.withTintColor(color))!
    }
    
    class func suggestedTitle(fromIndex: Int) -> String {
        return suggestedSearches[fromIndex]
    }
    
    // Your delegate to receive suggested search tokens.
    weak var suggestedSearchDelegate: SuggestedSearch?
    
    // MARK: - UITableViewDataSource
    
    static let suggestedSearches = [
        NSLocalizedString("Red Flowers", comment: ""),
        NSLocalizedString("Green Flowers", comment: ""),
        NSLocalizedString("Blue Flowers", comment: "")
    ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showSuggestedSearches ? SuggestedTableController.suggestedSearches.count : filteredProducts.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return showSuggestedSearches ? NSLocalizedString("Suggested Searches", comment: "") : ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destinationViewController = segue.destination as? DetailViewController {
//            destinationViewController.product = filteredProducts[tableView.indexPathForSelectedRow!.row]
//        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cellID")

        if showSuggestedSearches {
            let suggestedtitle = NSMutableAttributedString(string: SuggestedTableController.suggestedSearches[indexPath.row])
            suggestedtitle.addAttribute(NSAttributedString.Key.foregroundColor,
                                        value: UIColor.label,
                                        range: NSRange(location: 0, length: suggestedtitle.length))
            cell.textLabel?.attributedText = suggestedtitle
            
            // No detailed text or accessory for suggested searches.
            cell.detailTextLabel?.text = ""
            cell.accessoryType = .none
            
            // Compute the suggested image when it is the proper color.
            let image = suggestedImage(fromIndex: indexPath.row)
            let tintableImage = image.withRenderingMode(.alwaysOriginal)
            cell.imageView?.image = tintableImage
        } else {
            let product = filteredProducts[indexPath.row]
            configureCell(cell, forProduct: product)
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
        // We must have a delegate to respond to row selection.
        guard let suggestedSearchDelegate = suggestedSearchDelegate else { return }
            
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Make sure we are showing suggested searches before notifying which token was selected.
        if showSuggestedSearches {
            // A suggested search was selected; inform our delegate that the selected search token was selected.
            let tokenToInsert = SuggestedTableController.searchToken(tokenValue: indexPath.row)
            suggestedSearchDelegate.didSelectSuggestedSearch(token: tokenToInsert)
        } else {
            // A product was selected; inform our delgeate that a product was selected to view.
            let selectedProduct = filteredProducts[indexPath.row]
            suggestedSearchDelegate.didSelectProduct(product: selectedProduct)
        }
    }
    
    // Used by both MainTableViewController and ResultsTableController to define its table cells.
    func configureCell(_ cell: UITableViewCell, forProduct product: Product) {
        let textTitle = NSMutableAttributedString(string: product.title)
        let textColor = SuggestedTableController.suggestedColor(fromIndex: product.color)
        
        textTitle.addAttribute(NSAttributedString.Key.foregroundColor,
                               value: textColor,
                               range: NSRange(location: 0, length: textTitle.length))
        cell.textLabel?.attributedText = textTitle
        
        // Build the price and year as the detail right string.
        let priceString = product.formattedPrice()
        let yearString = product.formattedDate()
        cell.detailTextLabel?.text = "\(priceString!) | \(yearString!)"
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = nil
    }
    
    // Given a table cell row number index, return its color number equivalent.
    class func colorKind(fromIndex: Int) -> Product.ColorKind {
        var colorKind: Product.ColorKind!
        switch fromIndex {
        case 0:
            colorKind = Product.ColorKind.red
        case 1:
            colorKind = Product.ColorKind.green
        case 2:
            colorKind = Product.ColorKind.blue
        default: break
        }
        return colorKind
    }
    
    // Search a search token from an input value.
    class func searchToken(tokenValue: Int) -> UISearchToken {
        let tokenColor = SuggestedTableController.suggestedColor(fromIndex: tokenValue)
        let image =
            UIImage(systemName: "circle.fill")?.withTintColor(tokenColor, renderingMode: .alwaysOriginal)
        let searchToken = UISearchToken(icon: image, text: suggestedTitle(fromIndex: tokenValue))
        
        // Set the color kind number as the token value.
        let color = SuggestedTableController.colorKind(fromIndex: tokenValue).rawValue
        searchToken.representedObject = NSNumber(value: color)
        
        return searchToken
    }

}
