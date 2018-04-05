//
//  FeaturedVC.swift
//  MyAPPStore
//
//  Created by Leela Prasad on 03/04/18.
//  Copyright © 2018 Leela Prasad. All rights reserved.
//

import UIKit

class FeaturedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "CategoryCell"
    let largeCellId = "LargeCategoryCell"
    let headerCellId = "HeaderCell"

    var featuredApps: FeaturedApps?
    var appCategories: [AppCategory]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.title = "Featured Apps"
        self.collectionView?.backgroundColor = .white
        let acVC = ActivityVC()
        present(acVC, animated: true) {
            AppCategory.fetchFeaturedApps { (featuredApps) in
                self.featuredApps = featuredApps
                self.appCategories = featuredApps.appCategories
                self.dismiss(animated: true, completion: nil)
                self.collectionView?.reloadData()
            }
        }
        
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(LargeCategoryCell.self, forCellWithReuseIdentifier: largeCellId)
        collectionView?.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellId)

    }
    
    func showAppDetailVC(forAPP app: APP) {
        let layout = UICollectionViewFlowLayout()
        let vc = AppDetailVC(collectionViewLayout: layout)
        vc.app = app
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //MARK: CollectionView Delegate Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appCategories?.count ?? 0
    }
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 2 {
            
            if let largeCell = collectionView.dequeueReusableCell(withReuseIdentifier: largeCellId, for: indexPath) as? LargeCategoryCell {
                
                largeCell.appCatgory = appCategories?[indexPath.item]
                largeCell.featuredVC = self
                return largeCell
            }
        }
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CategoryCell {
            
            cell.appCatgory = appCategories?[indexPath.item]
            cell.featuredVC = self
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 2 {
            return CGSize(width: (self.collectionView?.frame.width)!, height: 160)
        }
        
        return CGSize(width: (self.collectionView?.frame.width)!, height: 230)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath) as! HeaderCell
        
        header.appCatgory = featuredApps?.bannerCategory
        return header
        
    }
    

}


