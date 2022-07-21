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
    @objc dynamic var scheduled: Date? = nil
    @objc dynamic var title = ""
    @objc dynamic var desc = ""
    @objc dynamic var color = ""
    @objc dynamic var category = ""
    @objc dynamic var image = ""
    @objc dynamic var pinned = false
    
    override class func primaryKey() -> String? {
            return "id"
        }
}
