//
//  DataOperation.swift
//  testSaturn
//
//  Created by Andres Bocanumenth on 4/18/20.
//  Copyright © 2020 Andres Bocanumenth. All rights reserved.
//

import UIKit
import SDWebImage

class DataLoadOperation: Operation {
    var image: UIImage?
    var loadingCompleteHandler: ((UIImage?) -> ())?
    private var _image: String
    private var syncStatus: SyncStatus
    
    init(_ image: String, syncStatus: SyncStatus) {
        _image = image
        self.syncStatus = syncStatus
    }
    
    override func main() {
        if isCancelled { return }
        guard let url = _image.toURL, syncStatus == .synced else {
            DispatchQueue.main.async() { [weak self] in
                
                guard let strongSelf = self,
                    let fileURL = strongSelf._image.getImageDocumentPath(),
                    FileManager.default.fileExists(atPath: fileURL.path),
                    let image = UIImage(contentsOfFile: fileURL.path) else {
                        return
                }
                if strongSelf.isCancelled { return }
                strongSelf.image = image
                strongSelf.loadingCompleteHandler?(strongSelf.image)
            }
            return
        }
        DispatchQueue.main.async() { [weak self] in
            UIImageView().sd_setImage(with: url) { (image, _, _, _) in
                guard let strongSelf = self else { return }
                if strongSelf.isCancelled { return }
                strongSelf.image = image
                strongSelf.loadingCompleteHandler?(strongSelf.image)
            }
        }
    }
}
