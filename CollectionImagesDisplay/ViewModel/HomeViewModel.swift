//
//  HomeViewControllerModel.swift
//  CollectionImagesDisplay
//
//  Created by Melvyn Awani on 12/03/2022.
//

import Foundation
// I AM AWARE THAT UIKit and SwiftUI are not supposed to be in the viewModel but i faced an issue on line 29 which i would explain, that's the only reason they got imported
import UIKit
import SwiftUI
import CoreData

protocol HomeViewModelType: AnyObject {
    func dataReceivedFromAPINetwork(safeData: GalleryData)
    func informNetworkManagerToPerformRequest(textEntered: String, caller: HomeViewControllerType)
    func getImageUrl( indexPath:IndexPath) -> String
    func getNumberOfItems() -> Int
    func loadItemsFromCoreData()
    func itemWasTapped(indexPath: IndexPath)
}

class HomeViewModel: HomeViewModelType {
    var networkManager = NetworkManager()
//    var favoritesViewController = FavoritesViewController()
    var dataReceivedFromAPI: GalleryData?
    weak var delegate: HomeViewControllerType?
    //HERE IS WHERE I FACED MY ISSUE
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var imageArray = [Image]()
    var requestUrl = ""
 
    // URL FOR REQUESTS ON FLICKR API THAT RETURNS JSON LIST
    let url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=b4ab67c03f26226651e6d4ec29824a44&format=json&nojsoncallback=1&tags="
    
    func getRequestUrl(textEntered: String) -> String{
        requestUrl = "\(url)\(textEntered)"
        return "\(url)\(textEntered)"
    }
    
    func setContext(context: NSManagedObjectContext){
        self.context = context
    }
    
    //RUNS WHEN AN IMAGE WAS CLICKED ON THE HOME PAGE
    func itemWasTapped(indexPath: IndexPath) {
        let pathPrefix = dataReceivedFromAPI?.photos.photo[indexPath.row]
        let farmValue = pathPrefix?.farm ?? 0
        let serverValue = pathPrefix?.server ?? ""
        let idValue = pathPrefix?.id ?? ""
        let secretValue = pathPrefix?.secret ?? ""
        let imageReturnedURL = "https://farm\(farmValue).staticflickr.com/\(serverValue)/\(idValue)_\(secretValue)_m.jpg"
        let newImage = Image(context: context)
        newImage.farm = Int32(farmValue)
        newImage.server = serverValue
        newImage.id = idValue
        newImage.secret = secretValue
        newImage.imageReturnedURL = imageReturnedURL
        imageArray.append(newImage)
//        favoritesViewController.imageArray = imageArray
        saveItemsToCoreData()
    }
    
    func informNetworkManagerToPerformRequest(textEntered: String, caller: HomeViewControllerType) {
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
    
    //SAVE TO CORE DATA
    func saveItemsToCoreData() {
        do {
            try context.save()
            print("Successfully saved to CoreData")
        } catch  {
            print("Error saving to CoreData \(error)")
        }
    }
    
    //FETCH DATA
    func loadItemsFromCoreData() {
        let request: NSFetchRequest<Image> = Image.fetchRequest()
        do {
            imageArray = try context.fetch(request)
            print("Successfully fetched image array with \(imageArray.count) elements")
        } catch  {
            print("Error retrieving file \(error)")
        }
//        favoritesViewController.imageArray = imageArray
    }
    
    func getNumberOfItems() -> Int {
        return dataReceivedFromAPI?.photos.photo.count ?? 0
    }
}
