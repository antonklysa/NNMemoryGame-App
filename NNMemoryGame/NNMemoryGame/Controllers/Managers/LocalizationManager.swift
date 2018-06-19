//
//  LocalizationManager.swift
//  NNMemoryGame
//
//  Created by Anton Klysa on 6/18/18.
//  Copyright © 2018 Anton Klysa. All rights reserved.
//

import Foundation

final class LocalizationManagers: NSObject {
    
    static let shared: LocalizationManagers = LocalizationManagers()
    static let kSelectedLanguage: String = "kSelectedLanguage"
    
    enum LanguageType {
        case fr
        case ar
    }
    
    var selectedLanguage: LanguageType = LanguageType.fr
    
    private var bundle: Bundle? = nil
    
    class func isArabic() -> Bool {
        return shared.selectedLanguage == .ar ? true : false
    }
}
