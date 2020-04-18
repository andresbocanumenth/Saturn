//
//  SyncService.swift
//  testSaturn
//
//  Created by Andres Bocanumenth on 3/26/20.
//  Copyright © 2020 Andres Bocanumenth. All rights reserved.
//

import Foundation
import RealmSwift
import Reachability

public class SyncService {
    
    private var realm: Realm!
    private var modelTypes: [RealmSyncable.Type] = [NoteModel.self, OfflineNoteModel.self]
    private var tokens: [NotificationToken]!
    
    init() {
        self.realm = try! Realm()
        setupRealm(modelTypes: modelTypes)
    }
    
    func firstLoad() {
        modelTypes.forEach { (modelType) in
            modelType.fetchData { [weak self] (models, error) in
                guard let strongSelf = self,
                    let models = models else {
                        return
                }
                
                let existingModels = Array(strongSelf.realm.objects(modelType))
                var toInsert: [RealmSyncable] = []
                let existingIds = Set(existingModels.map{ $0.getId() })
                let notesId = Set(models.map{ $0.getId() })
                let newModels = notesId.symmetricDifference(existingIds)
                
                toInsert =  models.filter { (model) -> Bool in
                    newModels.first { $0 == model.getId()} != nil
                }
                if toInsert.count > 0 {
                    try! strongSelf.realm.write {
                        strongSelf.realm.add(toInsert)
                    }
                }
            }
        }
    }
    
    func checkForOfflineSync(modelTypes: [RealmSyncable.Type]) {
        modelTypes.forEach {
            handleOfflineModels(Array(realm.objects($0)) as! [RealmSyncable])
        }
    }
    
    private func setupRealm(modelTypes: [RealmSyncable.Type]) {
        tokens = modelTypes.map { modelType in
            modelType.registerNotificationObserver(for: realm, callback: handleUpdate)
        }
    }
    
    private func handleUpdate(_ crudActions: CrudActions) {
        guard let models = crudActions.insertions as? [RealmSyncable] else {
            return
        }
        handleOfflineModels(models)
    }
    
    private func handleOfflineModels(_ models: [RealmSyncable]) {
        models.forEach { $0.sync(completion: sync(offlineObject:model:error:))}
    }
    
    private func sync(offlineObject: RealmSyncable, model: Object?, error: APIServiceError?) {
        guard let model = model, error == nil else {
            //Logic to handle error
            return
        }
        try! realm.write {
            realm.add(model)
            realm.delete(offlineObject)
        }
    }
}

extension Array where Element : Object {
    func saveRealmArray() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }
}
