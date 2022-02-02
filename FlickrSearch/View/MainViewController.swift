//
//  ViewController.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 28.01.22.
//

import UIKit

/// Main controller of the app
class MainViewController: UIViewController {

    private var searchController: UISearchController!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var suggestedTableViewController: SuggestedTableController!
            
    private var flickrViewModel = FlickrImageViewModel()
        
    private var searchText: String = ""
    
    private var preLoadingNumber: Int = 30
    
    private var loading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flickr search"
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        setUpSearchBar()
        
        setUpCollectionView()
        
        flickrViewModel.dataUpdated = { [weak self] in
            print("Updated")
            self?.loading = false
            self?.imageCollectionView.reloadData()
        }
    }
    
    private func setUpCollectionView() {
        let mosaicLayout = MosaicLayout()
        imageCollectionView.collectionViewLayout = mosaicLayout
//        imageCollectionView.backgroundColor = UIColor.appBackgroundColor
        imageCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageCollectionView.alwaysBounceVertical = true
        imageCollectionView.indicatorStyle = .white
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifer)
        
        self.view.addSubview(imageCollectionView)
    }
    
    private func setUpSearchBar() {
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
        
        loading = true
        
        let searchedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
        
        if searchedText.count < 1 {
            return
        }

        imageCollectionView.reloadData()
                
        flickrViewModel.search(text: searchedText) {
            print("Search worked.")
        }
        
        let tempText = searchText
        searchController.searchBar.resignFirstResponder()
        searchController.isActive = false
        searchController.searchBar.text = tempText
        HistorySearch.insertHistory(text: tempText)
    }
}

// MARK: -Collection view

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func loadInCell(cell: ImageCollectionViewCell, text: String, image: UIImage?) {
        cell.imageView.image = image
    }
    
    private func loadImage(cell: ImageCollectionViewCell, index: Int) {
        if loading {
            if self.traitCollection.userInterfaceStyle == .dark {
                loadInCell(cell: cell, text: "", image: UIImage(named: "loadingImageDark"))
            } else {
                loadInCell(cell: cell, text: "", image: UIImage(named: "loadingImage"))
            }
        } else {
            loadInCell(cell: cell, text: flickrViewModel.photos[index].title, image: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if loading {
            return preLoadingNumber
        }
        return flickrViewModel.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifer, for: indexPath) as! ImageCollectionViewCell
        
        loadImage(cell: cell, index: indexPath.row)
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


