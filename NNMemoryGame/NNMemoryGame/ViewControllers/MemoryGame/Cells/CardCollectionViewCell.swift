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
  
    enum CellState {
        case open
        case close
    }
    
    @IBOutlet weak var currentImage: UIImageView!
    
    var cardModel: Card!
    
    //MARK: setup content
    
    final func setCardModel(model: Card) {
        cardModel = model
//        currentImage.image = UIImage(named: CardCollectionViewCell.closedStringImageName)
        let isSoft = PMISessionManager.defaultManager.packChoice == PackChoice.choice0
        currentImage.image = UIImage.init(named: isSoft ? "closed_card_image" : "closed_card_image_soft")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.currentImage.layer.shadowColor = UIColor.black.withAlphaComponent(1.0).cgColor
//        self.currentImage.layer.shadowOffset = CGSize(width: 50.0, height: 50.0)
//        self.currentImage.layer.shadowRadius = 5.0
//        self.currentImage.layer.shadowOpacity = 0.5
//        self.currentImage.layer.masksToBounds = false
//        self.currentImage.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.currentImage.layer.cornerRadius).cgPath
    }
    
    //MARK: actions
    
    final func flip(onCellState: CellState, time: TimeInterval = 0.3, completionHandler: ((Bool) -> Void)?) {
        
        var newImage: UIImageView!
        let options: UIView.AnimationOptions = [.transitionFlipFromLeft, .allowUserInteraction, .beginFromCurrentState]
        newImage = UIImageView(frame: contentView.bounds)
        newImage.isOpaque = true
        if onCellState == .open {
            newImage.image = UIImage(named: (LocalizationManagers.isArabic() ? cardModel.ar_image : cardModel.fr_image)!)
        } else if onCellState == .close {
            let isSoft = PMISessionManager.defaultManager.packChoice == PackChoice.choice0
            newImage.image = UIImage.init(named: isSoft ? "closed_card_image_soft" : "closed_card_image")
        }
        
        UIView.transition(from: currentImage, to: newImage, duration: time, options: options) { (bool) in
            if completionHandler != nil {
                completionHandler!(bool)
            }
        }
        currentImage = newImage
    }}
