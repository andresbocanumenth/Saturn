//
//  NotesListViewModel.swift
//  testSaturn
//
//  Created by Andres Bocanumenth on 3/29/20.
//  Copyright © 2020 Andres Bocanumenth. All rights reserved.
//

import UIKit
import SDWebImage

class NotesListViewModel {
    
    private let notesDataService = NotesDataService()
    
    private var notesDTO: [NotesDTO] = []
    var noteViewModels: [NotesCellViewModel] = []
    var refreshData: (() -> Void)?
    
    init() {
        notesDTO = notesDataService.fetchNotes()
        noteViewModels = notesDTO.map {
            NotesCellViewModel(note: $0)
        }
        configureBindings()
    }
    
    private func configureBindings() {
        notesDataService.refreshData = {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.notesDTO = strongSelf.notesDataService.fetchNotes()
            strongSelf.noteViewModels = strongSelf.notesDTO.map {
                NotesCellViewModel(note: $0)
            }
            strongSelf.refreshData?()
        }
    }
    
    func createNote(caption: String, image: UIImage, completion: createNoteResponseHandler) {
        
        let uuid = UUID().uuidString
        let fileName = "\(uuid).jpg"
        guard let data = image.jpegData(compressionQuality:  0.6),
            let fileURL = fileName.getImageDocumentPath(),
            !FileManager.default.fileExists(atPath: fileURL.path) else {
                completion(false)
                return
        }
        
        do {
            try data.write(to: fileURL)
            notesDataService.createNote(caption: caption, imagePath: fileName) { (success) in
                completion(success)
            }
        } catch {
            completion(false)
        }
    }
}
