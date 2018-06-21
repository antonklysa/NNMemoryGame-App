//
//  ConfigurationViewController.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 11/17/17.
//  Copyright © 2017 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import ActionSheetPicker_3_0

class ConfigurationViewController: BaseViewController {

    @IBOutlet weak var lastSyncLabel: UILabel!
    @IBOutlet weak var hostIdlabel: UILabel!
    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var sessionIDLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var loggedInAsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var channelsButtons: [UIButton]!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    //MARK: UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerView.layer.cornerRadius = 6.0
        
        self.setupInfoLabels()
        self.updateUIForActiveCampaign()
    }
    
    
    //MARK: Setup
    
    func setupInfoLabels() {
        let versionString = String(format:"V%@(%@)", (Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String)!, (Bundle.main.infoDictionary?["CFBundleVersion"]  as? String)!)
        self.appVersionLabel.text = versionString
        
        self.appNameLabel.text = "NN Drag Game"
    }
    
    func updateUIForActiveCampaign() {
        let campaign : Campaign? = PMIDataSource.defaultDataSource.activeCampaign()
        if (campaign != nil) {
            self.hostIdlabel.text = PMISessionManager.defaultManager.hostessId
            self.loggedInAsLabel.text = PMISessionManager.defaultManager.name
            self.cityLabel.text = campaign?.city
            self.sessionIDLabel.text = campaign?.sessionid
            self.campaignNameLabel.text = campaign?.name
            
            let lastUpdate : Date? = PMIDataSource.defaultDataSource.lastUpdate
            if (lastUpdate != nil) {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd hh:mm a"
                formatter.amSymbol = "AM"
                formatter.pmSymbol = "PM"
                let lastSyncString = formatter.string(from: lastUpdate!)
                self.lastSyncLabel.text = lastSyncString
            }
        } else {
            self.hostIdlabel.text = ""
            self.loggedInAsLabel.text = ""
            self.cityLabel.text = ""
            self.sessionIDLabel.text = ""
            self.campaignNameLabel.text = ""
            self.lastSyncLabel.text = ""
        }
        
        for channelButton in self.channelsButtons {
            let hostessCampaign: HostessCampaign = HostessCampaign(rawValue: channelButton.tag)!
            if hostessCampaign == PMIDataSource.defaultDataSource.hostessCampaign {
                channelButton.isSelected = true
            } else {
                channelButton.isSelected = false
            }
        }
    }
    
    //MARK: Actions
    
    @IBAction func channelButtonAction(_ sender: UIButton) {
        let hostessCampaign: HostessCampaign = HostessCampaign(rawValue: sender.tag)!
        PMIDataSource.defaultDataSource.hostessCampaign = hostessCampaign
        
        self.updateUIForActiveCampaign()
    }
    
    @IBAction func disconnectButtonAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Êtes vous sûrs de vouloir déconnecter cet utilisateur ?", message: "", preferredStyle: .alert)

        let disconnectAction = UIAlertAction(title: "Déconnecter", style: .default, handler: { alert -> Void in
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            PMISessionManager.defaultManager.disconnect(completion: { (error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if (error == nil) {
                    UIApplication.shared.keyWindow!.rootViewController = UIStoryboard.giftManagmentStoryBoard().instantiateViewController(withIdentifier: "LoginViewController")
                } else {
                    let alertController = UIAlertController(title: "Error.", message: "Something went wrong, please try again.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        })

        let cancelAction = UIAlertAction(title: "Annuler", style: .default, handler: nil)

        alertController.addAction(disconnectAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func syncButtonAction(_ sender: UIButton) {
        MBProgressHUD.showAdded(to: self.view, animated: true)

        PMISessionManager.defaultManager.syncDistributedGifts { (campaignDict, error) in
            if (campaignDict != nil && error == nil) {
                PMIDataSource.defaultDataSource.updateActiveCampaign(campaignDict: campaignDict!, completion: { (error) in
                    MBProgressHUD.hide(for: self.view, animated: false)
                    
                    if (error == nil) {
                        let alertController = UIAlertController(title: "Synchronisation effectuée avec succès.", message: "", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        let alertController = UIAlertController(title: "Error.", message: error?.localizedDescription, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                    self.updateUIForActiveCampaign()
                })
            } else {
                MBProgressHUD.hide(for: self.view, animated: false)

                let alertController = UIAlertController(title: "Error.", message: error!.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func distributedGiftsHistoryButtonAction(_ sender: Any) {
        let vc: DistributedGiftsHistoryViewController = UIStoryboard.giftManagmentStoryBoard().instantiateViewController(withIdentifier: "DistributedGiftsHistoryViewController") as! DistributedGiftsHistoryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
