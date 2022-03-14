//
//  HomeViewControllerModel.swift
//  CollectionImagesDisplay
//
//  Created by Melvyn Awani on 12/03/2022.
//

import Foundation

protocol HomeViewModelType: AnyObject{
    func dataReceivedFromAPINetwork(safeData: GalleryData)
    func informNetworkManagerToPerformRequest(textEntered: String, caller: ViewControllerType)
    func getImageUrl( indexPath:IndexPath) -> String
    func saveDataReceived(safeData: GalleryData)
    func getNumberOfItems() -> Int
}

class HomeViewModel: HomeViewModelType{
    
    let networkManager = NetworkManager()
    var dataReceivedFromAPI: GalleryData?
    weak var delegate: ViewControllerType?
    var requestUrl = ""
    
    // URL FOR REQUESTS ON FLICKR API THAT RETURNS JSON LIST
    let url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=b4ab67c03f26226651e6d4ec29824a44&format=json&nojsoncallback=1&tags="
    
    func getRequestUrl(textEntered: String) -> String{
        requestUrl = "\(url)\(textEntered)"
        return "\(url)\(textEntered)"
    }
    
    func informNetworkManagerToPerformRequest(textEntered: String, caller: ViewControllerType)  {
        networkManager.delegate = caller
        networkManager.performRequest(requestUrl: "\(url)\(textEntered)")
    }
    
    func dataReceivedFromAPINetwork(safeData: GalleryData) {
        dataReceivedFromAPI = safeData
    }
    
    // COLLECTION VIEW DATA IMAGE SOURCE
    func getImageUrl( indexPath:IndexPath) -> String {
        let pathPrefix = dataReceivedFromAPI?.photos.photo[indexPath.row]
        let farmValue = pathPrefix?.farm ?? 0
        let serverValue = pathPrefix?.server ?? ""
        let idValue = pathPrefix?.id ?? ""
        let secretValue = pathPrefix?.secret ?? ""
        let imageReturnedURL = "https://farm\(farmValue).staticflickr.com/\(serverValue)/\(idValue)_\(secretValue)_m.jpg"
        
        return imageReturnedURL
    }
    
    
    func saveDataReceived(safeData: GalleryData)  {
        dataReceivedFromAPI = safeData
        print("Data was successfully saved in the model")
    }
    
    func getNumberOfItems() -> Int {
        return dataReceivedFromAPI?.photos.photo.count ?? 0
    }
}
