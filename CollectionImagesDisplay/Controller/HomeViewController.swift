//
//  ViewController.swift
//  CollectionImagesDisplay
//
//  Created by Melvyn Awani on 07/03/2022.
//

import UIKit
import CoreData
protocol HomeViewControllerType: AnyObject {
    func dataReceivedFromAPINetwork(safeData: GalleryData)
}

class HomeViewController: UIViewController, UICollectionViewDelegate {
    
    weak var delegate: HomeViewControllerType?
    let homeViewModelType:HomeViewModelType = HomeViewModel()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        searchBar.delegate = self
        homeViewModelType.loadItemsFromCoreData()
        homeViewModelType.setContext(context: context)
        
    }
    
    
    
}



// COLLECTION VIEW DATA SOURCE
extension HomeViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell
        else {
            return UICollectionViewCell()

        }
        
        cell.imageReceived.load(urlString: homeViewModelType.getImageUrl(indexPath: indexPath))
        return cell
    }
    
    // NUMBER OF ITEMS IN THE SECTION
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModelType.getNumberOfItems()
    }
    
}



// WIDTH AND HEIGHT OF THE CELLS IN THE COLLECTION VIEW
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20 , height: UIScreen.main.bounds.height/6)
    }
}



// DID SELECT ITEM AT
extension HomeViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeViewModelType.itemWasTapped(indexPath: indexPath)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        homeViewModelType.informNetworkManagerToPerformRequest(textEntered: searchBar.text ?? "", caller: self)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

// TO LOAD IMAGE
extension UIImageView {
    func load(urlString: String){
        guard let url = URL(string: urlString)
        else{
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self.image = image
                    }
                    
                }
            }
        }
    }
}

extension HomeViewController: HomeViewControllerType {
    func dataReceivedFromAPINetwork(safeData: GalleryData) {
        homeViewModelType.dataReceivedFromAPINetwork(safeData: safeData)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
