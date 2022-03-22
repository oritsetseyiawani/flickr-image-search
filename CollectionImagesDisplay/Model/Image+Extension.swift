//
//  Image+Extension.swift
//  CollectionImagesDisplay
//
//  Created by Melvyn Awani on 21/03/2022.
//

import Foundation
import CoreData

extension Image{
    
    static func saveImages(farmValue: Int, serverValue: String, idValue: String, secretValue: String, imageReturnedURL: String, moc: NSManagedObjectContext){
        let imageEntity = NSEntityDescription.insertNewObject(forEntityName: "Image", into: moc) as! Image
        imageEntity.farm = Int32(farmValue)
        imageEntity.server = serverValue
        imageEntity.id = idValue
        imageEntity.secret = secretValue
        imageEntity.imageReturnedURL = imageReturnedURL
    }
    
    static func getImages(moc: NSManagedObjectContext) -> [Image]{
        
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        do {
            let images = try moc.fetch(fetchRequest)
            print("Fetched Successfully")
            return images
        } catch  {
            return []
        }
    }
    
    static func deleteImage(indexPath: IndexPath, moc: NSManagedObjectContext, imageArray: [Image]){
        moc.delete(imageArray[indexPath.row])
    }
}
