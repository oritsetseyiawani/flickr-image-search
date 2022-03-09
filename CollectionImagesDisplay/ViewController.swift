//
//  ViewController.swift
//  CollectionImagesDisplay
//
//  Created by Melvyn Awani on 07/03/2022.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBtn: UIButton!
    
    // URL FOR REQUESTS ON FLICKR API THAT RETURNS JSON LIST
    let url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=b4ab67c03f26226651e6d4ec29824a44&format=json&nojsoncallback=1&tags="
    var dataReceivedFromAPI: GalleryData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    
    func performRequest(requestUrl: String){
        let urlSession = URLSession.shared
        guard let url = URL(string: requestUrl)
        else{
            return
        }
        
       let dataTask = urlSession.dataTask(with: url) { data, response, error in
            
           if error != nil {
               print(error!)
               return
           }
           if let safeData = data {
               print(safeData)
               self.parseJSON(galleryData: safeData)
               
           }
        }
        dataTask.resume()
    }
    
    // FUNCTION TO HANDLE PARSING OF DATA
    func parseJSON(galleryData: Data){
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(GalleryData.self, from: galleryData)
            dataReceivedFromAPI = decodedData
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        } catch {
            print (error)
        }
        
    }
    
    

    @IBAction func searchBtnPressed(_ sender: Any) {
        print(searchBar.text ?? "No text")
        let textEntered = searchBar.text ?? ""
        let requestUrl = "\(url)\(textEntered)"
        print(requestUrl)
        performRequest(requestUrl: requestUrl)
        searchBar.text = ""
    }
    
}



// COLLECTION VIEW DATA SOURCE
extension ViewController: UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.backgroundColor = .systemYellow
        
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
        return CGSize(width: 394, height: 150)
    }
}



// DID SELECT ITEM AT
extension ViewController{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        print(dataReceivedFromAPI?.photos.photo[indexPath.row])
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
