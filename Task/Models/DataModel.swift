//
//  DataModel.swift
//  NewsSearchApp
//
//  Created by Practice on 04/10/19.
//  Copyright © 2019 Practice. All rights reserved.
//

import UIKit
import CoreData

class DataModel: NSObject {
    
    var title:String
    var descrption:String
     var image:String?
     var date :String
    
    override init(){
        title = ""
        descrption = ""
        image = ""
        date = ""
    }
    
    
    init(titleName_N: String, descrption_N:String,image_N: String, date_N:String){
        title = titleName_N
        descrption = descrption_N
        image = image_N
        date = date_N
    }
    
    
    class func getResponseWithData(results:[Any]) -> [DataModel] {
        
        var newsDataModel = [DataModel]()
        var newsDataModelList:DataModel?
        
        for row in results {
            newsDataModelList = DataModel()
            newsDataModelList?.title = (row as AnyObject).value(forKey: "title") as! String
            newsDataModelList?.descrption = (row as AnyObject).value(forKey: "description") as! String
            newsDataModelList?.image = (row as AnyObject).value(forKey: "urlToImage") as? String
            newsDataModelList?.date = (row as AnyObject).value(forKey: "publishedAt") as! String
            newsDataModel.append((newsDataModelList)!)
        }
        return newsDataModel
    }
    
}

