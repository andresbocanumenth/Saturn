//
//  OfflineNoteModel.swift
//  testSaturn
//
//  Created by Andres Bocanumenth on 4/18/20.
//  Copyright © 2020 Andres Bocanumenth. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

public class OfflineNoteModel: Object, Syncable, Mappable {
    @objc dynamic var id: Int = 0
    @objc dynamic var caption: String = ""
    @objc dynamic var imagePath: String = ""
    @objc dynamic var imageURL: String = ""
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        caption <- map["title"]
        imageURL <- map["image.urls.small"]
    }
    
    public func sync(completion: @escaping RealmSyncableResponseHandler) {
        if imagePath.isEmpty {
            //            Current.notesService.modify(self)
        } else {
            Current.notesService.insert(self) { (model, error) in
                guard let model = model, error == nil else {
                    completion(self, nil, error)
                    return
                }
                completion(self, model, nil)
            }
        }
    }
    
    public static func fetchData(completion: @escaping SyncableFetchDataResponseHandler) {
        
    }
}
