//
//  Environment.swift
//  testSaturn
//
//  Created by Andres Bocanumenth on 3/26/20.
//  Copyright © 2020 Andres Bocanumenth. All rights reserved.
//

import UIKit

public struct Environment {
    public var date: () -> Date
    public var calendar: Calendar
    public var syncService: SyncService
    public var notesService: NotesService
    public var baseURL: String
    public var counter: Int
    
    public init(date: @escaping () -> Date,
                calendar: Calendar,
                syncService: SyncService,
                notesService: NotesService,
                baseURL: String) {
        self.date = date
        self.calendar = calendar
        self.syncService = syncService
        self.notesService = notesService
        self.baseURL = baseURL
        self.counter = 0
    }
}

extension Environment {
    public static let realm = Environment(date: Date.init,
                                         calendar: .current,
                                         syncService: SyncService(),
                                         notesService: APINotesService(),
                                         baseURL: "https://env-develop.saturn.engineering")
}

public enum APIServiceError: Error {
    case apiError
    case invalidResponse
}

public var Current: Environment = .realm
