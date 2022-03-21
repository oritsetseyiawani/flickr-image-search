//
//  MockNetworkManager.swift
//  CollectionImagesDisplay
//
//  Created by Melvyn Awani on 18/03/2022.
//

import Foundation
@testable import CollectionImagesDisplay

class MockNetworkManager:Networkable {
    var delegate: HomeViewControllerType?

    
    
    func performRequest(requestUrl: String) {
        let urlSession = URLSession.shared
        let bundle = Bundle(for: MockNetworkManager.self)
        guard let url = bundle.url(forResource: "PhotosLocalResponse", withExtension: "json")
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
        
        
        // FUNCTION TO HANDLE PARSING OF DATA
        func parseJSON(galleryData: Data) {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(GalleryData.self, from: galleryData)
                let dataReceivedFromAPINetwork = decodedData
                self.delegate?.dataReceivedFromAPINetwork(safeData: dataReceivedFromAPINetwork)
                
            } catch {
                print (error)
            }
    
    
}
    }

    
    // FUNCTION TO HANDLE PARSING OF DATA
    func parseJSON(galleryData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(GalleryData.self, from: galleryData)
            let dataReceivedFromAPINetwork = decodedData
            self.delegate?.dataReceivedFromAPINetwork(safeData: dataReceivedFromAPINetwork)
            
        } catch {
            print (error)
        }


}
}
