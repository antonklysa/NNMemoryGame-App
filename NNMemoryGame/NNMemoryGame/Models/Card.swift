//
//  Card.swift
//  NNMemoryGame
//
//  Created by Anton Klysa on 6/18/18.
//  Copyright © 2018 Anton Klysa. All rights reserved.
//

import Foundation
import UIKit
import Mantle

class Card: MTLModel, MTLJSONSerializing {
    
    @objc var group_id: NSNumber?
    @objc var ar_image: String?
    @objc var fr_image: String?
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "group_id": "group_id",
            "ar_image": "ar_image",
            "fr_image": "fr_image"]
    }
    
    //MARK: actions
    
    func addressHeap<T: AnyObject>(o: T) -> Int {
        return unsafeBitCast(o, to: Int.self)
    }
}
