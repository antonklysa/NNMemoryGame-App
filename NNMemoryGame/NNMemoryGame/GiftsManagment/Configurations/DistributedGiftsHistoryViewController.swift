//
//  DistributedGiftsHistoryViewController.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 4/16/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit

class DistributedGiftsHistoryViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerView.layer.cornerRadius = 5.0
    }
    
    //MARK: Actions
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension DistributedGiftsHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (PMIDataSource.defaultDataSource.activeCampaign() == nil) {
            return 0
        } else {
            return PMIDataSource.defaultDataSource.activeCampaign()!.activeScenario()!.distributedGiftScenarios().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GiftTableViewCell.self)) as? GiftTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        let giftScenario : GiftScenario = PMIDataSource.defaultDataSource.activeCampaign()!.activeScenario()!.distributedGiftScenarios()[indexPath.row]
        cell.giftScenario = giftScenario
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
}
