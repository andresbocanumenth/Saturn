//
//  NotesDataService.swift
//  testSaturn
//
//  Created by Andres Bocanumenth on 3/29/20.
//  Copyright © 2020 Andres Bocanumenth. All rights reserved.
//

import RealmSwift

public typealias createNoteResponseHandler = (Bool) -> Void

class NotesDataService {
    
    private var realm: Realm!
    private var tokens: [NotificationToken]!
    var refreshData: (() -> Void)?
    
    init() {
        self.realm = try! Realm()
        configureObserver()
    }
    
    func configureObserver() {
        let modelTypes = [NoteModel.self, OfflineNoteModel.self] as! [RealmSyncable.Type]
        tokens = modelTypes.map { modelType in
            modelType.registerNotificationObserver(for: realm, callback: { [weak self](_) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.refreshData?()
            })
        }
    }
    
    func fetchNotes() -> [NotesDTO] {
        //Get realm notes from NotesModel and Offline
        let noteModel = Array(realm.objects(NoteModel.self)).map { NotesDTO(model: $0)}.reversed()
        var offlineNotes = Array(realm.objects(OfflineNoteModel.self)).map { NotesDTO(model: $0)}
        offlineNotes.append(contentsOf: noteModel)
        return offlineNotes
    }
    
    func createNote( caption: String, imagePath: String, completion: createNoteResponseHandler) {
        let note = OfflineNoteModel()
        note.caption = caption
        note.imagePath = imagePath
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(note)
            }
            completion(true)
        } catch {
            completion(false)
        }
    }
        
}
