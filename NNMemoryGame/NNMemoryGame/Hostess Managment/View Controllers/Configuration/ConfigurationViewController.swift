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
    @IBOutlet weak var currentChannelLabel: UILabel!
    @IBOutlet weak var channelsTableView: UITableView!

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
        let versionString = String(format:"V%@", (Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String)!)
        self.appVersionLabel.text = versionString

        #if LAMP
            self.appNameLabel.text = "Hostess Premium LAMP"
        #else
            self.appNameLabel.text = "Hostess Premium POS"
        #endif
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

            if let channelName: String = PMIDataSource.defaultDataSource.activeCampaign()?.activeTouchpoint?.tochpointName {
                self.currentChannelLabel.text = channelName
            }
        } else {
            self.hostIdlabel.text = ""
            self.loggedInAsLabel.text = ""
            self.cityLabel.text = ""
            self.sessionIDLabel.text = ""
            self.campaignNameLabel.text = ""
            self.lastSyncLabel.text = ""
            self.currentChannelLabel.text = ""
        }
        
        self.channelsTableView.isHidden = true
        self.channelsTableView.reloadData()
        
        if (PMISessionManager.teamName() == "LAMP") {
            self.loggedInAsLabel.isHidden = false
            self.nameLabel.isHidden = false
        }
    }
    
    //MARK: Actions
    
    @IBAction func disconnectButtonAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Êtes vous sûrs de vouloir déconnecter cet utilisateur ?", message: "", preferredStyle: .alert)

        let disconnectAction = UIAlertAction(title: "Déconnecter", style: .default, handler: { alert -> Void in
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            PMISessionManager.defaultManager.disconnect(completion: { (error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if (error == nil) {
                    self.view.window!.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
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
        
//        let file = Bundle.main.url(forResource: "campaigns", withExtension: "json")
//        let data = try! Data(contentsOf: file!)
//        let json = try! JSON(data: data)
//        PMIDataSource.defaultDataSource.updateActiveCampaign(campaignDict: json) { (error) in
//            MBProgressHUD.hide(for: self.view, animated: false)
//
//            if (error == nil) {
//                let alertController = UIAlertController(title: "Synchronisation effectuée avec succès.", message: "", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: nil)
//            } else {
//                let alertController = UIAlertController(title: "Error.", message: error?.localizedDescription, preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: nil)
//            }
//
//            self.updateUIForActiveCampaign()
//        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func distributedGiftsHistoryButtonAction(_ sender: Any) {
        let vc: DistributedGiftsHistoryViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DistributedGiftsHistoryViewController") as! DistributedGiftsHistoryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func selectChannelButtonAction(_ sender: UIButton) {
        self.channelsTableView.isHidden = !self.channelsTableView.isHidden
    }
    
}

extension ConfigurationViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let activeCampaign: Campaign = PMIDataSource.defaultDataSource.activeCampaign() {
            return activeCampaign.sortedTouchpoints().count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChannelTableViewCell.self)) as? ChannelTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        let activeCampaign: Campaign = PMIDataSource.defaultDataSource.activeCampaign()!
        let touchpoint: Touchpoint = activeCampaign.sortedTouchpoints()[indexPath.row]
        cell.touchpoint = touchpoint
        if PMIDataSource.defaultDataSource.activeCampaign()!.activeTouchpoint != nil {
            let isActiveScenario: Bool = (PMIDataSource.defaultDataSource.activeCampaign()!.activeTouchpoint!.tochpointName == touchpoint.tochpointName!)
            if (isActiveScenario) {
                cell.backgroundColor = UIColor(red: 215.0/255.0, green: 24.0/255.0, blue: 42.0/255.0, alpha: 1.0)
                cell.channelNameLabel.textColor = UIColor.white
            } else {
                cell.backgroundColor = UIColor.white
                cell.channelNameLabel.textColor = UIColor.black
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let activeCampaign: Campaign = PMIDataSource.defaultDataSource.activeCampaign() {
            let listOfTouchpoints: [Touchpoint] = activeCampaign.sortedTouchpoints()
            let touchpoint: Touchpoint = listOfTouchpoints[indexPath.row]
            
            PMIDataSource.defaultDataSource.activeCampaign()!.activeTouchpoint = touchpoint
            PMISessionManager.defaultManager.selectedTouchpointId = touchpoint.touchpointId
            
            self.updateUIForActiveCampaign()
        }
        
    }
}
