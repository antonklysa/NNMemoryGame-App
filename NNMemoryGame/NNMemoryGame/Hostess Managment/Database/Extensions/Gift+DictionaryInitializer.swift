//
//  Gift+DictionaryInitializer.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 11/20/17.
//  Copyright © 2017 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

extension Gift {
    
    class func entityName() -> String! {
        return "Gift"
    }
    
    static func giftFromDicitonary(giftDict: JSON) -> Gift {
        let gift : Gift = NSEntityDescription.insertNewObject(forEntityName: Gift.entityName(), into: PMIDataSource.defaultDataSource.managedObjectContext) as! Gift
        
        gift.giftID = giftDict["gift_id"].int64Value
        gift.name = giftDict["name"].string
        gift.image = giftDict["image"].string
        gift.type = giftDict["type"].string
        
        return gift
    }
    
}
