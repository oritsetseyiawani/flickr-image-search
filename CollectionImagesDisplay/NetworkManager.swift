//
//  NetworkManager.swift
//  CollectionImagesDisplay
//
//  Created by Melvyn Awani on 11/03/2022.
//

import Foundation

protocol Networkable {
    var delegate: HomeViewControllerType? {get set}
    func performRequest(requestUrl: String)

}
class NetworkManager {
    
    weak var delegate: HomeViewControllerType?
    
  
    
    func performRequest(requestUrl: String) {
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
               
             //  self.delegate?.getSafeDataForParsing(safeData: safeData)
               self.parseJSON(galleryData: safeData)
               
           }
        }
        dataTask.resume()
    }
    
    // FUNCTION TO HANDLE PARSING OF DATA
    func parseJSON(galleryData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(GalleryData.self, from: galleryData)
             let dataReceivedFromAPINetwork = decodedData
             self.delegate?.dataReceivedFromAPINetwork(safeData: dataReceivedFromAPINetwork)
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
            
        } catch {
            print (error)
        }
        
    }
}

