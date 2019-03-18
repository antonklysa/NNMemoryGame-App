//
//  String+Extensions.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 4/16/18.
//  Copyright © 2018 Yaroslav Brekhunchenko. All rights reserved.
//

import Foundation

extension String {
    
    func pinCacheStringKey() -> String {
        return self.replacingOccurrences(of: "http://", with: "").replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "/", with: "")
    }
    
}
