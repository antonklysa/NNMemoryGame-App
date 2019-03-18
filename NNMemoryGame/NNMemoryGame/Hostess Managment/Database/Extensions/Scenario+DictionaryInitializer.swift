//
//  Scenario+DictionaryInitializer.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 11/17/17.
//  Copyright © 2017 Yaroslav Brekhunchenko. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

extension Scenario {
    
    class func entityName() -> String! {
        return "Scenario"
    }
    
    static func scenarioFromJSONDicitonary(scenarioDict: JSON) -> Scenario {
        let scenario : Scenario = NSEntityDescription.insertNewObject(forEntityName: Scenario.entityName(), into: PMIDataSource.defaultDataSource.managedObjectContext) as! Scenario
        scenario.giftRemain = 0
        scenario.created = NSDate()
        scenario.premiumsWonThisSession = scenarioDict["premiums_won_this_session"].int64Value
        scenario.scenarioId = scenarioDict["id"].int64Value
        scenario.scenarioName = scenarioDict["name"].string
        scenario.scenarioImage = scenarioDict["level_image"].string
        scenario.levelName = scenarioDict["level_name"].string
        
        for giftDict in scenarioDict["stock"].arrayValue {
            let gift : Gift = Gift.giftFromDicitonary(giftDict: giftDict)
            gift.scenario = scenario
            scenario.addToGifts(gift)
        }
        
        for giftScenarioDict in scenarioDict["scenario"].arrayValue {
            let giftScenario : GiftScenario = GiftScenario.giftScenarioFromDicitonary(giftDict: giftScenarioDict, scenario: scenario)
            giftScenario.scenario = scenario
            scenario.addToGiftScenarios(giftScenario)
        }
        
        return scenario
    }

}
