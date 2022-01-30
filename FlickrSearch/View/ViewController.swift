//
//  ViewController.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 28.01.22.
//

import UIKit

class ViewController: UIViewController {

    private let searchController = UISearchController()
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
            
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
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "Search your image"
    }
}


// MARK: -Search bar

extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        imageCollectionView.reloadData()
        flickrViewModel.search(text: text) {
            print("worked")
        }
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


