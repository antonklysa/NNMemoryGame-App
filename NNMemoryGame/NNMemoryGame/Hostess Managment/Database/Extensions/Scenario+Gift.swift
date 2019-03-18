//
//  Scenario+Gift.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 11/20/17.
//  Copyright © 2017 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit

extension Scenario {

    func distributedGiftScenarios() -> [GiftScenario] {
        var distributedGifts : [GiftScenario] = []
        if (self.giftScenarios?.count != nil) {
            for giftScenario in self.giftScenarios as! Set<GiftScenario> {
                if (giftScenario.distributed == true) {
                    distributedGifts.append(giftScenario)
                }
            }
            distributedGifts.sort{ $0.queuePosition > $1.queuePosition }
            return distributedGifts
        } else {
            return []
        }
    }
    
    func notDistributedGiftScenarios() -> [GiftScenario] {
        var notDistributedGifts : [GiftScenario] = []
        if (self.giftScenarios?.count != nil) {
            for giftScenario in self.giftScenarios as! Set<GiftScenario> {
                if (giftScenario.distributed == false) {
                    notDistributedGifts.append(giftScenario)
                }
            }
            notDistributedGifts.sort{ $0.queuePosition < $1.queuePosition }
            return notDistributedGifts
        } else {
            return []
        }
    }
    
    func listOfAllGifts() -> [Gift] {
        var listOfAllGifts = self.gifts?.allObjects as! [Gift]
        listOfAllGifts.sort { $0.giftID > $1.giftID }
        return listOfAllGifts
    }
    
    func getNextGiftScenario() -> GiftScenario? {
        return self.notDistributedGiftScenarios().first
    }
    
}
