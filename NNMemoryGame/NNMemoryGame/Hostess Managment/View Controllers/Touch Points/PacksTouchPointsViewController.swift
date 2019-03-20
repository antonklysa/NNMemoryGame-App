//
//  PacksTouchPointsViewController.swift
//  NNMemoryGame
//
//  Created by Yaroslav Brekhunchenko on 3/19/19.
//  Copyright © 2019 Anton Klysa. All rights reserved.
//

import UIKit

class PacksTouchPointsViewController: BaseViewController {
  
    var scenarios: [Scenario] = []
  
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: UIViewController Life Cycle
    
    override func viewDidLoad() {
      super.viewDidLoad()      
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      self.collectionView.reloadData()
    }
  
    //MARK: Actions
  
    @IBAction func backButtonAction(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }
  
}
  
extension PacksTouchPointsViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    let scenarios: [Scenario] = self.scenarios
    let numberOfLevels = scenarios.count
    if (numberOfLevels == 5) {
      return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    } else if (numberOfLevels == 4) {
      return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    } else if (numberOfLevels == 3) {
      return UIEdgeInsets(top: 0.0, left: 122.0, bottom: 0.0, right: 0.0)
    } else if (numberOfLevels == 2) {
      return UIEdgeInsets(top: 0.0, left: 240.0, bottom: 0.0, right: 0.0)
    } else  if (numberOfLevels == 1) {
      return UIEdgeInsets(top: 0.0, left: 358.0, bottom: 0.0, right: 0.0)
    } else {
      return UIEdgeInsets.zero
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let scenarios: [Scenario] = self.scenarios
    let numberOfLevels = scenarios.count
    if (numberOfLevels == 5) {
      return CGSize(width: 180.0, height: 226.0)
    } else {
      return CGSize(width: 227.0, height: 346.0)
    }
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell : TouchPointCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TouchPointCollectionViewCell.self), for: indexPath) as! TouchPointCollectionViewCell
    let scenarios: [Scenario] = self.scenarios
    cell.scenario = scenarios[indexPath.item]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    self.errorLabel.isHidden = true
    
    let scenarios: [Scenario] = self.scenarios
    let numberOfLevels = scenarios.count
    return numberOfLevels
  }
  
}

extension PacksTouchPointsViewController : UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let scenarios: [Scenario] = self.scenarios
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
        let vc : ChooseLanguageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChooseLanguageViewController") as! ChooseLanguageViewController
        self.navigationController?.pushViewController(vc, animated: true)
      }
    }
  }
  
}
