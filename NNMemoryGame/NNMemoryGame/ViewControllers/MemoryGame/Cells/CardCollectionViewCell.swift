//
//  CardCollectionViewCell.swift
//  NNMemoryGame
//
//  Created by Anton Klysa on 6/18/18.
//  Copyright © 2018 Anton Klysa. All rights reserved.
//

import Foundation
import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    static private let closedStringImageName: String = "closed_card_image"
    
    enum CellState {
        case open
        case close
    }
    
    @IBOutlet weak var currentImage: UIImageView!
    
    var cardModel: Card!
    
    //MARK: setup content
    
    final func setCardModel(model: Card) {
        cardModel = model
        currentImage.image = UIImage(named: CardCollectionViewCell.closedStringImageName)
    }
    
    //MARK: actions
    
    final func flip(onCellState: CellState, completionHandler: ((Bool) -> Void)?) {
        
        var newImage: UIImageView!
        let options: UIViewAnimationOptions = [.transitionFlipFromLeft, .allowUserInteraction, .beginFromCurrentState]
        newImage = UIImageView(frame: contentView.bounds)
        newImage.isOpaque = true
        if onCellState == .open {
            newImage.image = UIImage(named: (LocalizationManagers.isArabic() ? cardModel.ar_image : cardModel.fr_image)!)
        } else if onCellState == .close {
            newImage.image = UIImage.init(named: CardCollectionViewCell.closedStringImageName)
        }
        
        UIView.transition(from: currentImage, to: newImage, duration: 0.3, options: options) { (bool) in
            if completionHandler != nil {
                completionHandler!(bool)
            }
        }
        currentImage = newImage
    }
}
