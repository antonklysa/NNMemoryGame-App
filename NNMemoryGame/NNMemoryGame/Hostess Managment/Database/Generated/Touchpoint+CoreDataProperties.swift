//
//  Touchpoint+CoreDataProperties.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 9/19/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Touchpoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Touchpoint> {
        return NSFetchRequest<Touchpoint>(entityName: "Touchpoint")
    }

    @NSManaged public var tochpointName: String?
    @NSManaged public var touchpointId: Int64
    @NSManaged public var touchpointImage: String?
    @NSManaged public var campaign: Campaign?
    @NSManaged public var scenarios: NSSet?
    @NSManaged public var activeCampaign: Campaign?
    @NSManaged public var activeScenario: Scenario?

}

// MARK: Generated accessors for scenarios
extension Touchpoint {

    @objc(addScenariosObject:)
    @NSManaged public func addToScenarios(_ value: Scenario)

    @objc(removeScenariosObject:)
    @NSManaged public func removeFromScenarios(_ value: Scenario)

    @objc(addScenarios:)
    @NSManaged public func addToScenarios(_ values: NSSet)

    @objc(removeScenarios:)
    @NSManaged public func removeFromScenarios(_ values: NSSet)

}
