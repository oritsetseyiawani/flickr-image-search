//
//  FavoritesViewController.swift
//  CollectionImagesDisplay
//
//  Created by Melvyn Awani on 21/03/2022.
//

import UIKit
class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    var imageArray:[Image] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        imageArray = Image.getImages(moc: appDelegate.persistentContainer.viewContext)
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
        favoritesCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        favoritesCollectionView.reloadData()
        print(imageArray.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        imageArray = Image.getImages(moc: appDelegate.persistentContainer.viewContext)
        favoritesCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        Image.deleteImage(indexPath: indexPath, moc: context, imageArray: imageArray)
        imageArray.remove(at: indexPath.row)
        appDelegate.saveContext()
        self.favoritesCollectionView.reloadData()
        
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
    
}



