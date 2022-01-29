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
    
    var isSearching: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flickr search"
        
        configureSearchBar()
        
        fillData()
    }
    
    private func configureSearchBar() {
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search your image"
    }
    
    private func fillData() {
//        imageList.append(FlickrImageModel(imageName: "NImabi", imageURL: "1"))
    }

}


// MARK: -Search bar

extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        print()
    }
}

// MARK: -Search bar

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
//        cell.ImageLabel.text = imageList[indexPath.row].imageName
//        cell.ImageView.image = UIImage(named: imageList[indexPath.row].imageURL)
        
        return cell
    }
    
}


