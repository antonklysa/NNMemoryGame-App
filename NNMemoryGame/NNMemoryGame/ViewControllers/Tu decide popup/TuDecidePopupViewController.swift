//
//  TuDecidePopupViewController.swift
//  PuzzleGame2019
//
//  Created by  on 3/4/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import QuartzCore

class TuDecidePopupViewController: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.imageView.image = UIImage(named: "tu_decide_popup_\(AppSettings.defaultSettings.language.prefixLanguage())")
    self.imageView.isUserInteractionEnabled = true
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureCatched(_:)))
    self.imageView.addGestureRecognizer(tapGesture)
  }
  
  @objc func tapGestureCatched(_ gesture: UITapGestureRecognizer) {
    let vc: CongratulationsWinViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CongratulationsWinViewController") as! CongratulationsWinViewController
    let transition = CATransition()
    transition.duration = 0.5
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    transition.type = CATransitionType.fade
    self.navigationController?.view.layer.add(transition, forKey: nil)
    self.navigationController?.pushViewController(vc, animated: false)
  }

}
