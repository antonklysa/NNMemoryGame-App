//
//  PMISessionManager.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 11/17/17.
//  Copyright © 2017 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

class PMISessionManager: SessionManager {
    
    let baseURL: String = "http://pmanager.ozeapps.com/"
//    let baseURL: String = "http://139.162.233.112/"

    var hostessId : String? {
        get {
            let value: String? =  UserDefaults.standard.object(forKey: "hostessId") as? String
            return value
        }
        
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "hostessId")
            defaults.synchronize()
        }
    }
    
    var city : String? {
        get {
            let value: String? =  UserDefaults.standard.object(forKey: "city") as? String
            return value
        }
        
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "city")
            defaults.synchronize()
        }
    }
    
    var selectedChannelId : Int64? {
        get {
            let value: Int64? =  UserDefaults.standard.object(forKey: "selectedChannelId") as? Int64
            return value
        }
        
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "selectedChannelId")
            defaults.synchronize()
        }
    }
    
    var name : String? {
        get {
            let value: String? =  UserDefaults.standard.object(forKey: "name") as? String
            return value
        }
        
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "name")
            defaults.synchronize()
        }
    }
    
    var password: String? {
        get {
            let value: String? =  UserDefaults.standard.object(forKey: "password") as? String
            return value
        }
        
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "password")
            defaults.synchronize()
        }
    }
    
    static let defaultManager : PMISessionManager = {
        let configuration = URLSessionConfiguration.default
        
        let instance = PMISessionManager(configuration : configuration)
        
        return instance
    }()
    
    
    static func teamName() -> String {
        return "drag"
    }
    
    func login(login : String, password: String, completion:@escaping(NSError?) -> ()) {
        var parameters : [String:Any] = [:]
        parameters["application_type"] = PMISessionManager.teamName()
        parameters["ipad_name"] = login
        parameters["did"] = UIDevice.current.identifierForVendor!.uuidString
        parameters["hostess_id"] = login
        parameters["hostess_pass"] = password
        
        Alamofire.request(self.baseURL + "api/Sync/login/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                let data = (response.result.value as! [String:Any])
                if response.response?.statusCode == 200 {
                    PMISessionManager.defaultManager.hostessId = login
                    PMISessionManager.defaultManager.password = password
                    PMISessionManager.defaultManager.name = data["name"] as? String
                    PMISessionManager.defaultManager.city = data["city"] as? String
                    
                    completion(nil)
                } else {
                    let errorString = data["error"] as! NSString
                    completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:errorString]))
                }
                break
                
            case .failure(_):
                completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Something went wrong."]))
                break
                
            }
        }
        
    }
    
    func disconnect(completion:@escaping(NSError?) -> ()) {
        var parameters : [String:Any] = [:]
        parameters["application_type"] = PMISessionManager.teamName()
        parameters["hostess_id"] = PMISessionManager.defaultManager.hostessId
        parameters["did"] = UIDevice.current.identifierForVendor!.uuidString
        
        Alamofire.request(self.baseURL + "api/Sync/disconnect/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                let data = (response.result.value as! [String:Any])
                if response.response?.statusCode == 200 {
                    PMISessionManager.defaultManager.hostessId = nil
                    PMISessionManager.defaultManager.password = nil
                    PMISessionManager.defaultManager.name = nil
                    PMISessionManager.defaultManager.city = nil
                    
                    let error : NSError? = PMIDataSource.defaultDataSource.deleteActiveCampaign()
                    if (error == nil) {
                        completion(nil)
                    } else {
                        completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Something went wrong."]))
                    }
                } else {
                    let errorString = data["error"] as! NSString
                    completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:errorString]))
                }
                break
                
            case .failure(_):
                completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Something went wrong."]))
                break
                
            }
        }
    }
    
    func syncDistributedGifts(completion:@escaping(JSON?, NSError?) -> ()) {
        var parameters : [String:Any] = [:]
        parameters["application_type"] = PMISessionManager.teamName()
        parameters["did"] = UIDevice.current.identifierForVendor!.uuidString
        parameters["hostess_id"] = PMISessionManager.defaultManager.hostessId
        
        if let activeCampaign = PMIDataSource.defaultDataSource.activeCampaign() {
            parameters["session_id"] = activeCampaign.sessionid
            parameters["city"] = activeCampaign.city
            parameters["hostess_id"] = activeCampaign.hostessId
            var reportList : [[String:Any]] = []
            for channel in activeCampaign.sortedScenarios() {
                var channelDict : [String:Any] = [:]
                channelDict["channel_id"] = channel.channelId
                var distributedGifts: [[String:Any]] = []
                for distributedGiftScenario in channel.distributedGiftScenarios() {
                    var distributedGift : [String:Any] = [:]
                    distributedGift["gift_id"] = String(distributedGiftScenario.gift!.giftID)
                    distributedGift["distributed"] = String(distributedGiftScenario.distributed)
                    distributedGift["queue_position"] = String(distributedGiftScenario.queuePosition)
                    distributedGift["time"] = String(Double(distributedGiftScenario.distributionTime!.timeIntervalSince1970))
                    distributedGifts.append(distributedGift)
                }
                channelDict["data"] = distributedGifts
                reportList.append(channelDict)
            }
            parameters["report"] = reportList
        }
        
        let paramaterJSON: JSON = JSON(parameters)
        print(paramaterJSON)
        
         Alamofire.request(self.baseURL + "api/Sync/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseSwiftyJSON { response in
            if let data = response.value {
                if response.response?.statusCode == 200 {
                    completion(data, nil)
                } else {
                    let errorString = data["error"].stringValue
                    completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:errorString]))
                }
            } else {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Invalid data format."]))
            }
        }.responseString { (response) in
            print("Response String: \(response.result.value)")
            print("Success: \(response.result.isSuccess)")
        }
        
    }
    
}
