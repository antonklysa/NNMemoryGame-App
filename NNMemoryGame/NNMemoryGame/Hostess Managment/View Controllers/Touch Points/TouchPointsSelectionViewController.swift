//
//  TouchPointsSelectionViewController.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 9/18/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit

class TouchPointsSelectionViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.reloadData()
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
    
}

extension TouchPointsSelectionViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let activeCampaign = PMIDataSource.defaultDataSource.activeCampaign() {
            let scenarios: [Scenario] = activeCampaign.activeTouchpoint!.sortedScenarios()
            let numberOfLevels = scenarios.count
            if (numberOfLevels == 4) {
                return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            } else if (numberOfLevels == 3) {
                return UIEdgeInsets(top: 0.0, left: 122.0, bottom: 0.0, right: 0.0)
            } else if (numberOfLevels == 2) {
                return UIEdgeInsets(top: 0.0, left: 240.0, bottom: 0.0, right: 0.0)
            } else {
                return UIEdgeInsets(top: 0.0, left: 358.0, bottom: 0.0, right: 0.0)
            }
        } else {
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : TouchPointCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TouchPointCollectionViewCell.self), for: indexPath) as! TouchPointCollectionViewCell
        let scenarios: [Scenario] = PMIDataSource.defaultDataSource.activeCampaign()!.activeTouchpoint!.sortedScenarios()
        cell.scenario = scenarios[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let activeCampaign = PMIDataSource.defaultDataSource.activeCampaign() {
            self.errorLabel.isHidden = true
            
            let scenarios: [Scenario] = activeCampaign.activeTouchpoint!.sortedScenarios()
            let numberOfLevels = scenarios.count
            return numberOfLevels
        } else {
            self.errorLabel.isHidden = false

            return 0
        }
    }
    
}

extension TouchPointsSelectionViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let scenarios: [Scenario] = PMIDataSource.defaultDataSource.activeCampaign()!.activeTouchpoint!.sortedScenarios()
        let selectedScenario = scenarios[indexPath.item]
        PMIDataSource.defaultDataSource.activeCampaign()?.activeTouchpoint?.activeScenario = selectedScenario
        
        if let activeScenario: Scenario = PMIDataSource.defaultDataSource.activeCampaign()?.activeTouchpoint?.activeScenario {
            print("Scenario with name \(activeScenario.scenarioName!) selected.")
            
            if (activeScenario.notDistributedGiftScenarios().count == 0) {
                let alertController = UIAlertController(title: "Plus de cadeaux à distribuer pour le niveau séléctionné, veuillez contacter votre superviseur.", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                let vc : MemoryGameViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemoryGameViewController") as! MemoryGameViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
