//
//  Models.swift
//  MyAPPStore
//
//  Created by Leela Prasad on 03/04/18.
//  Copyright © 2018 Leela Prasad. All rights reserved.
//

import UIKit


class FeaturedApps: NSObject {
    
    var bannerCategory: AppCategory?
    var appCategories: [AppCategory]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "categories" {
            appCategories = [AppCategory]()
            
            for dict in value as! [[String: AnyObject]] {
                let appCategory = AppCategory()
                appCategory.setValuesForKeys(dict)
                appCategories?.append(appCategory)
            }
            
            
        }else if key == "bannerCategory" {
            bannerCategory = AppCategory()
            bannerCategory?.setValuesForKeys(value as! [String: AnyObject])
            
        }else {
            print("hope it is not the case")
            super.setValue(value, forKey: key)
        }
        
        
    }
    
}


class AppCategory: NSObject {
    
    var name: String?
    
    var apps: [APP]?
    
    var type: String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "type" {
            
            //print("OKKKKK")
        } else if key == "name" {
            
            self.name = value as? String
            //print("tekekeke")

        } else {
            
            apps = [APP]()
            
            for dict in value as! [[String: AnyObject]] {
                
                let app = APP()
                app.setValuesForKeys(dict)
                
                apps?.append(app)
                
            }
            
        }
    }
    
    static func fetchFeaturedApps(completionHandler: @escaping (FeaturedApps)->()) {
        
        let url = "https://api.letsbuildthatapp.com/appstore/featured"
        
        URLSession.shared.dataTask(with: URL.init(string: url)!) { (data, responce, error) in
            
            if error != nil {
                print("Chale ika apu")
                return
            }
            
            do {
                
                let jsonResp = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                let featuredApps = FeaturedApps()
                
                featuredApps.setValuesForKeys((jsonResp))
                
//                var appcats = [AppCategory]()
//
//                for dict in jsonResp["categories"] as! [[String:AnyObject]] {
//
//                    let appcat = AppCategory()
//
//                    for app in dict {
//                        appcat.setValuesForKeys([app.key: app.value])
//                        //print(app.key)
//                    }
//
//                    //print(dict)
//                    appcats.append(appcat)
//                }
                DispatchQueue.main.async(execute: {
                    completionHandler(featuredApps)
                })
               // print(appcats)
                
            } catch let err {
                print("oookokokoko \(err)")
            }
        }.resume()
        
    }
    
}

class APP: NSObject {
    
    var Id: NSNumber?
    var Name: String?
    var Category: String?
    var ImageName: String?
    var Price: NSNumber?
    
    var descr: String?
    var Screenshots: [String]?
    var appInformation: [[String:AnyObject]]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "Id" {
            self.Id = value as? NSNumber
        }else if key == "Name" {
            self.Name = value as? String
        }else if key == "Category" {
            self.Category = value as? String
        }else if key == "Price" {
            self.Price = value as? NSNumber
        }else if key == "description" {
            self.descr = value as? String
        }else if key == "Screenshots" {
            self.Screenshots = value as? [String]
        }else if key == "appInformation" {
            self.appInformation = value as? [[String:AnyObject]]
        }else {
            self.ImageName = value as? String
        }
    }
    
}
