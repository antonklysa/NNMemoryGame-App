//
//  ChooseLanguageViewController.swift
//  NNMemoryGame
//
//  Created by Yaroslav Brekhunchenko on 6/20/18.
//  Copyright © 2018 Anton Klysa. All rights reserved.
//

import UIKit

class ChooseLanguageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func arabicButtonAction(_ sender: Any) {
        LocalizationManagers.shared.selectedLanguage = .ar
        AppSettings.defaultSettings.language = Language.Arabic

        self.pushGameViewController()
    }
    
    @IBAction func frenchButtonAction(_ sender: Any) {
        LocalizationManagers.shared.selectedLanguage = .fr
        AppSettings.defaultSettings.language = Language.French

        self.pushGameViewController()
    }
    
    func pushGameViewController() {
        let vc: MemoryGameViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemoryGameViewController") as! MemoryGameViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
