//
//  ViewController.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 28.01.22.
//

import UIKit

class ViewController: UIViewController {

    private var searchController: UISearchController!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var suggestedTableViewController: SuggestedTableController!
            
    private var flickrViewModel = FlickrImageViewModel()
    
    private var isSearching: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flickr search"
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        configureSearchBar()
        
        flickrViewModel.dataUpdated = { [weak self] in
            print("Updated")
            self?.imageCollectionView.reloadData()
        }
    }
    
    private func configureSearchBar() {
        suggestedTableViewController = SuggestedTableController()
        suggestedTableViewController.suggestedSearchDelegate = self
        
        searchController = UISearchController(searchResultsController: suggestedTableViewController)
        searchController.searchBar.placeholder = "Search your image"
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension ViewController: SuggestedSearch {
    func didSelectSuggestedSearch(token: UISearchToken) {
//        if let searchField = navigationItem.searchController?.searchBar.searchTextField {
//            searchField.insertToken(token, at: 0)
//
//            // Hide the suggested searches now that we have a token.
//            resultsTableController.showSuggestedSearches = false
//
//            // Update the search query with the newly inserted token.
//            updateSearchResults(for: searchController)
//        }
    }
    
    func didSelectProduct(product: Product) {
//        let detailViewController = DetailViewController.detailViewControllerForProduct(product)
//        navigationController?.pushViewController(detailViewController, animated: true)
    }
}


// MARK: -Search bar

extension ViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text!.isEmpty {
            // Text is empty, show suggested searches again.
            setToSuggestedSearches()
        } else {
            suggestedTableViewController.showSuggestedSearches = false
        }
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text!.isEmpty {
//            // Text is empty, show suggested searches again.
//            setToSuggestedSearches()
//        } else {
//            suggestedTableViewController.showSuggestedSearches = false
//        }
//    }
    
    func presentSearchController(_ searchController: UISearchController) {
        searchController.showsSearchResultsController = true
        setToSuggestedSearches()
    }
    
    func setToSuggestedSearches() {
        // Show suggested searches only if we don't have a search token in the search field.
        if searchController.searchBar.searchTextField.tokens.isEmpty {
            suggestedTableViewController.showSuggestedSearches = true
            
            // We are no longer interested in cell navigating, since we are now showing the suggested searches.
            suggestedTableViewController.tableView.delegate = suggestedTableViewController
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let trimmedText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let text = trimmedText,
                text.count > 0 else {
            return
        }
        flickrViewModel.search(text: text) {
            print("Search worked.")
        }
        
        searchController.searchBar.resignFirstResponder()
    }
}

// MARK: -Search bar

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrViewModel.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        cell.ImageLabel.text = flickrViewModel.photos[indexPath.row].title
        cell.ImageView.image = nil
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageCollectionViewCell else {
            return
        }
        
        let model = flickrViewModel.photos[indexPath.row]
        cell.model = ImageViewModel.init(photo: model)
        
        if indexPath.row == (flickrViewModel.photos.count - 10) {
            flickrViewModel.fetchNextPage {
                print("Fetched next page")
            }
        }
    }
}


