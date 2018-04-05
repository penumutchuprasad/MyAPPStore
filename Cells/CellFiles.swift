//
//  CellFiles.swift
//  MyAPPStore
//
//  Created by Leela Prasad on 03/04/18.
//  Copyright © 2018 Leela Prasad. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}


class AppCell: BaseCell {
    
    var app: APP? {
        didSet{
            if let aplication = app {
                nameLabel.text = aplication.Name
                categoryLabel.text = aplication.Category
                priceLabel.text = "$ \(String(describing: aplication.Price ?? 0))"       //String(describing: aplication.price!)
                imgView.image = UIImage.init(named: aplication.ImageName!)
                
                let rect = NSString.init(string: aplication.Name ?? "").boundingRect(with: CGSize.init(width: frame.width, height: 500), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)], context: nil)
                
                if rect.height > 20 {
                    categoryLabel.frame = CGRect.init(x: 0, y: nameLabel.frame.maxY, width: frame.width, height: 20)
                    priceLabel.frame = CGRect.init(x: 0, y: categoryLabel.frame.maxY, width: frame.width, height: 20)
                }else {
                    categoryLabel.frame = CGRect.init(x: 0, y: nameLabel.frame.maxY-20, width: frame.width, height: 20)
                    priceLabel.frame = CGRect.init(x: 0, y: categoryLabel.frame.maxY, width: frame.width, height: 20)
                    
                }
                
                nameLabel.frame = CGRect.init(x: 0, y: frame.width+2, width: frame.width, height: 40)
                nameLabel.sizeToFit()
            }
        }
       
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
       
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        self.setupViews()
    }
        
    let imgView: UIImageView = {
       
        let iv = UIImageView.init(image: #imageLiteral(resourceName: "app"))
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
       
        let lbl = UILabel.init()
        lbl.text = "Disney Built It: Frozen"
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    let categoryLabel: UILabel = {
        
        let lbl = UILabel.init()
        lbl.text = "Entertainment"
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textColor = .darkGray
        return lbl
    }()
    
    let priceLabel: UILabel = {
        
        let lbl = UILabel.init()
        lbl.text = "$3.99"
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textColor = .darkGray
        return lbl
    }()
    
    override func setupViews() {

       // super.setupViews()
        addSubview(imgView)
        addSubview(nameLabel)
        addSubview(categoryLabel)
        addSubview(priceLabel)
        imgView.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.width)
        nameLabel.frame = CGRect.init(x: 0, y: frame.width+2, width: frame.width, height: 40)
        categoryLabel.frame = CGRect.init(x: 0, y: nameLabel.frame.maxY, width: frame.width, height: 20)
        priceLabel.frame = CGRect.init(x: 0, y: categoryLabel.frame.maxY, width: frame.width, height: 20)
    }
}

class LargeCategoryCell: CategoryCell {
    
    
    // For this cell
    let largeAppCellId = "LargeAppCell"
    
    override func setupViews() {
        super.setupViews()
        appsCollView.register(LargeAppCell.self, forCellWithReuseIdentifier: largeAppCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeAppCellId, for: indexPath) as? LargeAppCell {
            cell.app = appCatgory?.apps![indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: self.frame.height-31)
    }
    
    // Make another Cell For CollView
    
    private class LargeAppCell: AppCell {
        
        override func setupViews() {
            
            addSubview(imgView)
            addConstraintsWithVisualStrings(format: "H:|[v0]|", views: imgView)
            addConstraintsWithVisualStrings(format: "V:|[v0]-8-|", views: imgView)
        }
        
    }
}


class HeaderCell: CategoryCell {
    
    let bannerCellId = "BannerCell"
    
    override func setupViews() {
        //super.setupViews()
        
        appsCollView.delegate = self
        appsCollView.dataSource = self
        addSubview(appsCollView)
        addConstraintsWithVisualStrings(format: "H:|[v0]|", views: appsCollView)
        addConstraintsWithVisualStrings(format: "V:|[v0]|", views: appsCollView)

        appsCollView.register(BannerCell.self, forCellWithReuseIdentifier: bannerCellId)
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bannerCellId, for: indexPath) as? BannerCell {
            cell.app = appCatgory?.apps![indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/2 + 50, height: self.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
  
    
    private class BannerCell: AppCell {
        
        override func setupViews() {
            imgView.layer.borderColor = UIColor.gray.cgColor
            imgView.layer.borderWidth = 0.65
            imgView.layer.cornerRadius = 0
            addSubview(imgView)
            addConstraintsWithVisualStrings(format: "H:|[v0]|", views: imgView)
            addConstraintsWithVisualStrings(format: "V:|[v0]-8-|", views: imgView)
        }
        
    }
}


class AppDetailHeader: BaseCell {
    
    var app: APP? {
        didSet{
            if let imgName = app?.ImageName {
                imgView.image = UIImage.init(named: imgName)
            }
            
            if let name = app?.Name {
                nameLabel.text = name
            }
            
            if let price = app?.Price {
                buyButton.setTitle("$ \(price)", for: .normal)
            }else {
                buyButton.setTitle("Free", for: .normal)
            }
        }
    }
    let imgView: UIImageView = {
       
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "app2")
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        
        let lbl = UILabel.init()
        lbl.text = "App detail NAme Here"
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    let buyButton: UIButton = {
       
        let btn = UIButton.init(type: UIButtonType.system)
        btn.backgroundColor = .clear
        btn.setTitle("BUY", for: .normal)
        btn.layer.borderColor = btn.tintColor.cgColor//UIColor.blue.cgColor
        btn.layer.borderWidth = 1.0
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return btn
    }()
    
    let segmentedControl: UISegmentedControl = {
       
        let sgmnt = UISegmentedControl.init(items: ["Details","Reviews","Related"])
        sgmnt.tintColor = .black
        //sgmnt.backgroundColor = .yellow
        sgmnt.selectedSegmentIndex = 0
        return sgmnt
    }()
    
    let deviderLineView: UIView = {
       
        let dvdr = UIView()
        dvdr.backgroundColor = .gray
        
        return dvdr
        
    }()
    
    override func setupViews() {
        super.setupViews()
    
        addSubview(imgView)
        addSubview(nameLabel)
        addSubview(segmentedControl)
        addSubview(buyButton)
        addSubview(deviderLineView)
        
        addConstraintsWithVisualStrings(format: "H:|-14-[v0(100)]-14-[v1]|", views: imgView,nameLabel)
        addConstraintsWithVisualStrings(format: "V:|-14-[v0(100)]", views: imgView)
        addConstraintsWithVisualStrings(format: "V:|-14-[v0(25)]", views: nameLabel)
        addConstraintsWithVisualStrings(format: "H:|-40-[v0]-40-|", views: segmentedControl)
        addConstraintsWithVisualStrings(format: "V:[v0(35)]-8-[v1(35)]-8-|", views: buyButton,segmentedControl)
        addConstraintsWithVisualStrings(format: "H:[v0(75)]-14-|", views: buyButton)
        addConstraintsWithVisualStrings(format: "H:|[v0]|", views: deviderLineView)
        addConstraintsWithVisualStrings(format: "V:[v0(1.0)]|", views: deviderLineView)
        
    }
}


class ScreenShotsCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   

    var app:APP? {
        didSet{
            screenShotsCollView.reloadData()
        }
    }
    
    let cellId = "screenShotImgCell"
    
    lazy var screenShotsCollView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.register(screenShotImgCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    let deviderLineView: UIView = {
        let dvdr = UIView()
        dvdr.backgroundColor = .gray
        return dvdr
    }()
    
    override func setupViews() {
        
        addSubview(screenShotsCollView)
        addSubview(deviderLineView)
        
        addConstraintsWithVisualStrings(format: "H:|[v0]|", views: screenShotsCollView)
        addConstraintsWithVisualStrings(format: "V:|-3-[v0]-3-|", views: screenShotsCollView)
        addConstraintsWithVisualStrings(format: "H:|[v0]|", views: deviderLineView)
        addConstraintsWithVisualStrings(format: "V:[v0(2.0)]|", views: deviderLineView)
    }
    
    //MARK: CollView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return app?.Screenshots?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! screenShotImgCell
        cell.imgView.image = UIImage.init(named: (app?.Screenshots![indexPath.item])!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width-75, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
}



class screenShotImgCell: BaseCell {
    
    let imgView: UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "app2")
        //iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    override func setupViews() {
    
        addSubview(imgView)
        
        addConstraintsWithVisualStrings(format: "H:|[v0]|", views: imgView)
        addConstraintsWithVisualStrings(format: "V:|-3-[v0]-3-|", views: imgView)
        
    }
}

class AppDetaildescCell: BaseCell {
    
    let textView: UITextView = {
       
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.text = "Description goes here"
        return tv
    }()
    
    let deviderLineView: UIView = {
        let dvdr = UIView()
        dvdr.backgroundColor = .gray
        return dvdr
    }()
    
    
    override func setupViews() {
        
       // backgroundColor = .magenta
        addSubview(textView)
        addSubview(deviderLineView)
        
        addConstraintsWithVisualStrings(format: "H:|-8-[v0]-8-|", views: textView)
        addConstraintsWithVisualStrings(format: "V:|-4-[v0]-4-[v1(1.5)]|", views: textView,deviderLineView)
        addConstraintsWithVisualStrings(format: "H:|[v0]|", views: deviderLineView)
        
        
    }
}



class AppInformationCell: BaseCell {
    
    let textView: UITextView = {
        
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.text = "App Info goes here"
        return tv
    }()
    
    let deviderLineView: UIView = {
        let dvdr = UIView()
        dvdr.backgroundColor = .gray
        return dvdr
    }()
    
    
    override func setupViews() {
        
        // backgroundColor = .magenta
        addSubview(textView)
        addSubview(deviderLineView)
        
        addConstraintsWithVisualStrings(format: "H:|-8-[v0]-8-|", views: textView)
        addConstraintsWithVisualStrings(format: "V:|-4-[v0]-4-[v1(1.5)]|", views: textView,deviderLineView)
        addConstraintsWithVisualStrings(format: "H:|[v0]|", views: deviderLineView)
        
        
    }
}

















