//
//  AppSettings.swift
//  Scratch
//
//  Created by Yaroslav Brekhunchenko on 2/18/19.
//  Copyright © 2019 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit

enum Language : Int {
    case French
    case Arabic
    
    func prefixLanguage() -> String {
        switch self {
        case .French: return "fr"
        case .Arabic: return "ar"
        }
    }
    
    func isArabic() -> Bool {
        if self == .Arabic {
            return true
        } else {
            return false
        }
    }
    
}


class AppSettings: NSObject {

    static let defaultSettings : AppSettings = {
        let instance = AppSettings()
        return instance
    }()
    
    var language : Language! {
        get {
            let value: Int? =  UserDefaults.standard.object(forKey: "language") as? Int
            if (value == nil) {
                return Language.French
            }
            return Language(rawValue: value!)
        }
        
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue?.rawValue, forKey: "language")
            defaults.synchronize()
        }
    }
    
}
