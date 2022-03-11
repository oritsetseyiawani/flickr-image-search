//
//  ViewController.swift
//  CollectionImagesDisplay
//
//  Created by Melvyn Awani on 07/03/2022.
//

import UIKit
protocol ViewControllerType: AnyObject{
    func dataReceivedFromAPINetwork(safeData: GalleryData)
}

class ViewController: UIViewController, UICollectionViewDelegate {
    
    weak var delegate: ViewControllerType?
    var dataReceivedFromAPI: GalleryData?
    let networkManager = NetworkManager()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // URL FOR REQUESTS ON FLICKR API THAT RETURNS JSON LIST
    let url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=b4ab67c03f26226651e6d4ec29824a44&format=json&nojsoncallback=1&tags="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        searchBar.delegate = self
        networkManager.delegate = self
    }
}



// COLLECTION VIEW DATA SOURCE
extension ViewController: UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        //cell.backgroundColor = .white
        
        let farmValue = dataReceivedFromAPI?.photos.photo[indexPath.row].farm ?? 0
        let serverValue = dataReceivedFromAPI?.photos.photo[indexPath.row].server ?? ""
        let idValue = dataReceivedFromAPI?.photos.photo[indexPath.row].id ?? ""
        let secretValue = dataReceivedFromAPI?.photos.photo[indexPath.row].secret ?? ""
         
        let imageReturnedURL = "https://farm\(farmValue).staticflickr.com/\(serverValue)/\(idValue)_\(secretValue)_m.jpg"
        
        print(imageReturnedURL)
        cell.imageReceived.load(urlString: imageReturnedURL)
        return cell
    }
    
    
    
    // NUMBER OF ITEMS IN THE SECTION
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataReceivedFromAPI?.photos.photo.count ?? 0
    }
    
}



// WIDTH AND HEIGHT OF THE CELLS IN THE COLLECTION VIEW
extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 394, height: 200)
    }
}



// DID SELECT ITEM AT
extension ViewController{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        print(dataReceivedFromAPI?.photos.photo[indexPath.row])
    }
    
//    searchBar.isSearchResultsButtonSelected
}

extension ViewController: UISearchBarDelegate{
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text ?? "No text")
        let textEntered = searchBar.text ?? ""
        let requestUrl = "\(url)\(textEntered)"
        print(requestUrl)
        networkManager.performRequest(requestUrl: requestUrl)
//        performRequest(requestUrl: requestUrl)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    

    
}

// TO LOAD IMAGE
extension UIImageView{
    func load(urlString: String){
        guard let url = URL(string: urlString)
        else{
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                    
                }
            }
        }
    }
}

extension ViewController: ViewControllerType{
    func dataReceivedFromAPINetwork(safeData: GalleryData) {
        
        dataReceivedFromAPI = safeData
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
