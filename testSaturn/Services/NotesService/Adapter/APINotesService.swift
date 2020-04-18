//
//  APINotesService.swift
//  testSaturn
//
//  Created by Andres Bocanumenth on 3/27/20.
//  Copyright © 2020 Andres Bocanumenth. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
    
public class APINotesService: NotesService {
    public func fetchNotes(_ completion: @escaping NotesResponseHandler) {
        AF.request(Endpoint.notes.url).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    guard let json = value as? [ResponseJSON] else {
                        completion(nil, .invalidResponse)
                        return
                    }
                    let models = Mapper<NoteModel>().mapArray(JSONArray: json)
                    completion(models, nil)
                    break;
                case .failure(_):
                    completion(nil, .apiError)
                    break
            }
        }
    }
    
    public func uploadImageNote(_ image: UIImage, completion: @escaping UploadImageResponseHandler) {
        let photoEndpoint = Current.baseURL.appending(Endpoint.uploadPhoto.rawValue)
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            return
        }
        AF.upload(multipartFormData: { (multipart) in
            multipart.append(imageData, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
        }, to: photoEndpoint).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    guard let json = value as? ResponseJSON,
                            let imageId = json["id"] as? String else {
                        completion(nil, .invalidResponse)
                        return
                    }
                    completion(imageId, nil)
                    break;
                case .failure(_):
                    completion(nil, .apiError)
                    break
            }
        }
    }
    
    public func createNewNote(_ imageId: String, caption: String, completion: @escaping NoteResponseHandler) {
        let noteEndpoint = Current.baseURL.appending(Endpoint.notes.rawValue)
        let parameters = ["title": caption,
                          "image_id": imageId]
        let headers = [HTTPHeader(name: "accept", value: "application/json"),
                       HTTPHeader(name: "Content-Type", value: "application/json")]
        AF.request(noteEndpoint,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: HTTPHeaders(headers)).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    guard let json = value as? ResponseJSON,
                            let noteModel = NoteModel(JSON: json) else {
                                completion(nil, .invalidResponse)
                        return
                    }
                    completion(noteModel, nil)
                    break;
                case .failure(_):
                    completion(nil, .apiError)
                    break
            }
        }
    }
    
    public func insert(_ model: RealmSyncable, completion: @escaping NoteResponseHandler) {        
        guard let noteModel = model as? OfflineNoteModel,
            let fileURL = noteModel.imagePath.getImageDocumentPath(),
            FileManager.default.fileExists(atPath: fileURL.path),
            let image = UIImage(contentsOfFile: fileURL.path) else {
                completion(nil, .invalidResponse)
            return
        }
        uploadImageNote(image) { [weak self] (imageId, error) in
            guard let strongSelf = self,
                let imageId = imageId, error == nil  else {
                    completion(nil, error)
                return
            }
            strongSelf.createNewNote(imageId, caption: noteModel.caption) { (model, error) in
                guard let model = model, error == nil else {
                    completion(nil, error)
                    return
                }
                completion(model, nil)
            }
        }
    }
    
    public func modify(_ model: RealmSyncable, completion: @escaping NoteResponseHandler) {
        //TO-DO: create modify endpoint.
    }
}

fileprivate enum Endpoint: String {
    case notes = "/api/v2/test-notes"
    case uploadPhoto = "/api/v2/test-notes/photo"
}

fileprivate extension Endpoint {
    var url : String {
        return Current.baseURL.appending(self.rawValue)
    }
}
