//
//  Campaign+CoreDataExtensions.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 4/12/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

extension Campaign {
    
    class func entityName() -> String! {
        return "Campaign"
    }
    
    func sortedScenarios() -> [Scenario] {
        if (self.scenarios != nil) {
            return self.scenarios!.sortedArray(using: [NSSortDescriptor(key: "channelId", ascending: true)]) as! [Scenario]
        } else {
            return []
        }
    }
    
    func activeScenario() -> Scenario? {
        let difficulty: Difficulty = PMIDataSource.defaultDataSource.difficulty
        let hostessCampaign: HostessCampaign = PMIDataSource.defaultDataSource.hostessCampaign
        let targetScenarioName: String = String(format: "%@_%@", hostessCampaign.scenarioNamePrefix(), difficulty.scenarioNamePostfix())
        for scenario in self.sortedScenarios() {
            if (scenario.scenarioName == targetScenarioName) {
                return scenario
            }
        }
        
        let alert = UIAlertController(title: "Error", message: "There is no scenario with name: \(targetScenarioName)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        UIApplication.shared.keyWindow!.rootViewController!.present(alert, animated: true, completion: nil)
        
        return nil
    }
    
    static func campaignFromJSONDicitonary(campaignDict: JSON) -> Campaign {
        let campaign : Campaign = NSEntityDescription.insertNewObject(forEntityName: Campaign.entityName(),
                                                                      into: PMIDataSource.defaultDataSource.managedObjectContext) as! Campaign
        
        campaign.sessionid = campaignDict["session_id"].string
        campaign.applicationType = campaignDict["application_type"].string
        campaign.hostessId = campaignDict["hostess_id"].string
        campaign.city = campaignDict["city"].string
        campaign.name = campaignDict["campaign_name"].string
        if let password: String = campaignDict["new_password"].string {
            PMISessionManager.defaultManager.password = password
        }
        
        for scenarioDict in campaignDict["channels"].arrayValue {
            let scenario : Scenario = Scenario.scenarioFromJSONDicitonary(scenarioDict: scenarioDict)
            scenario.campaign = campaign
            campaign.addToScenarios(scenario)
        }
        
        let themeDict: JSON = campaignDict["theme"]
        let theme: AppearanceTheme = AppearanceTheme.themeFromJSONDicitonary(themeDict: themeDict)
        campaign.theme = theme
        
        // Set first one scenario as active or previously selected one. Can be changed from Config screen.
//        if let priorSelectedChannelId: Int64 = PMISessionManager.defaultManager.selectedChannelId {
//            for scenario in campaign.sortedScenarios() {
//                if (scenario.channelId == priorSelectedChannelId) {
//                    campaign.activeScenario = scenario
//                }
//            }
//        } else {
//            campaign.activeScenario = campaign.sortedScenarios().first
//            PMISessionManager.defaultManager.selectedChannelId = campaign.activeScenario?.channelId
//        }
        
        return campaign
    }
    
}
