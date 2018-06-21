//
//  ChannelTableViewCell.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 4/16/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {

    @IBOutlet weak var channelNameLabel: UILabel!

    var channel: Scenario! {
        didSet {
            self.channelNameLabel.text = channel.scenarioName
        }
    }
    
}
