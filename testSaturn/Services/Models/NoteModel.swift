//
//  NoteModel.swift
//  testSaturn
//
//  Created by Andres Bocanumenth on 3/26/20.
//  Copyright © 2020 Andres Bocanumenth. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

public class NoteModel: Object, Syncable, Mappable {
    @objc dynamic var id: Int = 0
    @objc dynamic var caption: String = ""
    @objc dynamic var imagePath: String = ""
    @objc dynamic var imageURL: String = ""
    
    required convenience public init?(map: Map) {
        self.init()
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        caption <- map["title"]
        imageURL <- map["image.urls.small"]
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let model = object as? NoteModel else {
            return false
        }
        return id == model.id
    }
    
    public func sync(completion: @escaping RealmSyncableResponseHandler) {
        /// Not used
    }
    
    public static func fetchData(completion: @escaping SyncableFetchDataResponseHandler) {
        Current.notesService.fetchNotes(completion)
    }
}
