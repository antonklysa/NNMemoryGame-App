//
//  WinViewController.swift
//  Scratch
//
//  Created by Yaroslav Brekhunchenko on 2/18/19.
//  Copyright © 2019 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit
import PINCache

class WinViewController: BaseViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var giftImageVIew: UIImageView!
    
    //MARK: UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleImageView.image = UIImage(named: "gift_title_\(AppSettings.defaultSettings.language.prefixLanguage())")
        doneButton.setImage(UIImage(named: "gift_win_\(AppSettings.defaultSettings.language.prefixLanguage())"), for: .normal)
        
        let giftScenarion : GiftScenario! = PMIDataSource.defaultDataSource.activeCampaign()?.activeTouchpoint!.activeScenario!.getNextGiftScenario()!
        do {
            let imageName : String = (giftScenarion.gift?.image)!
            self.giftImageVIew.image = PINCache.shared.diskCache.object(forKey: imageName.pinCacheStringKey()) as! UIImage!
        } catch {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    //MARK: Actions
    
    @IBAction func doneButtonAction(_ sender: Any) {
        let giftScenarion : GiftScenario! = PMIDataSource.defaultDataSource.activeCampaign()?.activeTouchpoint!.activeScenario!.getNextGiftScenario()!
        giftScenarion.distributed = true
        giftScenarion.distributionTime = NSDate()
        do {
            try PMIDataSource.defaultDataSource.managedObjectContext.save()
            self.navigationController?.popToRootViewController(animated: true)
        } catch {
            let alertController = UIAlertController(title: "Error.", message: "Something went wrong, please try again.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
