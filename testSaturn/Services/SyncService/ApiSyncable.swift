//
//  ApiSyncable.swift
//  testSaturn
//
//  Created by Andres Bocanumenth on 3/27/20.
//  Copyright © 2020 Andres Bocanumenth. All rights reserved.
//

public protocol ApiSyncable {
    func insert(_ model: RealmSyncable, completion: @escaping NoteResponseHandler)
    func modify(_ model: RealmSyncable, completion: @escaping NoteResponseHandler)
}
