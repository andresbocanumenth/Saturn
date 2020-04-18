//
//  NoteDTO.swift
//  testSaturn
//
//  Created by Andres Bocanumenth on 4/18/20.
//  Copyright © 2020 Andres Bocanumenth. All rights reserved.
//

import Foundation

class NotesDTO {
    var id: Int = 0
    var caption: String = ""
    var imagePath: String = ""
    var imageURL: String = ""
    
    init(model: NoteModel) {
        self.id = model.id
        self.caption = model.caption
        self.imagePath = model.imagePath
        self.imageURL = model.imageURL
    }
    
    init(model: OfflineNoteModel) {
        self.id = model.id
        self.caption = model.caption
        self.imagePath = model.imagePath
        self.imageURL = model.imageURL
    }
}
