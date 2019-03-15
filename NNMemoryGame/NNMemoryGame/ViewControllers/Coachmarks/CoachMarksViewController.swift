//
//  CoachMarksViewController.swift
//  Scratch
//
//  Created by Yaroslav Brekhunchenko on 2/17/19.
//  Copyright © 2019 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit

protocol CoachMarksViewControllerDelegate: class {
    func coachMarksViewControllerDidFinish(_ vc: CoachMarksViewController)
}

class CoachMarksViewController: UIViewController {

    weak var delegate: CoachMarksViewControllerDelegate?
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.image = UIImage(named: "coachamrks_image_\(AppSettings.defaultSettings.language.prefixLanguage())")
        doneButton.setImage(UIImage(named: "coachamrks_done_btn_\(AppSettings.defaultSettings.language.prefixLanguage())"), for: .normal)
    }

    //MARK: Actions
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.delegate?.coachMarksViewControllerDidFinish(self)
    }
    
}
