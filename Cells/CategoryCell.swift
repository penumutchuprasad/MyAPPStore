//
//  CategoryCell.swift
//  MyAPPStore
//
//  Created by Leela Prasad on 03/04/18.
//  Copyright © 2018 Leela Prasad. All rights reserved.
//

import UIKit

class CategoryCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var featuredVC: FeaturedVC?
    
    var appCatgory: AppCategory? {
        didSet{
            if let name = appCatgory?.name {
                nameLabel.text = name
            }
            appsCollView.reloadData()
        }
    }

    let nameLabel: UILabel = {
        
        let lbl = UILabel.init()
        lbl.text = "Best New Apps"
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        return lbl
    }()
    
   lazy var appsCollView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.backgroundColor = .white
        cv.register(AppCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    let dividerLineView: UIView = {
       
        let dvdrView = UIView()
        dvdrView.backgroundColor = UIColor.init(white: 0.4, alpha: 0.4)
        
        return dvdrView
    }()
    
    let cellId = "AppCell"
    
    override func setupViews() {
        

        appsCollView.delegate = self
        appsCollView.dataSource = self
        
        addSubview(appsCollView)
        addSubview(dividerLineView)
        addSubview(nameLabel)
        
        //Constraints For AppsCollView
        addConstraintsWithVisualStrings(format: "H:|-5-[v0]-5-|", views: appsCollView)
        addConstraintsWithVisualStrings(format: "V:|[v0(30)][v1][v2(0.75)]|", views: nameLabel,appsCollView,dividerLineView)
        addConstraintsWithVisualStrings(format: "H:|-8-[v0]|", views: dividerLineView)
        addConstraintsWithVisualStrings(format: "H:|-14-[v0]|", views: nameLabel)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appCatgory?.apps!.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AppCell {
            cell.app = appCatgory?.apps![indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: self.frame.height-31)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        featuredVC?.showAppDetailVC(forAPP: (appCatgory?.apps![indexPath.item])!)
    }
   
    
}

