//
//  GalleryData.swift
//  CollectionImagesDisplay
//
//  Created by Melvyn Awani on 08/03/2022.
//

import Foundation

struct GalleryData: Decodable{
    let photos: photos
    let stat: String
}

struct photos: Decodable{
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [photo]
}

struct photo: Decodable{
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int

}
