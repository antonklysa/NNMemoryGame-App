//
//  AppearanceTheme+CoreDataExtensions.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 4/16/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

extension AppearanceTheme {

    class func entityName() -> String! {
        return "AppearanceTheme"
    }
    
    static func themeFromJSONDicitonary(themeDict: JSON) -> AppearanceTheme {
        let theme: AppearanceTheme = NSEntityDescription.insertNewObject(forEntityName: AppearanceTheme.entityName(), into: PMIDataSource.defaultDataSource.managedObjectContext) as! AppearanceTheme
        
        theme.backgroundImageURL = themeDict["background_image"].string
        theme.homeImageURL = themeDict["home_image"].string
        theme.startButtonImageURL = themeDict["start_button_image"].string
        theme.endButtonImageURL = themeDict["end_button_image"].string
//        theme.carouselBorderColor = UIColor.hexStringToUIColor(hex: themeDict["roulette_border_color"].string!)
        
        return theme
    }
    
}
