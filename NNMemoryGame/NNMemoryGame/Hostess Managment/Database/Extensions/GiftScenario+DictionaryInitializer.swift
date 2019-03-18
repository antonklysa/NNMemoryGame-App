//
//  GiftScenario+DictionaryInitializer.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 11/20/17.
//  Copyright © 2017 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

extension GiftScenario {
    
    class func entityName() -> String! {
        return "GiftScenario"
    }
    
    static func giftScenarioFromDicitonary(giftDict: JSON, scenario: Scenario) -> GiftScenario {
        let giftScenario : GiftScenario = NSEntityDescription.insertNewObject(forEntityName: GiftScenario.entityName(), into: PMIDataSource.defaultDataSource.managedObjectContext) as! GiftScenario
        
        let giftID : Int64 = giftDict["gift_id"].int64Value
//        giftScenario.gift = PMIDataSource.defaultDataSource.giftWithID(giftID, scenarioID: scenario.scenarioId)
        giftScenario.gift = PMIDataSource.defaultDataSource.giftWithID(giftID, scenarioID: scenario.scenarioId)
        giftScenario.queuePosition = giftDict["queue_position"].int64Value
        giftScenario.distributed = false
        giftScenario.distributionTime = nil
        
        return giftScenario
    }
    
}

