//
//  GiftTableViewCell.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 11/26/17.
//  Copyright © 2017 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit
import PINCache

class GiftTableViewCell: UITableViewCell {

    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var queuePositionLabel: UILabel!

    var giftScenario : GiftScenario? {
        
        didSet {
            let imageName : String = (giftScenario!.gift!.image)!
            giftImageView.image = PINCache.shared.diskCache.object(forKey: imageName.pinCacheStringKey()) as! UIImage!
            nameLabel.text = giftScenario!.gift?.name
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd hh:mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            let distributionTimeString = formatter.string(from: giftScenario!.distributionTime! as Date)
            queuePositionLabel.text = String(format: "Distribution time %@", distributionTimeString)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
