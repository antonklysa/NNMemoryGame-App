//
//  UserConfirmationViewController.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 4/16/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit
import MBProgressHUD

class UserConfirmationViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var hostessIdLabel: UILabel!
    
    //MARK: UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLabels()
    }
    
    //MARK: Setup
    
    private func setupLabels() {
        if (PMISessionManager.teamName() == "LAMP") {
            self.nameLabel.isHidden = true
        }
        self.nameLabel.text = PMISessionManager.defaultManager.name
        self.cityLabel.text = PMISessionManager.defaultManager.city
        self.teamLabel.text = PMISessionManager.teamName()
        self.hostessIdLabel.text = PMISessionManager.defaultManager.hostessId
    }
    
    //MARK: Actions

    @IBAction func cancelButtonAction(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        PMISessionManager.defaultManager.disconnect(completion: { (error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if (error == nil) {
                self.navigationController?.popViewController(animated: true)
            } else {
                let alertController = UIAlertController(title: "Error.", message: "Something went wrong, please try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func confirmButttonAction(_ sender: Any) {
        UIApplication.shared.keyWindow!.rootViewController = UINavigationController(rootViewController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PackChoiceViewController"))
    }
    
}
