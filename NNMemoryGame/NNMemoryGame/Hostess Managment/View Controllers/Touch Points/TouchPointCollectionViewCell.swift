//
//  TouchPointCollectionViewCell.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 9/18/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit
import PINCache

class TouchPointCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var scenario: Scenario! {
        didSet {
            self.imageView.image = PINCache.shared.diskCache.object(forKey: scenario.scenarioImage!.pinCacheStringKey()) as? UIImage
        }
    }
    
    
}
