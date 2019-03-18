//
//  DownloadImageOperation.swift
//  PMI
//
//  Created by Yaroslav Brekhunchenko on 11/20/17.
//  Copyright © 2017 Yaroslav Brekhunchenko. All rights reserved.
//

import UIKit
import Alamofire
import PINCache

protocol DownloadImageOperationDelegate: class {
    func downloadImageOperation(_ operation: DownloadImageOperation, didDownloadImage imageURL: String)
    func downloadImageOperation(_ operation: DownloadImageOperation, didFailDownloadingImage imageURL: String)
}

class DownloadImageOperation: Operation {
    
    let imageURL : String
    
    private var done : Bool
    
    weak var delegate: DownloadImageOperationDelegate?

    init(imageURL : String) {
        assert(imageURL.count > 0)
        
        self.imageURL = imageURL
        self.done = false
        
        super.init()
    }
    
    //MARK: Overridden Operation
    
    override var isFinished: Bool {
        get {
            return self.done
        }
    }
    
    override func cancel() {
        super.cancel()
    }
    
    override func main() {
        Alamofire.request(self.imageURL).responseData { response in
            if let data = response.result.value {
                
                let image = UIImage(data: data)
                
                PINCache.shared.diskCache.setObject(image, forKey: self.imageURL.pinCacheStringKey())
                
                self.willChangeValue(forKey: "isFinished")
                self.done = true
                self.didChangeValue(forKey: "isFinished")
                
                if (self.isCancelled == false) {
                    self.delegate?.downloadImageOperation(self, didDownloadImage: self.imageURL)
                }
            } else {
                self.delegate?.downloadImageOperation(self, didFailDownloadingImage: self.imageURL)
            }
        }
    }
    
}
