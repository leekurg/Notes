//
//  NoteDataModel.swift
//  Notes
//
//  Created by Ильяяя on 05.06.2022.
//

import CoreGraphics
import Foundation

struct NoteDataModel {
    var id: Int
    var timestamp: Date
    var title: String?
    var description: String?
    var color: CGColor?
}

extension NoteDataModel {
    init( object: NoteDataObject ) {
        id = object.id
        timestamp = object.timestamp
        title = object.title
        description = object.desc
//        color = object.c
    }
    
    init( id: Int ) {
        self.id = id
        timestamp = Date()
    }
}
