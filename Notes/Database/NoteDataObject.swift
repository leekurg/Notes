//
//  NoteDataObject.swift
//  Notes
//
//  Created by Ильяяя on 07.06.2022.
//

import RealmSwift

class NoteDataObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var timestamp = Date()
    @objc dynamic var title = ""
    @objc dynamic var desc = ""
//    dynamic var color: CGColor?
}
