//
//  Campaign+CoreDataProperties.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 9/19/18.
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
    @NSManaged public var activeTouchpoint: Touchpoint?
    @NSManaged public var theme: AppearanceTheme?
    @NSManaged public var touchpoints: NSSet?

}

// MARK: Generated accessors for touchpoints
extension Campaign {

    @objc(addTouchpointsObject:)
    @NSManaged public func addToTouchpoints(_ value: Touchpoint)

    @objc(removeTouchpointsObject:)
    @NSManaged public func removeFromTouchpoints(_ value: Touchpoint)

    @objc(addTouchpoints:)
    @NSManaged public func addToTouchpoints(_ values: NSSet)

    @objc(removeTouchpoints:)
    @NSManaged public func removeFromTouchpoints(_ values: NSSet)

}
