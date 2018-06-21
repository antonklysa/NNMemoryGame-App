//
//  SelectDifficultyCollectionViewCell.swift
//  NN
//
//  Created by Yaroslav Brekhunchenko on 3/26/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit

class SelectDifficultyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var difficultyLevel : Difficulty! {
        didSet {
            let imageName = String(format :"level_%d", difficultyLevel.rawValue)
            imageView.image = UIImage(named: imageName)
        }
    }
    
}
