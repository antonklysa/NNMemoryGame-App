//
//  AppearanceTheme+CoreDataProperties.swift
//  NNGames
//
//  Created by Yaroslav Brekhunchenko on 6/21/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension AppearanceTheme {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppearanceTheme> {
        return NSFetchRequest<AppearanceTheme>(entityName: "AppearanceTheme")
    }

    @NSManaged public var backgroundImageURL: String?
    @NSManaged public var carouselBorderColor: NSObject?
    @NSManaged public var endButtonImageURL: String?
    @NSManaged public var homeImageURL: String?
    @NSManaged public var startButtonImageURL: String?
    @NSManaged public var campaign: Campaign?

}
