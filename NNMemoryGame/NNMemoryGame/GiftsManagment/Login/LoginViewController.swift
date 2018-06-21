//
//  LoginViewController.swift
//  Authentic122
//
//  Created by Yaroslav Brekhunchenko on 5/4/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Actions
    
    @IBAction func loginButtonAction(_ sender: Any) {
        // TESTING
        if TARGET_OS_SIMULATOR != 0 && self.usernameTextField.text!.count == 0 {
            UIApplication.shared.keyWindow!.rootViewController = UINavigationController.init(rootViewController:UIStoryboard.giftManagmentStoryBoard().instantiateViewController(withIdentifier: "SelectDifficultyViewController"))
            return
        }
        
        let login : String = self.usernameTextField.text!
        let password: String = self.passwordTextField.text!
        if (login.count > 0 && password.count > 0) {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            PMISessionManager.defaultManager.login(login: login, password: password, completion: { (error) in
                if (error == nil) {
                    PMISessionManager.defaultManager.syncDistributedGifts(completion: { (campaignDict, error) in
                        if (error == nil) {
                            PMIDataSource.defaultDataSource.updateActiveCampaign(campaignDict: campaignDict!, completion: { (error) in
                                MBProgressHUD.hide(for: self.view, animated: false)
                                if (error == nil) {
                                    UIApplication.shared.keyWindow!.rootViewController = UINavigationController.init(rootViewController:UIStoryboard.giftManagmentStoryBoard().instantiateViewController(withIdentifier: "SelectDifficultyViewController"))
                                } else {
                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    
                                    self.showErrorAlertWithMessage(error!.localizedDescription)
                                }
                            })
                        } else {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            self.showErrorAlertWithMessage(error!.localizedDescription)
                        }
                    })
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)

                    self.showErrorAlertWithMessage(error!.localizedDescription)
                }
            })
        } else {
            self.usernameTextField.becomeFirstResponder()
        }
    }
    
}

