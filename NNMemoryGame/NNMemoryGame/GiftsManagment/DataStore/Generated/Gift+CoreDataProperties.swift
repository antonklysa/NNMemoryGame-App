//
//  Gift+CoreDataProperties.swift
//  NNGames
//
//  Created by Yaroslav Brekhunchenko on 6/21/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Gift {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gift> {
        return NSFetchRequest<Gift>(entityName: "Gift")
    }

    @NSManaged public var giftID: Int64
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var scenario: Scenario?
    @NSManaged public var scenarios: NSSet?

}

// MARK: Generated accessors for scenarios
extension Gift {

    @objc(addScenariosObject:)
    @NSManaged public func addToScenarios(_ value: GiftScenario)

    @objc(removeScenariosObject:)
    @NSManaged public func removeFromScenarios(_ value: GiftScenario)

    @objc(addScenarios:)
    @NSManaged public func addToScenarios(_ values: NSSet)

    @objc(removeScenarios:)
    @NSManaged public func removeFromScenarios(_ values: NSSet)

}
