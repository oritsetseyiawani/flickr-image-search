//
//  GalleryData.swift
//  CollectionImagesDisplay
//
//  Created by Melvyn Awani on 08/03/2022.
//

import Foundation

struct GalleryData: Decodable {
    let photos: photos
    let stat: String
}

struct photos: Decodable {
    let page: Int
    let pages: Int
    let perPage: Int
    let total: Int
    let photo: [photo]
    
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perPage = "perpage"
        case total
        case photo
    }
}

struct photo: Decodable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let isPublic: Int
    let isFriend: Int
    let isFamily: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
    }

}
