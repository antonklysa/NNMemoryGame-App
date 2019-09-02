//
//  LoseViewController.swift
//  NNGames
//
//  Created by  on 6/15/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class LoseViewController: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = UIImage(named: "lose_thanks_\(AppSettings.defaultSettings.language.prefixLanguage())")
        self.imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureCatched(_:)))
        self.imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureCatched(_ gesture: UITapGestureRecognizer) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
