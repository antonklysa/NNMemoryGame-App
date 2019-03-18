//
//  PMIDataSource.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 11/17/17.
//  Copyright © 2017 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class PMIDataSource: NSObject {
    
    public var managedObjectContext: NSManagedObjectContext
    
    private var campaignUpdateCompleitonBlock: ((NSError?) -> ())?
    private var imagesDownloadingOperationQueue : OperationQueue?
    
    static let defaultDataSource = PMIDataSource()
    
    var lastUpdate : Date? {
        get {
            let value: Date? =  UserDefaults.standard.object(forKey: "lastUpdate") as? Date
            return value
        }
        
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "lastUpdate")
            defaults.synchronize()
        }
    }
    
    override init() {
        guard let modelURL = Bundle.main.url(forResource: "PMI", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        
        guard let mom = NSManagedObjectModel.init(contentsOf: modelURL) else {
            fatalError("Error initializing mom")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex - 1]
        
        let storeURL = docURL.appendingPathComponent("PMI.sqlite")
        
        let opt: Dictionary<String, Bool> = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: opt)
        } catch {
            fatalError("Error migrating store")
        }
        
        self.campaignUpdateCompleitonBlock = nil
    }
    
    func updateActiveCampaign(campaignDict: JSON, completion: @escaping (NSError?) -> ())  {
        self.campaignUpdateCompleitonBlock = completion
        
        //First of all delete currently active campaign to make sure data in the app is always latest.
        let error : NSError? = self.deleteActiveCampaign()
        if (error == nil) {
            //Parse scenario.
            let campaign : Campaign? = Campaign.campaignFromJSONDicitonary(campaignDict: campaignDict)
            if (campaign == nil) {
                self.managedObjectContext.rollback()
                self.campaignUpdateCompleitonBlock!(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Something went wrong. Invalid capmaign."]))
            } else {
                //Download images for each gift and save locally.
                self.downloadImages(forCampaign: campaign!, completion: { (error) in
                    if (error == nil) {
                        do {
                            try self.managedObjectContext.save()
                            PMIDataSource.defaultDataSource.lastUpdate = Date()
                            self.campaignUpdateCompleitonBlock!(nil)
                        } catch {
                            self.managedObjectContext.rollback()
                            self.campaignUpdateCompleitonBlock!(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Something went wrong. Unable to save changes."]))
                        }
                    } else {
                        self.managedObjectContext.rollback()
                        self.campaignUpdateCompleitonBlock!(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Something went wrong. Unable to download all gifts images."]))
                    }
                })
            }
        } else {
            self.campaignUpdateCompleitonBlock!(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Something went wrong. Unable to delete previous campaign."]))
        }
    }
    
    private func downloadImages(forCampaign campaign : Campaign, completion: @escaping (NSError?) -> ()) {
        self.imagesDownloadingOperationQueue = OperationQueue()
        self.imagesDownloadingOperationQueue?.maxConcurrentOperationCount = 1
        
        var operations : [Operation] = []
        
        for touchpoint in campaign.sortedTouchpoints() {
            for scenario in touchpoint.sortedScenarios() {
                for gift in scenario.gifts as! Set<Gift> {
                    let downloadImageOperation : DownloadImageOperation = DownloadImageOperation(imageURL: gift.image!)
                    downloadImageOperation.delegate = self
                    let previousOperation : DownloadImageOperation? = operations.last as! DownloadImageOperation?
                    if (previousOperation != nil) {
                        downloadImageOperation.addDependency(previousOperation!)
                    }
                    operations.append(downloadImageOperation)
                }
            }
        }
        
        for touchpoint in campaign.sortedTouchpoints() {
            let downloadImageOperation : DownloadImageOperation = DownloadImageOperation(imageURL: touchpoint.touchpointImage!)
            downloadImageOperation.delegate = self
            let previousOperation : DownloadImageOperation? = operations.last as! DownloadImageOperation?
            if (previousOperation != nil) {
                downloadImageOperation.addDependency(previousOperation!)
            }
            operations.append(downloadImageOperation)
        }
        
        for touchpoint in campaign.sortedTouchpoints() {
            for scenario in touchpoint.sortedScenarios() {
                let downloadImageOperation : DownloadImageOperation = DownloadImageOperation(imageURL: scenario.scenarioImage!)
                downloadImageOperation.delegate = self
                let previousOperation : DownloadImageOperation? = operations.last as! DownloadImageOperation?
                if (previousOperation != nil) {
                    downloadImageOperation.addDependency(previousOperation!)
                }
                operations.append(downloadImageOperation)
            }
        }
        
        // Download theme images.
        let themeImagesURL: [String] = [campaign.theme!.backgroundImageURL!, campaign.theme!.homeImageURL!, campaign.theme!.startButtonImageURL!, campaign.theme!.endButtonImageURL!]
        for imageURL in themeImagesURL {
            let downloadImageOperation : DownloadImageOperation = DownloadImageOperation(imageURL: imageURL)
            downloadImageOperation.delegate = self
            let previousOperation : DownloadImageOperation? = operations.last as! DownloadImageOperation?
            if (previousOperation != nil) {
                downloadImageOperation.addDependency(previousOperation!)
            }
            operations.append(downloadImageOperation)
        }
        
        if (operations.count > 0) {
            let finishedCallbackOperation : BlockOperation = BlockOperation.init(block: {
                DispatchQueue.main.async {
                    completion(nil)
                }
            })
            finishedCallbackOperation.addDependency(operations.last!)
            operations.append(finishedCallbackOperation)
            
            self.imagesDownloadingOperationQueue?.addOperations(operations, waitUntilFinished: false)
        } else {
            completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Something went wrong."]))
        }
    }
    
    func activeCampaign() -> Campaign? {
        let fetchRequest : NSFetchRequest = Campaign.fetchRequest()
        do {
            let listOfCampaigns = try self.managedObjectContext.fetch(fetchRequest)
            assert(listOfCampaigns.count <= 1)
            return listOfCampaigns.last
        } catch {
            return nil
        }
    }
    
    func deleteActiveCampaign() -> NSError? {
        let currentActiveCampaign : Campaign? = self.activeCampaign()
        if (currentActiveCampaign != nil) {
            self.managedObjectContext.delete(currentActiveCampaign!)
        }
        
        do {
            try self.managedObjectContext.save()
            assert(self.activeCampaign() == nil, "Something went wrong. Active campaign != nill after deletion.")
            let touchpointsFetchRequest : NSFetchRequest<Touchpoint> = NSFetchRequest(entityName: "Touchpoint")
            assert(try! self.managedObjectContext.fetch(touchpointsFetchRequest).count == 0, "Something went wrong. There are someTouchpoint after campaign deletion.")
            let scenariosFetchRequest : NSFetchRequest<Scenario> = NSFetchRequest(entityName: "Scenario")
            assert(try! self.managedObjectContext.fetch(scenariosFetchRequest).count == 0, "Something went wrong. There are some Scenarios after campaign deletion.")
            let giftFetchRequest : NSFetchRequest<Gift> = NSFetchRequest(entityName: "Gift")
            assert(try! self.managedObjectContext.fetch(giftFetchRequest).count == 0, "Something went wrong. There are gifts after scenario deletion.")
            let giftScenarioFetchRequest : NSFetchRequest<GiftScenario> = NSFetchRequest(entityName: "GiftScenario")
            assert(try! self.managedObjectContext.fetch(giftScenarioFetchRequest).count == 0, "Something went wrong. There are gift scenarios after scenario deletion.")
            return nil
        } catch {
            return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Something went wrong. Unable to delete scenario."])
        }
    }
    
    func giftWithID(_ giftID: Int64, scenarioID: Int64) -> Gift? {
        let fetchRequest : NSFetchRequest = Gift.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "giftID == %d", giftID)
        do {
            let listOfGifts = try self.managedObjectContext.fetch(fetchRequest)
            for gift in listOfGifts {
                if let  giftScenarioID = gift.scenario?.scenarioId {
                    if (giftScenarioID == scenarioID) {
                        return gift
                    }
                }
            }
            return nil
        } catch {
            return nil
        }
    }
    
}

extension PMIDataSource : DownloadImageOperationDelegate {
    
    func downloadImageOperation(_ operation: DownloadImageOperation, didDownloadImage imageURL: String) {
        print("\(#function)")
    }
    
    func downloadImageOperation(_ operation: DownloadImageOperation, didFailDownloadingImage imageURL: String) {
        self.imagesDownloadingOperationQueue?.cancelAllOperations()
        self.campaignUpdateCompleitonBlock!(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Something went wrong."]))
    }
    
}
