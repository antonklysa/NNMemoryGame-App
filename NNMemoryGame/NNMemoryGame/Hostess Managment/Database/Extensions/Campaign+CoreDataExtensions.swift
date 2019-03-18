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
    
    func sortedTouchpoints() -> [Touchpoint] {
        if (self.touchpoints != nil) {
            return self.touchpoints!.sortedArray(using: [NSSortDescriptor(key: "touchpointId", ascending: true)]) as! [Touchpoint]
        } else {
            return []
        }
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
        
        for touchpointDict in campaignDict["touchpoints"].arrayValue {
            let touchpoint : Touchpoint = Touchpoint.touchpointFromDicitonary(touchpointDict: touchpointDict)
            touchpoint.campaign = campaign
            campaign.addToTouchpoints(touchpoint)
        }
        
        let themeDict: JSON = campaignDict["theme"]
        let theme: AppearanceTheme = AppearanceTheme.themeFromJSONDicitonary(themeDict: themeDict)
        campaign.theme = theme
        
        // Set first one scenario as active or previously selected one. Can be changed from Config screen.
        if let priorSelectedTouchpointId: Int64 = PMISessionManager.defaultManager.selectedTouchpointId {
            for touchpoint in campaign.sortedTouchpoints() {
                if (touchpoint.touchpointId == priorSelectedTouchpointId) {
                    campaign.activeTouchpoint = touchpoint
                }
            }
        } else {
            campaign.activeTouchpoint = campaign.sortedTouchpoints().first
            PMISessionManager.defaultManager.selectedTouchpointId = campaign.activeTouchpoint?.touchpointId
        }
        
        return campaign
    }
    
}
