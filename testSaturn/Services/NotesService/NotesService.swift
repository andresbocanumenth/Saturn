//
//  NotesService.swift
//  testSaturn
//
//  Created by Andres Bocanumenth on 3/27/20.
//  Copyright © 2020 Andres Bocanumenth. All rights reserved.
//

import UIKit

public typealias NotesResponseHandler = ([NoteModel]?, APIServiceError?) -> Void
public typealias UploadImageResponseHandler = (String?, APIServiceError?) -> Void
public typealias NoteResponseHandler = (NoteModel?, APIServiceError?) -> Void
public typealias ResponseJSON = [String : Any]

public protocol NotesService: APINotesService {
    func fetchNotes(_ completion: @escaping NotesResponseHandler)
    func uploadImageNote(_ image: UIImage, completion: @escaping UploadImageResponseHandler)
    func createNewNote(_ imageId: String, caption: String, completion: @escaping NoteResponseHandler)
}
