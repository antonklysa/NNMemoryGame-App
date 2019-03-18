//
//  LoginViewController.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 11/16/17.
//  Copyright © 2017 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: BaseViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButtonAction(_ sender: Any) {
        let login : String = self.usernameTextField.text!
        let password: String = self.passwordTextField.text!
        if (login.count > 0 && password.count > 0) {
            MBProgressHUD.showAdded(to: self.view, animated: true)

            PMISessionManager.defaultManager.login(login: login, password: password, completion: { (error) in
                MBProgressHUD.hide(for: self.view, animated: true)

                if (error == nil) {
                    let vc: UserConfirmationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserConfirmationViewController") as! UserConfirmationViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let alertController = UIAlertController(title: "Error.", message: error?.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        } else {
            self.usernameTextField.becomeFirstResponder()
        }
    }
    
}
