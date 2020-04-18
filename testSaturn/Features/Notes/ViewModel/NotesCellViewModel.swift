//
//  NotesCellViewModel.swift
//  testSaturn
//
//  Created by Andres Bocanumenth on 4/18/20.
//  Copyright © 2020 Andres Bocanumenth. All rights reserved.
//

import UIKit

class NotesCellViewModel {
    
    var caption: String
    var image: UIImage?
    var syncStatus: SyncStatus
    private let imageURL: String
    
    init(note: NotesDTO) {
        caption = note.caption
        syncStatus = note.imagePath.isEmpty ? .synced : .notSynced
        imageURL = note.imagePath.isEmpty ? note.imageURL : note.imagePath
    }
    
    public func loadImage() -> DataLoadOperation? {
        return DataLoadOperation(imageURL, syncStatus: syncStatus)
    }
}
