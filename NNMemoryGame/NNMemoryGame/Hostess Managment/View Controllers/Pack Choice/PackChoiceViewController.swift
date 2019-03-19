//
//  PackChoiceViewController.swift
//  NNMemoryGame
//
//  Created by Yaroslav Brekhunchenko on 3/19/19.
//  Copyright © 2019 Anton Klysa. All rights reserved.
//

import UIKit

class PackChoiceViewController: BaseViewController {

  @IBOutlet weak var packChoice0Button: UIButton!
  @IBOutlet weak var packChoice1Button: UIButton!
  @IBOutlet weak var errorLabel: UILabel!

  //MARK: UIViewController Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupGestures()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let activeCampaign = PMIDataSource.defaultDataSource.activeCampaign() {
      self.packChoice0Button.isHidden = false
      self.packChoice1Button.isHidden = false
      self.errorLabel.isHidden = true
    } else {
      self.packChoice0Button.isHidden = true
      self.packChoice1Button.isHidden = true
      self.errorLabel.isHidden = false
    }
  }
  
  func setupGestures() {
    let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureRecognizerCatched))
    tapGesture.numberOfTapsRequired = 3
    self.view.addGestureRecognizer(tapGesture)
  }
  
  //MARK: Gestures
  
  @objc func tapGestureRecognizerCatched(gestureRecognizer: UITapGestureRecognizer) {
    let location : CGPoint = gestureRecognizer.location(in: self.view)
    if (location.x > self.view.bounds.size.width*0.7 && location.y < self.view.bounds.size.height*0.3) {
      self.showConfigScreen()
    }
  }
  
  func showConfigScreen() {
    let alertController = UIAlertController(title: "Please enter password", message: "", preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Enter", style: .default, handler: {
      alert -> Void in
      
      let firstTextField = alertController.textFields![0] as UITextField
      firstTextField.isSecureTextEntry = true
      if (firstTextField.text == "9379992" || firstTextField.text == PMISessionManager.defaultManager.password) {
        DispatchQueue.main.async {
          let vc : ConfigurationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfigurationViewController") as! ConfigurationViewController
          self.navigationController?.pushViewController(vc, animated: true)
        }
      } else {
        let alertController = UIAlertController(title: "Error.", message: "Mot de passe incorrect", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
      }
    })
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
      (action : UIAlertAction!) -> Void in
      
    })
    
    alertController.addTextField { (textField : UITextField!) -> Void in
      textField.placeholder = "Password"
      textField.keyboardType = UIKeyboardType.numberPad
      textField.isSecureTextEntry = true
    }
    
    alertController.addAction(saveAction)
    alertController.addAction(cancelAction)
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  @IBAction func packChoice0ButtonAction(_ sender: Any) {
    PMISessionManager.defaultManager.packChoice = PackChoice.choice0
    
    if let scenarios: [Scenario] = PMIDataSource.defaultDataSource.activeCampaign()?.activeTouchpoint?.sortedScenariosForPackChoice(PMISessionManager.defaultManager.packChoice) {
      self.showScenarios(scenarios)
    }
  }

  @IBAction func packChoice1ButtonAction(_ sender: Any) {
    PMISessionManager.defaultManager.packChoice = PackChoice.choice1
    
    if let scenarios: [Scenario] = PMIDataSource.defaultDataSource.activeCampaign()?.activeTouchpoint?.sortedScenariosForPackChoice(PMISessionManager.defaultManager.packChoice) {
      self.showScenarios(scenarios)
    }
  }
  
  func showScenarios(_ scenarios: [Scenario]) {
    let vc: PacksTouchPointsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PacksTouchPointsViewController") as! PacksTouchPointsViewController
    vc.scenarios = scenarios
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
}
