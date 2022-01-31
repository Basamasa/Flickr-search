//
//  ViewController.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 28.01.22.
//

import UIKit

class MainViewController: UIViewController {

    private var searchController: UISearchController!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var suggestedTableViewController: SuggestedTableController!
            
    private var flickrViewModel = FlickrImageViewModel()
        
    private var searchText: String = ""
    
    private var loading: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flickr search"
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        configureSearchBar()
        
        flickrViewModel.dataUpdated = { [weak self] in
            print("Updated")
            self?.loading = false
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

// MARK: -Suggested search

extension MainViewController: SuggestedSearch {
    func didSelectSuggestedSearch(text: String) {
        if let searchField = navigationItem.searchController?.searchBar.searchTextField {
            searchText = text
            searchField.text = searchText
            suggestedTableViewController.showSuggestedSearches = true
            updateSearchResults(for: searchController)
        }
    }
    
    func setToSuggestedSearches() {
        if searchController.searchBar.searchTextField.tokens.isEmpty {
            suggestedTableViewController.showSuggestedSearches = true
            suggestedTableViewController.tableView.delegate = suggestedTableViewController
        }
    }
}


// MARK: -Search bar

extension MainViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        
        searchText = text
        
        if searchController.searchBar.text!.isEmpty {
            // Text is empty, show suggested searches again.
            setToSuggestedSearches()
        } else {
            suggestedTableViewController.showSuggestedSearches = false
        }
    }
    
    func presentSearchController(_ searchController: UISearchController) {
        searchController.showsSearchResultsController = true
        setToSuggestedSearches()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if searchText.count < 1 {
            return
        }
        
        loading = true

        imageCollectionView.reloadData()
                
        flickrViewModel.search(text: searchText) {
            print("Search worked.")
        }
        
        let tempoText = searchText
        searchController.searchBar.resignFirstResponder()
        searchController.isActive = false
        searchController.searchBar.text = tempoText
        
        HistorySearch.insertHistory(text: tempoText)
    }
}

// MARK: -Collection view

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if loading {
            return 30
        }
        return flickrViewModel.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        if loading {
            cell.ImageLabel.text = ""
            cell.ImageView.image = UIImage(named: "loadingImage")
        } else {
            cell.ImageLabel.text = flickrViewModel.photos[indexPath.row].title
            cell.ImageView.image = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageCollectionViewCell else {
            return
        }
        
        if flickrViewModel.photos.isEmpty {
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


