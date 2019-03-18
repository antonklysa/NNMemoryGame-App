//
//  GiftScenario+CoreDataProperties.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 9/19/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension GiftScenario {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GiftScenario> {
        return NSFetchRequest<GiftScenario>(entityName: "GiftScenario")
    }

    @NSManaged public var distributed: Bool
    @NSManaged public var distributionTime: NSDate?
    @NSManaged public var queuePosition: Int64
    @NSManaged public var gift: Gift?
    @NSManaged public var scenario: Scenario?

}
