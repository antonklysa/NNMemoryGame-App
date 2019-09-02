//
//  GamePopupViewController.swift
//  Scratch
//
//  Created by  on 2/17/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol GamePopupViewControllerDelegate: class {
    func gamePopupDidFinish(_ vc: GamePopupViewController)
}

class GamePopupViewController: UIViewController {

    var textImage: UIImage!

    weak var delegate: GamePopupViewControllerDelegate?
    
    @IBOutlet weak var textImageView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var popupContainerView: UIView!

    //MARK: UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doneButton.setImage(UIImage(named: AppSettings.defaultSettings.language.isArabic() ? "popup_done_btn_ar" : "popup_done_btn_fr"), for: .normal)
        self.textImageView.image = self.textImage
        
        self.popupContainerView.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.popupContainerView.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.75, animations: {
            self.popupContainerView.transform = CGAffineTransform.identity
            self.popupContainerView.alpha = 1.0
        }) { (flag) in
            print("Popup animation completed \(flag)")
        }
    }
    //MARK: Actions
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.delegate?.gamePopupDidFinish(self)
    }
    
}
