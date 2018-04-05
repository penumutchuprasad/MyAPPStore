//
//  AppDetailVC.swift
//  MyAPPStore
//
//  Created by Leela Prasad on 04/04/18.
//  Copyright © 2018 Leela Prasad. All rights reserved.
//

import UIKit

class AppDetailVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var app: APP? {
        didSet{
            if app?.Screenshots?.count != nil {
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                return
            }
            navigationItem.title = app?.Name
            getScreenshotsForTheApp(id: ((app?.Id) ?? 1))
        }
        
    }
    
    let screenShotCellId = "ScreenShotsCell"
    let headerId = "AppDetailHeader"
    let descriptionCellId = "AppDetaildescCell"
    let appInfoCellId = "AppInformationCell"
    private let reuseIdentifier = "Cell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(ScreenShotsCell.self, forCellWithReuseIdentifier: screenShotCellId)
        self.collectionView?.register(AppDetaildescCell.self, forCellWithReuseIdentifier: descriptionCellId)
        self.collectionView?.register(AppInformationCell.self, forCellWithReuseIdentifier: appInfoCellId)

        self.collectionView?.register(AppDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }

    func getScreenshotsForTheApp(id: NSNumber) {
        
        let urlString = "https://api.letsbuildthatapp.com/appstore/appdetail?id=\(id)"
        
        URLSession.shared.dataTask(with: URL.init(string: urlString)!) { (data, response, errr) in
            
            if errr != nil {
                print("Error Got!.. Make it Clear")
                return
            }
            
            do {
              
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                //print(jsonResponse)
                let appdetail = APP()
                appdetail.setValuesForKeys(jsonResponse)
                self.app = appdetail
                
            } catch let err {
                print(err)
            }
            
        }.resume()
        
    }
    
    func descriptionAttributedText()-> NSAttributedString {
        
        let descriptionString = NSMutableAttributedString.init(string: "Description:\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16),NSAttributedStringKey.foregroundColor : UIColor.black])
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        
        let range = NSMakeRange(0, descriptionString.string.count)
        descriptionString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: range)
        
        if let desc = app?.descr {
            descriptionString.append(NSAttributedString.init(string: desc, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor : UIColor.gray]))
        }
        
        return descriptionString
        
    }
    
    func appInformationDetails()-> NSAttributedString {
        
        let appInfoString = NSMutableAttributedString.init(string: "APP Information:\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16),NSAttributedStringKey.foregroundColor : UIColor.black])
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        
        let range = NSMakeRange(0, appInfoString.string.count)
        appInfoString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: range)
        
        if let info = app?.appInformation {

            for dict in info {
                let rowheader = dict["Name"] as! String
                let rowvalue = dict["Value"] as! String
                
                let row = "\(rowheader):      \(rowvalue) \n"
                
                appInfoString.append(NSAttributedString.init(string: row, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor : UIColor.gray]))
            }
            
        }
        
        return appInfoString
        
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionCellId, for: indexPath) as! AppDetaildescCell
            
            cell.textView.attributedText = self.descriptionAttributedText()
            return cell
            
        }
        
        if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: appInfoCellId, for: indexPath) as! AppInformationCell
            
            cell.textView.attributedText = appInformationDetails()
            return cell
            
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: screenShotCellId, for: indexPath) as! ScreenShotsCell
    
        cell.app = self.app
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estRect = CGSize(width: self.view.frame.width, height: 5000)

        if indexPath.item == 1 {
            let rect = self.descriptionAttributedText().boundingRect(with: estRect, options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), context: nil)
            
            return CGSize(width: self.view.frame.width, height: rect.height+30)
        }else if indexPath.item == 2 {
            let rect = self.appInformationDetails().boundingRect(with: estRect, options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), context: nil)
            
            return CGSize(width: self.view.frame.width, height: rect.height+30)
        }
        return CGSize(width: self.view.frame.width, height: 175)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 175)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppDetailHeader
        header.app = self.app
        return header
    }
    
}
