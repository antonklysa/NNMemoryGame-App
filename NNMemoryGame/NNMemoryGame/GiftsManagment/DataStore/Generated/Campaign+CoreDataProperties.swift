//
//  Campaign+CoreDataProperties.swift
//  NNGames
//
//  Created by Yaroslav Brekhunchenko on 6/21/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Campaign {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Campaign> {
        return NSFetchRequest<Campaign>(entityName: "Campaign")
    }

    @NSManaged public var applicationType: String?
    @NSManaged public var city: String?
    @NSManaged public var hostessId: String?
    @NSManaged public var name: String?
    @NSManaged public var sessionid: String?
    @NSManaged public var scenarios: NSSet?
    @NSManaged public var theme: AppearanceTheme?

}

// MARK: Generated accessors for scenarios
extension Campaign {

    @objc(addScenariosObject:)
    @NSManaged public func addToScenarios(_ value: Scenario)

    @objc(removeScenariosObject:)
    @NSManaged public func removeFromScenarios(_ value: Scenario)

    @objc(addScenarios:)
    @NSManaged public func addToScenarios(_ values: NSSet)

    @objc(removeScenarios:)
    @NSManaged public func removeFromScenarios(_ values: NSSet)

}
