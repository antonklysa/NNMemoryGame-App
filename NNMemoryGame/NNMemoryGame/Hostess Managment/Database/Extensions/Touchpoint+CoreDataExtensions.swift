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

    func sortedScenariosForPackChoice(_ packChoice: PackChoice) -> [Scenario] {
      let isPOS: Bool = PMIDataSource.defaultDataSource.activeCampaign()?.activeTouchpoint?.tochpointName == "POS"
      let scenarioNames: [String] = self.scenarioNamesForPackChoice(packChoice, isPOS: isPOS)
      
      var scenarios: [Scenario] = []
      for scenarioName in scenarioNames {
        if let scenario: Scenario = self.scenarioWithName(scenarioName) {
          scenarios.append(scenario)
        }
      }
      return scenarios
    }
  
    func scenarioNamesForPackChoice(_ packChoice: PackChoice, isPOS: Bool) -> [String] {
      var scenarioNames: [String] = []
      if isPOS {
        if packChoice == .choice0 {
          scenarioNames  = ["Pos-box-stick",
                            "Pos-box-one-pack",
                            "Pos-box-two-packs"]
        } else {
          scenarioNames  = ["Pos-soft-stick",
                            "Pos-soft-one-pack",
                            "Pos-soft-two-packs"]
        }
      } else {
        if packChoice == .choice0 {
          scenarioNames  = ["Rural-soft-stick",
                            "Rural-soft-one-pack",
                            "Rural-soft-two-packs",
                            "Rural-soft-five-packs",
                            "Rural-soft-bundle"]
        } else {
          scenarioNames  = ["Rural-box-stick",
                            "Rural-box-one-pack",
                            "Rural-box-two-packs",
                            "Rural-box-five-packs",
                            "Rural-box-bundle"]
        }
      }
      return scenarioNames
    }
  
    func scenarioWithName(_ scenarioName: String) -> Scenario? {
      for scenario in self.sortedScenarios() {
        if scenario.scenarioName == scenarioName {
          return scenario
        }
      }
      print("Error. There is no scenario with name \( scenarioName).")
      return nil
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
