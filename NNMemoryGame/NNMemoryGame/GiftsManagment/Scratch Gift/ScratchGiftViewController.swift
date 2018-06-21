//
//  ScratchGiftViewController.swift
//  NNGames
//
//  Created by Yaroslav Brekhunchenko on 6/21/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit
import PINCache

class ScratchGiftViewController: BaseViewController {
    
    @IBOutlet weak var scratchContainerView: UIView!
    @IBOutlet weak var doneButton: UIButton!

    var scratchCard: ScratchUIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doneButton.isUserInteractionEnabled = false
        self.doneButton.alpha = 0.5
        
        self.setupScratchView()
    }

    //MARK: Setup
    
    private func setupScratchView() {
        let giftScenarion : GiftScenario! = PMIDataSource.defaultDataSource.activeCampaign()?.activeScenario()!.getNextGiftScenario()!
        let imageName : String = (giftScenarion.gift?.image)!
//        let imageGift: UIImage = PINCache.shared.diskCache.object(forKey: imageName.pinCacheStringKey()) as! UIImage!
        self.scratchCard = ScratchUIView(frame: scratchContainerView.bounds, Coupon: imageName, MaskImage: "scratch_overlay_\(PMIDataSource.defaultDataSource.language.prefixFromLanguage())", ScratchWidth: CGFloat(70))
//        self.scratchCard.maskImage.image = imageGift
        self.scratchCard.delegate = self
        self.scratchContainerView.addSubview(self.scratchCard)
    }
    
    //MARK: Actions
    
    @IBAction func doneButtonAction(_ sender: Any) {
        let giftScenarion : GiftScenario! = PMIDataSource.defaultDataSource.activeCampaign()!.activeScenario()!.getNextGiftScenario()!
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

extension ScratchGiftViewController : ScratchUIViewDelegate {
    
    func scratchMoved(_ view: ScratchUIView) {
        if view.getScratchPercent() > 0.3 {
            self.doneButton.isUserInteractionEnabled = true
            self.doneButton.alpha = 1.0
        }
    }
    
}
