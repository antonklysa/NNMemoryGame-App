//
//  Touchpoint+CoreDataProperties.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 9/18/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

extension Touchpoint {
    
    class func entityName() -> String! {
        return "Touchpoint"
    }
    
    func sortedScenarios() -> [Scenario] {
        if (self.scenarios != nil) {
            return self.scenarios!.sortedArray(using: [NSSortDescriptor(key: "scenarioId", ascending: true)]) as! [Scenario]
        } else {
            return []
        }
    }
    
    static func touchpointFromDicitonary(touchpointDict: JSON) -> Touchpoint {
        let touchpoint : Touchpoint = NSEntityDescription.insertNewObject(forEntityName: Touchpoint.entityName(), into: PMIDataSource.defaultDataSource.managedObjectContext) as! Touchpoint
        touchpoint.touchpointId = touchpointDict["touchpoint_id"].int64Value
        touchpoint.tochpointName = touchpointDict["touchpoint_name"].stringValue
        touchpoint.touchpointImage = touchpointDict["touchpoint_image"].stringValue
        
        for scenarioDict in touchpointDict["scenarios"].arrayValue {
            let scenario : Scenario = Scenario.scenarioFromJSONDicitonary(scenarioDict: scenarioDict)
            scenario.touchpoint = touchpoint
            touchpoint.addToScenarios(scenario)
        }
        
        return touchpoint
    }
    
}
