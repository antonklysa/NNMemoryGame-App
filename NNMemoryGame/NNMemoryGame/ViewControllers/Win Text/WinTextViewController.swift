//
//  WinTextViewController.swift
//  NNGames
//
//  Created by Yaroslav Brekhunchenko on 6/15/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit

class WinTextViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            let vc: ScratchGiftViewController = UIStoryboard.giftManagmentStoryBoard().instantiateViewController(withIdentifier: String(format:"ScratchGiftViewController_%@", PMIDataSource.defaultDataSource.language.prefixFromLanguage())) as! ScratchGiftViewController
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(vc, animated: false)        }
    }

}
