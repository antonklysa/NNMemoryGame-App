//
//  Scenario+CoreDataProperties.swift
//  NNGames
//
//  Created by Yaroslav Brekhunchenko on 6/21/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Scenario {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Scenario> {
        return NSFetchRequest<Scenario>(entityName: "Scenario")
    }

    @NSManaged public var channelId: Int64
    @NSManaged public var created: NSDate?
    @NSManaged public var giftRemain: Int64
    @NSManaged public var premiumsWonThisSession: Int64
    @NSManaged public var scenarioName: String?
    @NSManaged public var activeScenarioCampaign: Campaign?
    @NSManaged public var campaign: Campaign?
    @NSManaged public var gifts: NSSet?
    @NSManaged public var giftScenarios: NSSet?

}

// MARK: Generated accessors for gifts
extension Scenario {

    @objc(addGiftsObject:)
    @NSManaged public func addToGifts(_ value: Gift)

    @objc(removeGiftsObject:)
    @NSManaged public func removeFromGifts(_ value: Gift)

    @objc(addGifts:)
    @NSManaged public func addToGifts(_ values: NSSet)

    @objc(removeGifts:)
    @NSManaged public func removeFromGifts(_ values: NSSet)

}

// MARK: Generated accessors for giftScenarios
extension Scenario {

    @objc(addGiftScenariosObject:)
    @NSManaged public func addToGiftScenarios(_ value: GiftScenario)

    @objc(removeGiftScenariosObject:)
    @NSManaged public func removeFromGiftScenarios(_ value: GiftScenario)

    @objc(addGiftScenarios:)
    @NSManaged public func addToGiftScenarios(_ values: NSSet)

    @objc(removeGiftScenarios:)
    @NSManaged public func removeFromGiftScenarios(_ values: NSSet)

}
