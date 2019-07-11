//
//  CongratulationsWinViewController.swift
//  Scratch
//
//  Created by Yaroslav Brekhunchenko on 2/18/19.
//  Copyright © 2019 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit

class CongratulationsWinViewController: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = UIImage(named: "congratulations_win_\(AppSettings.defaultSettings.language.prefixLanguage())")
        self.imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureCatched(_:)))
        self.imageView.addGestureRecognizer(tapGesture)
    }

    @objc func tapGestureCatched(_ gesture: UITapGestureRecognizer) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
