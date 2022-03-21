//
//  NetworkManagerType.swift
//  CollectionImagesDisplay
//
//  Created by Melvyn Awani on 18/03/2022.
//

import Foundation
protocol NetworkManagerType {
    func performRequest(requestUrl: String)
    func parseJSON(galleryData: Data)
    
}

extension NetworkManager: Networkable{
    
}
