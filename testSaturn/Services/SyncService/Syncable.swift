//
//  Syncable.swift
//  testSaturn
//
//  Created by Andres Bocanumenth on 3/26/20.
//  Copyright © 2020 Andres Bocanumenth. All rights reserved.
//

import Foundation
import RealmSwift

public typealias RealmSyncable = Object & Syncable
public typealias SyncableFetchDataResponseHandler = ([RealmSyncable]?, APIServiceError?) -> Void
public typealias RealmSyncableResponseHandler = (RealmSyncable ,Object?, APIServiceError?) -> Void

public struct CrudActions {
    let insertions: [Syncable]
    let modifications: [Syncable]
    let type: RealmSyncable.Type
}

public protocol Syncable: Codable {
    static func fetchData(completion: @escaping SyncableFetchDataResponseHandler)
    func sync(completion: @escaping RealmSyncableResponseHandler)
}

public extension Syncable where Self: Object {
        
    func encoded(using jsonEncoder: JSONEncoder = JSONEncoder()) -> Data? {
        return try? jsonEncoder.encode(self)
    }
    
    static func registerNotificationObserver(for realm: Realm, callback: @escaping (CrudActions) -> Void) -> NotificationToken {
        let objects = realm.objects(self)
        return objects.observe { changes in
            switch changes {
                case .initial(_):
                    break
                case .update(let collection, _ , let insertions, let modifications):
                    let insertedObjects = insertions.map { collection[$0] }
                    let modifiedObjects = modifications.map { collection[$0] }
                    
                    let update = CrudActions(insertions: insertedObjects,
                                             modifications: modifiedObjects,
                                             type: Self.self)
                    callback(update)
                case .error(_):
                    break
            }
        }
    }
}

extension Object {
    func getId() -> String {
        guard let primaryKey = type(of: self).primaryKey() else {
            fatalError("Object can't be managed without a primary key")
        }
        
        guard let id = self.value(forKey: primaryKey) else {
            fatalError("Objects primary key isn't set")
        }
        
        return String(describing: id)
    }
}
