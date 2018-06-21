//
//  UIAlertViewController+Extensions.swift
//  NNGames
//
//  Created by Yaroslav Brekhunchenko on 6/21/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit

extension UIViewController {
 
    func showErrorAlertWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error.", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
