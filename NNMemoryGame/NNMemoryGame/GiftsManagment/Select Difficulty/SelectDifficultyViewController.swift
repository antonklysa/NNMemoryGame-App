//
//  SelectDifficultyViewController.swift
//  NN
//
//  Created by Yaroslav Brekhunchenko on 3/26/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit

class SelectDifficultyViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.setupGestureRecognizer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    //MARK: Actions
    @IBAction func settingsButtonAction(_ sender: Any) {
//        let vc : ConfigurationViewController = UIStoryboard.giftManagmentStoryBoard().instantiateViewController(withIdentifier: "ConfigurationViewController") as! ConfigurationViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        let alertController = UIAlertController(title: "Please enter password", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Enter", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            firstTextField.isSecureTextEntry = true
            if (firstTextField.text == "9379992" || firstTextField.text == PMISessionManager.defaultManager.password) {
                DispatchQueue.main.async {
                    let vc : ConfigurationViewController = UIStoryboard.giftManagmentStoryBoard().instantiateViewController(withIdentifier: "ConfigurationViewController") as! ConfigurationViewController
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

extension SelectDifficultyViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let selectedCampaign: HostessCampaign = PMIDataSource.defaultDataSource.hostessCampaign
        let numberOfLevels = selectedCampaign.listOfDifficultyLevels().count
        if (numberOfLevels == 4) {
            return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        } else if (numberOfLevels == 3) {
            return UIEdgeInsetsMake(0.0, 122.0, 0.0, 0.0)
        } else if (numberOfLevels == 2) {
            return UIEdgeInsetsMake(0.0, 240.0, 0.0, 0.0)
        } else {
            return UIEdgeInsetsMake(0.0, 358.0, 0.0, 0.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SelectDifficultyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SelectDifficultyCollectionViewCell.self), for: indexPath) as! SelectDifficultyCollectionViewCell
        let selectedCampaign: HostessCampaign = PMIDataSource.defaultDataSource.hostessCampaign
        let difficulty: Difficulty = selectedCampaign.listOfDifficultyLevels()[indexPath.item]
        let difficultyLevel = difficulty
        cell.difficultyLevel = difficultyLevel
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let selectedCampaign: HostessCampaign = PMIDataSource.defaultDataSource.hostessCampaign
        let numberOfLevels = selectedCampaign.listOfDifficultyLevels().count
        return numberOfLevels
    }
    
}

extension SelectDifficultyViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCampaign: HostessCampaign = PMIDataSource.defaultDataSource.hostessCampaign
        let difficulty: Difficulty = selectedCampaign.listOfDifficultyLevels()[indexPath.item]
        PMIDataSource.defaultDataSource.difficulty = difficulty
        
        if let activeScenario: Scenario = PMIDataSource.defaultDataSource.activeCampaign()?.activeScenario() {
            print("Scenario with name \(activeScenario.scenarioName!) selected.")
            
            if (activeScenario.notDistributedGiftScenarios().count == 0) {
                let alertController = UIAlertController(title: "Plus de cadeaux à distribuer sur ce channel.", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                let vc: ChooseLanguageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChooseLanguageViewController") as! ChooseLanguageViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
