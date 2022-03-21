//
//  FavoritesViewController.swift
//  CollectionImagesDisplay
//
//  Created by Melvyn Awani on 21/03/2022.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    var imageArray = [Image]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
        favoritesCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        favoritesCollectionView.reloadData()
        print(imageArray.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadItemsFromCoreDataIntoFavorites()
        favoritesCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        context.delete(imageArray[indexPath.row])
        imageArray.remove(at: indexPath.row)
        
        saveItemsToCoreData()
        self.favoritesCollectionView.reloadData()
        
    }
    
    // SAVE TO CORE DATA
    func saveItemsToCoreData() {
        do {
            try context.save()
            print("Successfully saved to CoreData")
        } catch  {
            print("Error saving to CoreData \(error)")
        }
        
    }
}




// WIDTH AND HEIGHT OF THE CELLS IN THE COLLECTION VIEW
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ favoritesCollectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2 - 5, height: UIScreen.main.bounds.height/6)
    }
}

extension FavoritesViewController: UICollectionViewDataSource{
    // NUMBER OF ITEMS IN THE SECTION
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    // COLLECTION VIEW DATA SOURCE
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: "favoritesCell", for: indexPath) as! FavoritesCollectionViewCell
        cell.imageReceived.load(urlString: imageArray[indexPath.row].imageReturnedURL ?? "")
        return cell
    }
    
    //FETCH DATA
    func loadItemsFromCoreDataIntoFavorites(){
        let request: NSFetchRequest<Image> = Image.fetchRequest()
        do {
            imageArray = try context.fetch(request)
            print("Successfully fetched image array in favorites with \(imageArray.count) elements")
        } catch  {
            print("Error retrieving file \(error)")
        }
    }
}



